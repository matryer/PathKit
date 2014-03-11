//
//  PKPathNode.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "PKPathNode.h"
#import "PKPath.h"
#import "PKPoint.h"
#import "PKPathNodeDelegate.h"

@interface PKPathNode ()
@property (strong, readwrite) PKPath *_pkpath;
@end

@implementation PKPathNode

- (id)initWithTolerance:(PKTolerance)tolerance {
  if (self = [super init]) {
    
    _tolerance = tolerance;
    
  }
  return self;
}

- (void)dealloc {
  self.path = nil;
}

- (CGPoint) startPoint {
  return CGPointMake(self.pkPath.startPoint.x, self.pkPath.startPoint.y);
}

- (PKPath *)pkPath {
  
  if (self._pkpath == nil) {
    
    __block PKPathNode *that = self;
    // make a new path
    self._pkpath = [[PKPath alloc] initWithTolerance:self.tolerance pathChangedBlock:^(PKPath *thePath) {
      [that pathChanged:thePath];
    }];
    
    // listen for maximum length warning too
    self._pkpath.maximumLengthReachedBlock = ^(PKPath *thePath){
      [that reachedMaximumLengthForPath:thePath];
    };
    
    // set the maximum length
    self._pkpath.maximumLength = self.maximumLength;
    
    // tell the delegate
    if ([self.delegate respondsToSelector:@selector(pathNode:didCreateNewPath:)]) {
      [self.delegate pathNode:self didCreateNewPath:self._pkpath];
    }
    
  }
  
  return self._pkpath;
  
}

- (void)setPkPath:(PKPath *)path {
  self._pkpath = path;
}

- (CGPathRef)makeCGPath {
  
  // will the delegate provide the CGPathRef?
  if ([self.delegate respondsToSelector:@selector(pathNode:makeCGPathForPKPath:)]) {
    return [self.delegate pathNode:self makeCGPathForPKPath:self.pkPath];
  } else {
    return [self.pkPath makeCGPath];
  }
  
}

- (void)pathChanged:(PKPath *)path {
  
  // create a new path - and set it
  self.path = nil;
  self.path = [self makeCGPath];
  
}

- (void)reachedMaximumLengthForPath:(PKPath*)path {
  if ([self.delegate respondsToSelector:@selector(pathNode:reachedMaximumLengthForPath:)]) {
    [self.delegate pathNode:self reachedMaximumLengthForPath:path];
  }
}

- (BOOL) maximumLengthReached {
  return self.pkPath.maximumLengthReached;
}

- (void)addPoint:(CGPoint)point {
  [self.pkPath addPoint:PKPointMake(point.x, point.y)];
}

- (NSArray *)points {
  return self.pkPath.points;
}

- (void)clearPath {
  self.path = nil;
  self._pkpath = nil;
}

@end
