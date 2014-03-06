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
#import "PKCommon.h"
@class PKPoint;

@interface PKPath : NSObject

/**
 * CGSize representing the grid or tolerance that the path must exist
 * within.
 * 
 * Setting a tolerance of 1,1 means every pixel will be counted in the path.
 * Setting a higher tolerance size, such as 5,5 will mean new points are only
 * added if they are more than five pixels away from the last.
 */
@property (assign, readonly) CGSize tolerance;
@property (copy, readwrite) PKPathChangedBlock pathChangedBlock;
@property (strong, readonly) PKPoint *startPoint;
@property (strong, readonly) PKPoint *lastPoint;
@property (strong, readonly) NSArray *points;
@property (assign, readwrite) BOOL useToleranceAsMaximumDistance;
@property (assign, readwrite) BOOL snapStartPointToTolerance;

/**
 * Creates a new PKPath with the specified tolerance.
 */
- (id) initWithTolerance:(PKTolerance)tolerance;

/**
 * Creates a new PKPath with the specified tolerance and PKPathChangedBlock.
 */
- (id) initWithTolerance:(PKTolerance)tolerance pathChangedBlock:(PKPathChangedBlock)pathChangedBlock;

/**
 * Adds a point to the path.  If the point is acceptable (i.e. not too close) it will
 * be added.
 */
- (BOOL) addPoint:(PKPoint *)point;

/**
 * Makes a new CGPath and returns the CGMutablePathRef it created.
 *
 * Even in ARC, it is the responsibility of calling code to call CGPathRelease on the
 * return to ensure the path is released properly.
 */
- (CGMutablePathRef) makeCGPath;

#pragma mark - Helpers

/**
 * Gets the distance between two points.
 */
+ (PKDelta) deltaFromPoint:(PKPoint *)fromPoint toPoint:(PKPoint *)toPoint;

/**
* Gets the factor for the specified delta as a ratio against the tolerance.
*/
+ (PKDeltaFactor) factorForDelta:(PKDelta)delta perTolerance:(PKTolerance)tolerance;

/**
 * Gets whether the specified factor is zero or not (i.e. both values zero).
 */
+ (BOOL) isZeroFactor:(PKDeltaFactor)factor;

@end
