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
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Draw a path!";
    myLabel.fontSize = 20;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    // make a new path node
    _pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(5, 5)];
    [_pathNode setDelegate:self];
    [_pathNode setMaximumLength:[NSNumber numberWithFloat:2000]];
    
    // setup formatting for the path
    [_pathNode setStrokeColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [_pathNode setLineWidth:1];
    [_pathNode setGlowWidth:0];
    
    [self addChild:_pathNode];
    
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
  // do something with the path
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
