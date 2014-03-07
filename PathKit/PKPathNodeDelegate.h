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
 * If defined, will be called when the PKNodePath needs a CGPathRef for the
 * specified path.  Otherwise, the default path joining all points will be used.
 *
 * PKNodePath will release the returned CGPathRef when it is finished with it.
 */
- (CGPathRef)pathNode:(PKPathNode *)node makeCGPathForPKPath:(PKPath *)path;

@end
