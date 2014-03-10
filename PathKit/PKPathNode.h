//
//  PKPathNode.h
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PKCommon.h"
@class PKPath;
@protocol PKPathNodeDelegate;

@interface PKPathNode : SKShapeNode

- (id) initWithTolerance:(PKTolerance)tolerance;

/**
 * Gets the tolerance that this PKPathNode was initialized with.
 */
@property (assign, readonly) PKTolerance tolerance;

/**
 * Gets or sets the PKPathNodeDelegate that this object will report to.
 */
@property (assign, readwrite) id<PKPathNodeDelegate> delegate;

/**
 * Gets or sets the maximum length allowed for paths.
 */
@property (strong, readwrite) NSNumber *maximumLength;

/**
 * Gets whether the maximum length has been reached or not.
 */
@property (assign, readonly) BOOL maximumLengthReached;

/**
 * Gets the start point of the current path.
 */
@property (assign, readonly) CGPoint startPoint;

/**
 * Adds a CGPoint to the path.
 */
- (void) addPoint:(CGPoint)point;

/**
 * Points gets the points that were added to this PKPathNode.
 */
- (NSArray *)points;

/**
 * Gets the underlying PKPath that this PKPathNode uses.
 */
- (PKPath *)pkPath;

/**
 * Makes a new CGPath and returns the CGPathRef for use in the SKShapeNode.path
 * property.
 *
 * Callers of this must remember to release the CGPathRef in order to avoid
 * memory leaks.
 */
- (CGPathRef)makeCGPath;

/**
 * Sets the underlying PKPath that this PKPathNode uses.
 */
- (void)setPkPath:(PKPath*)pkPath;

/**
 * Clears the path and removes all points.
 */
- (void)clearPath;

@end
