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

- (id) initWithTolerance:(CGSize)tolerance {
  if (self = [super init]) {
    _tolerance = tolerance;
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

- (BOOL) addPoint:(PKPoint *)point {
  
  BOOL shouldCallBlock = NO;
  
  if ([self.thePoints count] == 0) {
    _startPoint = _lastPoint = point;
    shouldCallBlock = YES;
    [self actuallyAddPoint:point];
  } else {
    
    PKDelta delta = [PKPath deltaFromPoint:_lastPoint toPoint:point];
    PKDeltaFactor factor = [PKPath factorForDelta:delta perTolerance:self.tolerance];
    
    if (![PKPath isZeroFactor:factor]) {
      NSLog(@"Delta: %g x %g, Factor: %g x %g, Tolerance: %g x %g", delta.width, delta.height, factor.width, factor.height, self.tolerance.width, self.tolerance.height);
      _lastPoint = point;
      shouldCallBlock = YES;
      [self actuallyAddPoint:point];
    }
    
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
