//
//  TestPKPathNodeDelegate.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "TestPKPathNodeDelegate.h"

@implementation TestPKPathNodeDelegate

- (void)pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path {
  _lastMethod = @"pathNode:didCreateNewPath:";
  _lastArgs = [NSArray arrayWithObjects:node, path, nil];
}

@end
