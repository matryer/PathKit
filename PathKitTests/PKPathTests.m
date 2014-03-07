//
//  PathKitTests.m
//  PathKitTests
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PKPathKit.h"

@interface PKPathTests : XCTestCase

@end

@implementation PKPathTests

- (void)testInitWithTolerance {
  
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(25, 35)];
  XCTAssertNil(path.pathChangedBlock);
  
  XCTAssertEqual(path.tolerance.width, (CGFloat)25);
  XCTAssertEqual(path.tolerance.height, (CGFloat)35);
  
}

- (void)testInitWithTolerancePathChangedBlock {
  
  PKPathChangedBlock block = ^(PKPath* thePath){};
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(25, 35) pathChangedBlock:block];
  XCTAssertEqualObjects(block, path.pathChangedBlock, @"pathChangedBlock");
  
  XCTAssertEqual(path.tolerance.width, (CGFloat)25);
  XCTAssertEqual(path.tolerance.height, (CGFloat)35);
  
}

- (void)testAddPoint {
  
  __block NSInteger blockCallCount = 0;
  __block PKPath *blockPath = nil;
  PKPathChangedBlock block = ^(PKPath* thePath){
    blockPath = thePath;
    blockCallCount++;
  };
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5) pathChangedBlock:block];
  [path setSnapStartPointToTolerance:NO];
  [path setUseToleranceAsMaximumDistance:NO];
  [path addPoint:PKPointMake(10, 20)];
  
  // make sure startPoint and lastPoints were set
  XCTAssertEqual(path.startPoint.x, (CGFloat)10, @"startPoint.x");
  XCTAssertEqual(path.startPoint.y, (CGFloat)20, @"startPoint.y");
  XCTAssertEqual(path.lastPoint.x, (CGFloat)10, @"lastPoint.x");
  XCTAssertEqual(path.lastPoint.y, (CGFloat)20, @"lastPoint.y");
  
  XCTAssertEqual([path.points count], (NSUInteger)1);
  
  // make sure block was called
  XCTAssertNotNil(blockPath, @"block should be called");
  XCTAssertEqualObjects(blockPath, path);
  XCTAssertEqual((NSInteger)1, blockCallCount);
  
  // (test) reset the blockPath
  blockPath = nil;
  
  // add point - less then tolerance away
  [path addPoint:PKPointMake(11, 22)];
  
  // shouldn't change the start point
  XCTAssertEqual(path.startPoint.x, (CGFloat)10, @"startPoint.x");
  XCTAssertEqual(path.startPoint.y, (CGFloat)20, @"startPoint.y");
  
  // and shouldn't update lastPoint
  XCTAssertEqual(path.lastPoint.x, (CGFloat)10, @"lastPoint.x");
  XCTAssertEqual(path.lastPoint.y, (CGFloat)20, @"lastPoint.y");
  
  XCTAssertEqual([path.points count], (NSUInteger)1);

  // and shouldn't call the block
  XCTAssertNil(blockPath);
  XCTAssertEqual((NSInteger)1, blockCallCount);

  // add point - more then tolerance away
  [path addPoint:PKPointMake(16, 22)];
  
  // shouldn't change the start point
  XCTAssertEqual(path.startPoint.x, (CGFloat)10, @"startPoint.x");
  XCTAssertEqual(path.startPoint.y, (CGFloat)20, @"startPoint.y");
  
  // but should update lastPoint
  XCTAssertEqual(path.lastPoint.x, (CGFloat)16, @"lastPoint.x");
  XCTAssertEqual(path.lastPoint.y, (CGFloat)22, @"lastPoint.y");
  
  // and should call the block
  XCTAssertEqualObjects(blockPath, path);
  XCTAssertEqual((NSInteger)2, blockCallCount);
  XCTAssertEqual([path.points count], (NSUInteger)2);

}

