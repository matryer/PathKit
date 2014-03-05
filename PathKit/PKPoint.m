//
//  PKPoint.m
//  PathKit
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "PKPoint.h"

@implementation PKPoint

- (NSString *) description {
  return [NSString stringWithFormat:@"%g x %g", self.x, self.y];
}

- (PKPoint *) copy {
  return PKPointMake(self.x, self.y);
}

@end
