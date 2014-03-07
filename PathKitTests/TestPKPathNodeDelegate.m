//
//  TestPKPathNodeDelegate.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "TestPKPathNodeDelegate.h"

@implementation TestPKPathNodeDelegate

- (id) init {
  if (self = [super init]) {
    [self reset];
  }
  return self;
}

- (void)pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path {
  _lastMethod = @"pathNode:didCreateNewPath:";
  _lastArgs = [NSArray arrayWithObjects:node, path, nil];
}

- (void)reset {
  _lastMethod = @"";
  _lastArgs = [NSArray arrayWithObjects:nil];
}

@end