- (void) testSetSnapStartPointToTolerance {
  
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5) pathChangedBlock:nil];
  [path setSnapStartPointToTolerance:YES];
  [path addPoint:PKPointMake(12, 18)];
  
  XCTAssertEqual(path.startPoint.x, (CGFloat)10, @"startPoint.x");
  XCTAssertEqual(path.startPoint.y, (CGFloat)20, @"startPoint.y");
  
}

- (void) testAddPointWithDistantPoints {
  
  //
  // adding a point that is more than the tolerance away
  // should cause multiple points to be added
  // if useToleranceAsMaximumDistance == YES
  //
  
  __block NSInteger blockCallCount = 0;
  __block PKPath *blockPath = nil;
  PKPathChangedBlock block = ^(PKPath* thePath){
    blockPath = thePath;
    blockCallCount++;
  };
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5) pathChangedBlock:block];
  path.useToleranceAsMaximumDistance = YES;
  
  // start point
  [path addPoint:PKPointMake(10, 10)];
  
  XCTAssertEqual([path.points count], (NSUInteger)1);
  XCTAssertEqual((NSInteger)1, blockCallCount);
  
  [path addPoint:PKPointMake(30, 30)];
  
  XCTAssertEqual([path.points count], (NSUInteger)5);
  XCTAssertEqual((NSInteger)2, blockCallCount);
  
}

- (void) testAddPointWithDistantPointsUnevenNumbers {
  
  //
  // adding a point that is more than the tolerance away
  // should cause multiple points to be added
  // if useToleranceAsMaximumDistance == YES
  //
  
  __block NSInteger blockCallCount = 0;
  __block PKPath *blockPath = nil;
  PKPathChangedBlock block = ^(PKPath* thePath){
    blockPath = thePath;
    blockCallCount++;
  };
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5) pathChangedBlock:block];
  path.useToleranceAsMaximumDistance = YES;
  
  // start point
  [path addPoint:PKPointMake(10, 10)];
  
  XCTAssertEqual([path.points count], (NSUInteger)1);
  XCTAssertEqual((NSInteger)1, blockCallCount);
  
  [path addPoint:PKPointMake(33, 32)];
  
  XCTAssertEqual([path.points count], (NSUInteger)5);
  XCTAssertEqual((NSInteger)2, blockCallCount);
  
}

- (void) testAddPointWithDistantPointsNegativePos {
  
  //
  // adding a point that is more than the tolerance away
  // should cause multiple points to be added
  // if useToleranceAsMaximumDistance == YES
  //
  
  __block NSInteger blockCallCount = 0;
  __block PKPath *blockPath = nil;
  PKPathChangedBlock block = ^(PKPath* thePath){
    blockPath = thePath;
    blockCallCount++;
  };
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5) pathChangedBlock:block];
  path.useToleranceAsMaximumDistance = YES;
  
  // start point
  [path addPoint:PKPointMake(30, 30)];
  
  XCTAssertEqual([path.points count], (NSUInteger)1);
  XCTAssertEqual((NSInteger)1, blockCallCount);
  
  [path addPoint:PKPointMake(10, 10)];
  
  XCTAssertEqual([path.points count], (NSUInteger)5);
  XCTAssertEqual((NSInteger)2, blockCallCount);
  
}

- (void) testPoints {
  
  PKPath *path = [[PKPath alloc] initWithTolerance:CGSizeMake(5, 5) pathChangedBlock:nil];
  [path setSnapStartPointToTolerance:NO];
  [path setUseToleranceAsMaximumDistance:NO];

  [path addPoint:PKPointMake(5, 5)];
  [path addPoint:PKPointMake(10, 10)];
  [path addPoint:PKPointMake(20, 20)];
  [path addPoint:PKPointMake(30, 30)];
  [path addPoint:PKPointMake(40, 40)];
  [path addPoint:PKPointMake(50, 50)];
  
  NSArray *points = path.points;
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:0]).x, (CGFloat)5);
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:0]).y, (CGFloat)5);
  
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:1]).x, (CGFloat)10);
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:1]).y, (CGFloat)10);
  
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:2]).x, (CGFloat)20);
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:2]).y, (CGFloat)20);
  
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:3]).x, (CGFloat)30);
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:3]).y, (CGFloat)30);
  
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:4]).x, (CGFloat)40);
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:4]).y, (CGFloat)40);
  
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:5]).x, (CGFloat)50);
  XCTAssertEqual(((PKPoint*)[points objectAtIndex:5]).y, (CGFloat)50);
  
  // start point
  XCTAssertEqual([path startPoint].x, (CGFloat)5);
  XCTAssertEqual([path startPoint].y, (CGFloat)5);
  
}

