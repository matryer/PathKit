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
 * PKPath.
 */
- (void) pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path;

@end
