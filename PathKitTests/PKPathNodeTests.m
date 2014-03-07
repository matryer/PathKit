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
#import "PKPath.h"
#import "PKPoint.h"
#import "TestPKPathNodeDelegate.h"
#import "TestPKPathNodeDelegateProvidingCGPath.h"

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
  PKPathNode *pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  [pathNode setDelegate:delegate];
  
  PKPath *path = [pathNode pkPath];
  
  // a path should have been created
  XCTAssertNotNil(path);
  XCTAssertEqualObjects(@"pathNode:didCreateNewPath:", delegate.lastMethod);
  XCTAssertEqualObjects(pathNode, [delegate.lastArgs objectAtIndex:0]);
  XCTAssertEqualObjects(path, [delegate.lastArgs objectAtIndex:1]);
  
  // set the path
  PKPath *path2 = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5)];
  
  pathNode.pkPath = path2;
  
  XCTAssertEqualObjects(pathNode.pkPath, path2, @"setPath");
  
}

- (void)testAddPoint {
  
  TestPKPathNodeDelegate *delegate = [[TestPKPathNodeDelegate alloc] init];
  PKPathNode *pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  [pathNode setDelegate:delegate];

  // set the first point
  [pathNode addPoint:CGPointMake(50, 50)];
  
  CGPathRef pathRef = pathNode.path;
  
  XCTAssertEqualObjects(@"pathNode:didCreateNewPath:", delegate.lastMethod);
  XCTAssertEqualObjects(pathNode, [delegate.lastArgs objectAtIndex:0]);
  XCTAssertEqual((NSUInteger)1, [pathNode.pkPath.points count]);

  // reset the test delegate
  [delegate reset];
  
  // set the another point
  [pathNode addPoint:CGPointMake(60, 60)];
  
  CGPathRef pathRef2 = pathNode.path;

  XCTAssertEqual((NSUInteger)2, [pathNode.points count]);
  XCTAssertNotEqual(pathRef, pathRef2);
  
}

- (void)testMakeCGPathForPKPath {
  
  TestPKPathNodeDelegateProvidingCGPath *delegate = [[TestPKPathNodeDelegateProvidingCGPath alloc] init];
  PKPathNode *pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  [pathNode setDelegate:delegate];

  [pathNode makeCGPath];
  
  XCTAssertEqualObjects(@"pathNode:cgPathForPKPath:", delegate.lastMethod);
  XCTAssertEqualObjects(pathNode, [delegate.lastArgs objectAtIndex:0]);
  XCTAssertEqualObjects(pathNode.pkPath, [delegate.lastArgs objectAtIndex:1]);

}

@end
