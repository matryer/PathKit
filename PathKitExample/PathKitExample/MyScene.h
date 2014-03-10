//
//  MyScene.h
//  PathKitExample
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PKPathKit.h"
@class PKPathNode;

@interface MyScene : SKScene <PKPathNodeDelegate>

@property (strong, readonly) PKPathNode *pathNode;
@property (strong) SKSpriteNode *plane;

@end
