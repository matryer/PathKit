//
//  PKPath.m
//  PathKit
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "PKPath.h"
#import "PKPoint.h"

@interface PKPath ()
@property (strong) NSMutableArray *thePoints;
@end

@implementation PKPath

// TODO: should be be a mutex?
BOOL _useToleranceAsMaximumDistanceBusy = NO;

- (id) initWithTolerance:(CGSize)tolerance {
  if (self = [super init]) {
    _tolerance = tolerance;
    _useToleranceAsMaximumDistance = YES;
    _snapStartPointToTolerance = YES;
  }
  return self;
}

- (id) initWithTolerance:(CGSize)tolerance pathChangedBlock:(PKPathChangedBlock)pathChangedBlock {
  if (self = [self initWithTolerance:tolerance]) {
    _pathChangedBlock = pathChangedBlock;
  }
  return self;
}

- (CGMutablePathRef) makeCGPath {
  
  CGMutablePathRef path = CGPathCreateMutable();
  
  // move to first point (start point)
  CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);
  
  // add each additional point
  [self.thePoints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    if (idx > 0) { // skip first one
      PKPoint *point = (PKPoint*)obj;
      CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    
  }];
  
  return path;
}

/**
 * Actually adds to the _points array.  Returns whether more calls to
 * this method are acceptable or not.  YES means there is no reason why
 * the operation should stop, NO means there is (e.g. we have reached the
 * maximumLength.)
 */
- (BOOL) actuallyAddPoint:(PKPoint *)point {
  
  // pointLength is the distance from the last point to this one
  CGFloat pointLength = _lastPoint != nil ? [PKPath distanceBetweenPoint:_lastPoint toPoint:point] : 0;
  CGFloat maxLength = [self.maximumLength floatValue];
  BOOL hasMaxLength = (self.maximumLength != nil);
  
  // if there is a maximumLength, would the new length be too long?
  CGFloat newLength = pointLength + self.length;
  
  BOOL shouldAddPoint = YES;
  
  // will this push us over the maximum?
  if (hasMaxLength && newLength > maxLength) {
    
    CGFloat overshoot = newLength - maxLength;
    
    PKDelta delta = [PKPath deltaFromPoint:_lastPoint toPoint:point];
    
    NSLog(@"pointLength: %g", pointLength);
    NSLog(@"Point before: %@", point);

    if (delta.width == 0) {
      // vertical line
      NSLog(@"--- Vertical line");
      if (delta.height < 0) {
        point.y += overshoot;
      } else {
        point.y -= overshoot;
      }
    } else if (delta.height == 0) {
      // horizontal line
      NSLog(@"--- horizontal line");
      if (delta.width < 0) {
        point.x += overshoot;
      } else {
        point.x -= overshoot;
      }
    } else {
      
      CGFloat targetPointLength = pointLength - overshoot;
      CGFloat scale = targetPointLength / pointLength;
      
      NSLog(@"targetPointLength: %g", targetPointLength);
      NSLog(@"ratio: %g", scale);
      
      point.x = _lastPoint.x + (delta.width * scale);
      point.y = _lastPoint.y + (delta.height * scale);
      
    }
    NSLog(@"Point after: %@", point);

    shouldAddPoint = ((pointLength = [PKPath distanceBetweenPoint:_lastPoint toPoint:point]) > 0);
    
    NSLog(@"shouldAddPoint: %@", shouldAddPoint ? @"YES" : @"NO");
  }
  
  if (shouldAddPoint) {
  
    // add the point
    if (self.thePoints == nil) {
      self.thePoints = [[NSMutableArray alloc] initWithObjects:point, nil];
    } else {
      [self.thePoints addObject:point];
    }
    
    // update the total length
    _length += pointLength;
    
    // set the new last point
    _lastPoint = point;
    
  }
  
  if (hasMaxLength && _length >= maxLength) {
    
    // should we call the meximum reached block?
    if (self.maximumLengthReachedBlock != nil) {
      self.maximumLengthReachedBlock(self);
    }
    
    // returning NO means don't call this method any
    // more
    return NO;
  }
  
  return YES;
  
}

/**
 * addPoint adds a new point to the path, assuming it's within tolerances.
 */
