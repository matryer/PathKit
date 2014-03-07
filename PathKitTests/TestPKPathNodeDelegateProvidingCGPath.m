//
//  TestPKPathNodeDelegateProvidingCGPath.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "TestPKPathNodeDelegateProvidingCGPath.h"

@implementation TestPKPathNodeDelegateProvidingCGPath

- (CGPathRef)pathNode:(PKPathNode *)node makeCGPathForPKPath:(PKPath *)path {
  _lastMethod = @"pathNode:cgPathForPKPath:";
  _lastArgs = [NSArray arrayWithObjects:node, path, nil];
  return nil;
}

- (void)reset {
  _lastMethod = @"";
  _lastArgs = [NSArray arrayWithObjects:nil];
}

@end
