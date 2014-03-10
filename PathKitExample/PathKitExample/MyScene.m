//
//  MyScene.m
//  PathKitExample
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor whiteColor];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    
    myLabel.text = @"Draw a path!";
    myLabel.color = [SKColor grayColor];
    myLabel.fontSize = 20;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    // make a new path node
    _pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(20, 20)];
    [_pathNode setDelegate:self];
    [_pathNode setMaximumLength:[NSNumber numberWithFloat:2000]];
    
    // setup formatting for the path
    [_pathNode setStrokeColor:[UIColor blackColor]];
    [_pathNode setLineWidth:1];
    [_pathNode setGlowWidth:0];
    
    [self addChild:_pathNode];
    
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  // remove the plane
  [self.plane removeFromParent];
  
  // start a new path
  [self.pathNode clearPath];
  
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  // are we still within our maximum?
  if (!self.pathNode.maximumLengthReached) {
  
    // add this point
    CGPoint touchPosition = [[touches anyObject] locationInNode:self];
    [self.pathNode addPoint:touchPosition];
      
  }
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

  NSLog(@"Using the path to move the plane...");
  
  // get a plane and make it fly the path
  if (self.plane == nil) {
    self.plane = [SKSpriteNode spriteNodeWithImageNamed:@"plane"];
  }
  
  CGPathRef path = [self.pathNode.pkPath makeCGPath];
  SKAction *followPath = [SKAction followPath:path asOffset:NO orientToPath:YES duration:self.pathNode.pkPath.length / 100];
  
  // add the plane
  [self addChild:self.plane];
 
  [self.plane runAction:followPath];
  
}

#pragma mark - PKPathNodeDelegate

- (void)pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path {
  
  NSLog(@"A new PKPathNode has been created - let's configure it");
  
  [path setUseToleranceAsMaximumDistance:YES];
  [path setSnapStartPointToTolerance:YES];
  
}

- (void)pathNode:(PKPathNode *)node reachedMaximumLengthForPath:(PKPath *)path {
  
  NSLog(@"Maximum length reached!");
  
}

@end
