//
//  PKPointTests.m
//  PathKit
//
//  Created by Mat Ryer on 3/5/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PKPoint.h"

@interface PKPointTests : XCTestCase

@end

@implementation PKPointTests

- (void) testPKPointMake {
  
  PKPoint *p = PKPointMake(10, 11);
  XCTAssertEqual((CGFloat)10, p.x);
  XCTAssertEqual((CGFloat)11, p.y);
  
}

- (void) testCopy {
  
  PKPoint *p = PKPointMake(10, 11);
  XCTAssertEqual((CGFloat)10, p.x);
  XCTAssertEqual((CGFloat)11, p.y);
  
  PKPoint *p2 = [p copy];
  XCTAssertEqual((CGFloat)10, p2.x);
  XCTAssertEqual((CGFloat)11, p2.y);
  
  XCTAssertNotEqualObjects(p, p2);
  
}

@end
