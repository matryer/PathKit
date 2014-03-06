//
//  PKPathNodeTests.m
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SpriteKit/SpriteKit.h>
#import "PKPathNodeDelegate.h"
#import "PKPathNode.h"
#import "PKPoint.h"
#import "TestPKPathNodeDelegate.h"

@interface PKPathNodeTests : XCTestCase

@end

@implementation PKPathNodeTests

- (void)testInit {
  
  PKPathNode *node = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  
  XCTAssertNotNil(node);
  XCTAssertEqual((CGFloat)10, node.tolerance.width);
  XCTAssertEqual((CGFloat)10, node.tolerance.height);
  
}

- (void)testPath {
  
  TestPKPathNodeDelegate *delegate = [[TestPKPathNodeDelegate alloc] init];
  PKPathNode *node = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  [node setDelegate:delegate];
  
  PKPath *path = [node path];
  
  // a path should have been created
  XCTAssertNotNil(path);
  XCTAssertEqualObjects(@"pathNode:didCreateNewPath:", delegate.lastMethod);
  XCTAssertEqualObjects(node, [delegate.lastArgs objectAtIndex:0]);
  XCTAssertEqualObjects(path, [delegate.lastArgs objectAtIndex:1]);
  
  
}

@end
