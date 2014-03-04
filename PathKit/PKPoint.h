//
//  PKPoint.h
//  PathKit
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PKPoint : NSObject
@property (assign) CGFloat x;
@property (assign) CGFloat y;
@end

CG_INLINE PKPoint*
PKPointMake(CGFloat x, CGFloat y)
{
  PKPoint *p = [[PKPoint alloc] init]; p.x = x; p.y = y; return p;
}
