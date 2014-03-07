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
    _pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(30, 30)];
    [_pathNode setDelegate:self];
    
    // setup formatting for the path
    [_pathNode setStrokeColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    
    [self addChild:_pathNode];
    
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // start a new path
  [self.pathNode clearPath];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  // add this point
  CGPoint touchPosition = [[touches anyObject] locationInNode:self];
  [self.pathNode addPoint:touchPosition];
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // do something with the path
}

#pragma mark - PKPathNodeDelegate

- (void)pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path {
  [path setUseToleranceAsMaximumDistance:YES];
  [path setSnapStartPointToTolerance:YES];
}

@end
