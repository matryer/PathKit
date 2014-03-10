//
//  TestPKPathNodeDelegateMaxLength.m
//  PathKit
//
//  Created by Mat Ryer on 3/10/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "TestPKPathNodeDelegateMaxLength.h"

@implementation TestPKPathNodeDelegateMaxLength

- (void)pathNode:(PKPathNode *)node reachedMaximumLengthForPath:(PKPath *)path {
  _lastMethod = @"pathNode:reachedMaximumLengthForPath:";
  _lastArgs = [NSArray arrayWithObjects:node, path, nil];
}

@end