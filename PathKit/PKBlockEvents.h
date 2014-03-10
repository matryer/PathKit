//
//  PKPathChangedBlock.h
//  PathKit
//
//  Created by Mat Ryer on 3/3/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#ifndef PathKit_PKPathChangedBlock_h
#define PathKit_PKPathChangedBlock_h

@class PKPath;

/**
 * PKPathChangedBlock is a block that will called when a PKPath
 * has changed.
 */
typedef void (^PKPathChangedBlock)(PKPath* path);

/**
 * PKPathMaximumLengthReachedBlock is a block that will be called when a
 * PKPath has reached its maximum length.
 */
typedef void (^PKPathMaximumLengthReachedBlock)(PKPath* path);

#endif
