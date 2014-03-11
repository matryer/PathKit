//
//  PKPathNodeDelegate.h
//  PathKit
//
//  Created by Mat Ryer on 3/6/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PKPathNode;
@class PKPath;

@protocol PKPathNodeDelegate <NSObject>

@optional

/**
 * Called when the PKPathNode creates a new path.
 * 
 * This is the perfect place to do any additional configuration on the 
 * PKPath before points are added to it.
 */
- (void)pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path;

/**
 * Called whenever the path changes.
 */
- (void)pathNode:(PKPathNode *)node didChangePath:(PKPath *)path;

/**
 * Will be called when the PKNodePath needs a CGPathRef for the
 * specified path.  Otherwise, the default path joining all points will be used.
 *
 * PKNodePath will release the returned CGPathRef when it is finished with it.
 */
- (CGPathRef)pathNode:(PKPathNode *)node makeCGPathForPKPath:(PKPath *)path;

/**
 * Will be called if a maximumLength is set on the PKPath and adding a point
 * would have caused the length to exceed it.  The PKPath will adjust the last 
 * point if possible to make it fit wihtin the maximum, or might not add the
 * point at all.
 *
 * At this point, path.length should == path.maximumLength.
 *
 * pathNode:reachedMaximumLengthForPath: will be called every time you add a point
 * that would have taken the length past the maximum.  It is worth checking the
 * PKPathNode.maximumLengthReached property before calling [PKPathNode addPoint:].
 */
- (void)pathNode:(PKPathNode *)node reachedMaximumLengthForPath:(PKPath *)path;

@end
