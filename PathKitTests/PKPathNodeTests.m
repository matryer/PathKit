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
#import "TestPKPathNodeDelegateMaxLength.h"

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
  [pathNode setMaximumLength:[NSNumber numberWithFloat:100]];
  
  PKPath *path = [pathNode pkPath];
  
  // a path should have been created
  XCTAssertNotNil(path);
  XCTAssertEqual([path.maximumLength floatValue], (float)100);
  XCTAssertEqualObjects(@"pathNode:didCreateNewPath:", [delegate.methods objectAtIndex:0]);
  XCTAssertEqualObjects(pathNode, [[delegate.lastArgs objectAtIndex:0] objectAtIndex:0]);
  XCTAssertEqualObjects(path, [[delegate.lastArgs objectAtIndex:0] objectAtIndex:1]);
  
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
  
  XCTAssertEqual(pathNode.startPoint.x, (CGFloat)50);
  XCTAssertEqual(pathNode.startPoint.y, (CGFloat)50);
  
  CGPathRef pathRef = pathNode.path;
  
  if (pathRef) {

  XCTAssertEqualObjects(@"pathNode:didCreateNewPath:", [delegate.methods objectAtIndex:0]);
  XCTAssertEqualObjects(pathNode, [[delegate.lastArgs objectAtIndex:0] objectAtIndex:0]);
  XCTAssertEqual((NSUInteger)1, [pathNode.pkPath.points count]);

  // reset the test delegate
  [delegate reset];
  
  // set the another point
  [pathNode addPoint:CGPointMake(60, 60)];
  
  CGPathRef pathRef2 = pathNode.path;

    if (pathRef2) {
      XCTAssertEqual((NSUInteger)2, [pathNode.points count]);
    }
    
  }
  
}

- (void)testDidChangePathDelegateCall {
  
  TestPKPathNodeDelegate *delegate = [[TestPKPathNodeDelegate alloc] init];
  PKPathNode *pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(5,5)];
  [pathNode setDelegate:delegate];
  
  // set the first point
  [pathNode addPoint:CGPointMake(50, 50)];
  
  XCTAssertEqualObjects(@"pathNode:didChangePath:", [delegate.methods objectAtIndex:1]);
  XCTAssertEqualObjects(pathNode, [[delegate.lastArgs objectAtIndex:1] objectAtIndex:0]);

  [delegate reset];
  
  // set another point
  [pathNode addPoint:CGPointMake(70, 70)];
  
  XCTAssertEqualObjects(@"pathNode:didChangePath:", [delegate.methods objectAtIndex:0]);
  XCTAssertEqualObjects(pathNode, [[delegate.lastArgs objectAtIndex:0] objectAtIndex:0]);

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

- (void)testMaximumLength {
  
  TestPKPathNodeDelegateMaxLength *delegate = [[TestPKPathNodeDelegateMaxLength alloc] init];
  PKPathNode *pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10,10)];
  [pathNode setDelegate:delegate];

  [pathNode setMaximumLength:[NSNumber numberWithFloat:100]];
  
  [pathNode addPoint:CGPointMake(0, 0)];
  [pathNode addPoint:CGPointMake(50, 0)];
  
  XCTAssertFalse(pathNode.maximumLengthReached);
  
  [pathNode addPoint:CGPointMake(101, 0)];
  
  XCTAssertEqualObjects(@"pathNode:reachedMaximumLengthForPath:", delegate.lastMethod);
  XCTAssertEqualObjects(pathNode, [delegate.lastArgs objectAtIndex:0]);
  XCTAssertTrue(pathNode.maximumLengthReached);
  
}

@end
