//
//  PKPathNodeTests.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SpriteKit/SpriteKit.h>
#import "PKPathNode.h"
#import "PKPoint.h"

@interface PKPathNodeTests : XCTestCase

@end

@implementation PKPathNodeTests

- (void)testInit {
  
  PKPathNode *node = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  
  XCTAssertNotNil(node);
  XCTAssertEqual((CGFloat)10, node.tolerance.width);
  XCTAssertEqual((CGFloat)10, node.tolerance.height);
  
}

- (void)testAddPoint {
  
  //PKPathNode *node = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  //XCTAssertNil(node.pathController);
  
  //[node addPoint:PKPointMake(10,10)];
  
}

@end
