//
//  AdsManager.h
//  xmas
//
//  Created by Andrei Vidrasco on 10/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsManager : NSObject

+ (instancetype)sharedManager;

- (void)setupAllLibraries;
- (void)showStartVideo;

@end