- (BOOL) addPoint:(PKPoint *)point {
  
  // ignore points if we're still working
  if (_useToleranceAsMaximumDistanceBusy) return NO;
  
  BOOL shouldCallBlock = NO;
  BOOL canAcceptMorePoints = YES;
  
  if ([self.thePoints count] == 0) {
    // first point
    
    if (self.snapStartPointToTolerance) {
      point = PKPointMake(_tolerance.width * floor((point.x / _tolerance.width) + 0.5), _tolerance.height * floor((point.y / _tolerance.height) + 0.5));
    }
    
    _startPoint = [point copy];
    shouldCallBlock = YES;
    canAcceptMorePoints = [self actuallyAddPoint:point];
    
  } else {
    // subsequent points
    
    PKDelta delta = [PKPath deltaFromPoint:_lastPoint toPoint:point];
    PKDeltaFactor factor = [PKPath factorForDelta:delta perTolerance:self.tolerance];
    
    if (![PKPath isZeroFactor:factor]) {
      
      // this will be an update
      shouldCallBlock = YES;
      
      if (self.useToleranceAsMaximumDistance) {
        
        /*
         * snap the point to the nearest accepted value in the tolerance
         * grid, but also, create enough points from A to B.
         */
        
        _useToleranceAsMaximumDistanceBusy = YES;
        
        BOOL xIsPos = delta.width >= 0 ? YES : NO;
        BOOL yIsPos = delta.width >= 0 ? YES : NO;
        
        // iterate over the delta until we reach the target point
        CGFloat moveX = self.tolerance.width * (xIsPos ? 1 : -1);
        CGFloat moveY = self.tolerance.height * (yIsPos? 1 : -1);
        CGFloat targetX = _lastPoint.x + (self.tolerance.width * factor.width);
        CGFloat targetY = _lastPoint.y + (self.tolerance.height * factor.height);
        
        PKPoint *current = [_lastPoint copy];
        while (current.x != targetX || current.y != targetY) {
          
          if (xIsPos) {
            if (current.x < targetX)
              current.x += moveX;
            else
              current.x = targetX;
          } else {
            if (current.x > targetX)
              current.x += moveX;
            else
              current.x = targetX;
          }
          
          if (yIsPos) {
            if (current.y < targetY)
              current.y += moveY;
            else
              current.y = targetY;
          } else {
            if (current.y > targetY)
              current.y += moveY;
            else
              current.y = targetY;
          }
          
          // add this point
          if (!(canAcceptMorePoints = [self actuallyAddPoint:[current copy]])) {
            break;
          }
          
        }
        
        _useToleranceAsMaximumDistanceBusy = NO;
        
      } else {
        
        // just add the point - don't try to be clever
        canAcceptMorePoints = [self actuallyAddPoint:point];
        
      }
      
    }
    
  }
  
  if (shouldCallBlock) {
    if (self.pathChangedBlock != nil)
      self.pathChangedBlock(self);
  }
  
  return canAcceptMorePoints;
}

- (NSArray *) points {
  return [NSArray arrayWithArray:self.thePoints];
}

#pragma mark - Helpers

+ (PKDelta) deltaFromPoint:(PKPoint *)fromPoint toPoint:(PKPoint *)toPoint {
  return CGSizeMake(toPoint.x - fromPoint.x, toPoint.y - fromPoint.y);
}

+ (CGFloat) distanceBetweenPoint:(PKPoint *)pointA toPoint:(PKPoint *)pointB {
  PKDelta delta = [PKPath deltaFromPoint:pointA toPoint:pointB];
  return sqrtf(powf(delta.width, 2) + powf(delta.height, 2));
}

+ (PKDeltaFactor) factorForDelta:(PKDelta)delta perTolerance:(PKTolerance)tolerance {
  
  NSInteger fx = delta.width < 0 ? -1 : 1;
  NSInteger fy = delta.height < 0 ? -1 : 1;
  
  CGFloat x = fx * floor(ABS(delta.width) / tolerance.width);
  CGFloat y = fy * floor(ABS(delta.height) / tolerance.height);
  
  // fix -0 issue see http://stackoverflow.com/questions/9657993/negative-zero-in-c
  if (x == 0) x = 0;
  if (y == 0) y = 0;
  
  return CGSizeMake(x, y);
  
}

+ (BOOL) isZeroFactor:(PKDeltaFactor)factor {
  return factor.width == 0 && factor.height == 0;
}

@end
