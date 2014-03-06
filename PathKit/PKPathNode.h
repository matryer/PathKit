//
//  PKPathNode.h
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PKCommon.h"
@class PKPath;
@protocol PKPathNodeDelegate;

@interface PKPathNode : NSObject

- (id) initWithTolerance:(PKTolerance)tolerance;

@property (assign, readonly) PKTolerance tolerance;
@property (assign, readwrite) id<PKPathNodeDelegate> delegate;

/**
 * Adds a CGPoint to the path.
 */
- (void) addPoint:(CGPoint)point;

- (PKPath *)path;
- (void)setPath:(PKPath*)path;

@end
