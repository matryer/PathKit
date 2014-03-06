//
//  PKPathNode.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "PKPathNode.h"
#import "PKPath.h"
#import "PKPathNodeDelegate.h"

@interface PKPathNode ()
@property (strong, readwrite) PKPath *_path;
@end

@implementation PKPathNode

- (id)initWithTolerance:(PKTolerance)tolerance {
  if (self = [super init]) {
    
    _tolerance = tolerance;
    
  }
  return self;
}

- (PKPath *)path {
  
  if (self._path == nil) {
    
    // make a new path
    self._path = [[PKPath alloc] initWithTolerance:self.tolerance pathChangedBlock:^(PKPath *thePath) {
      [self pathChanged:thePath];
    }];
    
    // tell the delegate
    if ([self.delegate respondsToSelector:@selector(pathNode:didCreateNewPath:)]) {
      [self.delegate pathNode:self didCreateNewPath:self._path];
    }
    
  }
  
  return self._path;
  
}
- (void)setPath:(PKPath *)path {
  
}

- (void)pathChanged:(PKPath *)path {
  
}

- (void)addPoint:(CGPoint)point {
}

@end
