//
//  PKPath.h
//  PathKit
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "PKPathChangedBlock.h"
@class PKPoint;

typedef CGSize PKDelta;
typedef CGSize PKDeltaFactor;
typedef CGSize PKTolerance;

@interface PKPath : NSObject

@property (assign, readonly) CGSize tolerance;
@property (copy, readonly) PKPathChangedBlock pathChangedBlock;
@property (strong, readonly) PKPoint *startPoint;
@property (strong, readonly) PKPoint *lastPoint;
@property (strong, readonly) NSArray *points;
@property (assign, readwrite) BOOL useToleranceAsMaximumDistance;

- (id) initWithTolerance:(PKTolerance)tolerance;

- (id) initWithTolerance:(PKTolerance)tolerance pathChangedBlock:(PKPathChangedBlock)pathChangedBlock;

- (BOOL) addPoint:(PKPoint *)point;

- (CGMutablePathRef) makeCGPath;

#pragma mark - Helpers

+ (PKDelta) deltaFromPoint:(PKPoint *)fromPoint toPoint:(PKPoint *)toPoint;

+ (PKDeltaFactor) factorForDelta:(PKDelta)delta perTolerance:(PKTolerance)tolerance;

+ (BOOL) isZeroFactor:(PKDeltaFactor)factor;

@end
