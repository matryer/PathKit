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

@interface PKPathNode : SKShapeNode

- (id) initWithTolerance:(PKTolerance)tolerance;

@property (assign, readonly) PKTolerance tolerance;

@end
