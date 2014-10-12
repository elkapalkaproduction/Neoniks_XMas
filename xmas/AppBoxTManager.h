//
//  AppBoxTManager.h
//  xmas
//
//  Created by Andrei Vidrasco on 10/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppBoxTManager : NSObject

+ (instancetype)sharedManager;
- (void)setupLibrary;
- (void)show:(UIViewController *)controlller;

@end