#pragma mark - Helpers

- (void)testDeltaFromPointToPoint {
  
  CGSize delta;
  
  delta = [PKPath deltaFromPoint:PKPointMake(0, 0) toPoint:PKPointMake(5, 10)];
  XCTAssertEqual(delta.width, (CGFloat)5);
  XCTAssertEqual(delta.height, (CGFloat)10);
  
  delta = [PKPath deltaFromPoint:PKPointMake(1, 1) toPoint:PKPointMake(5, 10)];
  XCTAssertEqual(delta.width, (CGFloat)4);
  XCTAssertEqual(delta.height, (CGFloat)9);
  
  delta = [PKPath deltaFromPoint:PKPointMake(10, 10) toPoint:PKPointMake(0, 0)];
  XCTAssertEqual(delta.width, (CGFloat)-10);
  XCTAssertEqual(delta.height, (CGFloat)-10);
  
}

- (void)testFactorForDeltaPerTolerance {
  
  PKDelta delta;
  PKTolerance tolerance;
  PKDeltaFactor factor;
  
  delta = CGSizeMake(5, 5);
  tolerance = CGSizeMake(10, 10);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)0);
  XCTAssertEqual(factor.height, (CGFloat)0);
  
  delta = CGSizeMake(10, 10);
  tolerance = CGSizeMake(10, 10);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)1);
  XCTAssertEqual(factor.height, (CGFloat)1);
  
  delta = CGSizeMake(12, 15);
  tolerance = CGSizeMake(10, 10);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)1);
  XCTAssertEqual(factor.height, (CGFloat)1);
  
  delta = CGSizeMake(20, 20);
  tolerance = CGSizeMake(10, 10);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)2);
  XCTAssertEqual(factor.height, (CGFloat)2);
  
  delta = CGSizeMake(20, 50);
  tolerance = CGSizeMake(10, 10);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)2);
  XCTAssertEqual(factor.height, (CGFloat)5);
  
  delta = CGSizeMake(50, 20);
  tolerance = CGSizeMake(10, 10);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)5);
  XCTAssertEqual(factor.height, (CGFloat)2);
  
  
  
  delta = CGSizeMake(44.5, 100);
  tolerance = CGSizeMake(100, 100);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)0);
  XCTAssertEqual(factor.height, (CGFloat)1);
  
  delta = CGSizeMake(-1, -1);
  tolerance = CGSizeMake(100, 100);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)0-0);
  XCTAssertEqual(factor.height, (CGFloat)0-0);
  
  delta = CGSizeMake(-100, -50);
  tolerance = CGSizeMake(100, 100);
  factor = [PKPath factorForDelta:delta perTolerance:tolerance];
  XCTAssertEqual(factor.width, (CGFloat)0-1);
  XCTAssertEqual(factor.height, (CGFloat)0-0);
  
}

- (void)testIsZeroFactor {
  
  PKDeltaFactor factor;
  
  factor = CGSizeMake(0, 0);
  XCTAssertTrue([PKPath isZeroFactor:factor]);

  factor = CGSizeMake(1, 0);
  XCTAssertFalse([PKPath isZeroFactor:factor]);

  factor = CGSizeMake(0, 1);
  XCTAssertFalse([PKPath isZeroFactor:factor]);

}

@end
