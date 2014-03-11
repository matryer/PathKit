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
  [_methods addObject:@"pathNode:didCreateNewPath:"];
  [_lastArgs addObject:[NSArray arrayWithObjects:node, path, nil]];
}

- (void)pathNode:(PKPathNode *)node didChangePath:(PKPath *)path {
  [_methods addObject:@"pathNode:didChangePath:"];
  [_lastArgs addObject:[NSArray arrayWithObjects:node, path, nil]];
}

- (void)reset {
  _methods = [[NSMutableArray alloc] init];
  _lastArgs = [[NSMutableArray alloc] init];
}

@end
