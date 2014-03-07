//
//  MyScene.m
//  PathKitExample
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import "MyScene_Advanced.h"

@implementation MySceneAdvanced

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
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  // start a new path every time they begin a touch
  if (self.path != nil) {
    
    NSLog(@"Starting a new path...");

    // kill the PKPath
    self.path = nil;
    
  }
  
  // make a new PKPath
  self.path = [[PKPath alloc] initWithTolerance:CGSizeMake(5,5) pathChangedBlock:^(PKPath *thePath) {
    
    // the path has changed - update it
    
    // create the path
    if (self.pathNode == nil) {
      
      // if there's no path - add one
      self.pathNode = [SKShapeNode node];
      [self.pathNode setStrokeColor:[UIColor whiteColor]];
      [self addChild:self.pathNode];
      
    } else {
      // there was an old path - release it
      CGPathRelease(self.pathRef);
    }
  
    // get the CGPathRef from the PXPath
    self.pathRef = [thePath makeCGPath];
    self.pathNode.path = self.pathRef;
    
  }];
  [self.path setUseToleranceAsMaximumDistance:YES];
  [self.path setSnapStartPointToTolerance:YES];
  
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  CGPoint touchPosition = [[touches anyObject] locationInNode:self];
  [self.path addPoint:PKPointMake(touchPosition.x, touchPosition.y)];
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  NSLog(@"%@", [self.path points]);
  
}

-(void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

@end
