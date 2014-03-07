//
//  MyScene.h
//  PathKitExample
//

//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <PathKit/PKPathKit.h>

@interface MySceneAdvanced : SKScene

@property (nonatomic, strong) PKPath *path;
@property (nonatomic, strong) SKShapeNode *pathNode;
@property (assign) CGPathRef pathRef;

@end
