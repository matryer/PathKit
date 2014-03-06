//
//  PKPathNode.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "PKPathNode.h"

@implementation PKPathNode

- (id) initWithTolerance:(PKTolerance)tolerance {
  if (self = [super init]) {
    
    _tolerance = tolerance;
    
  }
  return self;
}

@end
