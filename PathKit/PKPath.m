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

BOOL _useToleranceAsMaximumDistanceBusy = NO;

- (id) initWithTolerance:(CGSize)tolerance {
  if (self = [super init]) {
    _tolerance = tolerance;
    _useToleranceAsMaximumDistance = NO;
  }
  return self;
}

- (id) initWithTolerance:(CGSize)tolerance pathChangedBlock:(PKPathChangedBlock)pathChangedBlock {
  if (self = [self initWithTolerance:tolerance]) {
    _pathChangedBlock = pathChangedBlock;
  }
  return self;
}

/**
 Actually adds to the _points array.
 */
- (void) actuallyAddPoint:(PKPoint *)point {
  if (self.thePoints == nil) {
    self.thePoints = [[NSMutableArray alloc] initWithObjects:point, nil];
  } else {
    [self.thePoints addObject:point];
  }
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
 * addPoint adds a new point to the path, assuming it's within tolerances.
 */
- (BOOL) addPoint:(PKPoint *)point {
  
  // ignore points if we're still working
  if (_useToleranceAsMaximumDistanceBusy) return NO;
  
  BOOL shouldCallBlock = NO;
  
  if ([self.thePoints count] == 0) {
    // first point
    
    if (self.snapStartPointToTolerance) {
      point = PKPointMake(_tolerance.width * floor((point.x / _tolerance.width) + 0.5), _tolerance.height * floor((point.y / _tolerance.height) + 0.5));
    }
    
    _startPoint = _lastPoint = [point copy];
    shouldCallBlock = YES;
    [self actuallyAddPoint:point];
    
  } else {
    // subsequent points
    
    PKDelta delta = [PKPath deltaFromPoint:_lastPoint toPoint:point];
    PKDeltaFactor factor = [PKPath factorForDelta:delta perTolerance:self.tolerance];
    
    if (![PKPath isZeroFactor:factor]) {
      
      // this will be an update
      shouldCallBlock = YES;
      
      if (self.useToleranceAsMaximumDistance) {
        _useToleranceAsMaximumDistanceBusy = YES;
        
        BOOL xIsPos = delta.width >= 0 ? YES : NO;
        BOOL yIsPos = delta.width >= 0 ? YES : NO;
        
        // iterate over the delta until we reach the target point
        CGFloat moveX = self.tolerance.width * (xIsPos ? 1 : -1);
        CGFloat moveY = self.tolerance.height * (yIsPos? 1 : -1);
        CGFloat targetX = _lastPoint.x + (self.tolerance.width * factor.width);
        CGFloat targetY = _lastPoint.y + (self.tolerance.height * factor.height);
        
        //NSLog(@"move: %g x %g", moveX, moveY);
        //NSLog(@"target: %g x %g", targetX, targetY);
        
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
          [self actuallyAddPoint:[current copy]];
          _lastPoint = current;
          
        }
        
        _useToleranceAsMaximumDistanceBusy = NO;
      } else {
        
        // just add the point - don't try to be clever
        [self actuallyAddPoint:point];
        _lastPoint = point;
        
      }
      
    }// else {
      //NSLog(@"Zero factor - ignoring");
    //}
    
  }
  
  if (shouldCallBlock) {
    if (self.pathChangedBlock != nil)
      self.pathChangedBlock(self);
  }
  
  return YES;
}

- (NSArray *) points {
  return [NSArray arrayWithArray:self.thePoints];
}

#pragma mark - Helpers

+ (PKDelta) deltaFromPoint:(PKPoint *)fromPoint toPoint:(PKPoint *)toPoint {
  return CGSizeMake(toPoint.x - fromPoint.x, toPoint.y - fromPoint.y);
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
