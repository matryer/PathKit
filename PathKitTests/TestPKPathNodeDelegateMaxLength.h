//
//  TestPKPathNodeDelegateMaxLength.h
//  PathKit
//
//  Created by Mat Ryer on 3/10/14.
//  Copyright (c) 2014 Mat Ryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKPathNodeDelegate.h"

@interface TestPKPathNodeDelegateMaxLength : NSObject <PKPathNodeDelegate>

@property (copy, readonly) NSString *lastMethod;
@property (strong, readonly) NSArray *lastArgs;

@end