//
//  AppBoxTManager.m
//  xmas
//
//  Created by Andrei Vidrasco on 10/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AppBoxTManager.h"
#import "ABX.h"

@implementation AppBoxTManager

+ (instancetype)sharedManager {
    
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (void)setupLibrary {
    [[ABXApiClient instance] setApiKey:@"bc2c1345090cee2262258834db71a1e9417365a7"];
}

- (void)show:(UIViewController *)controlller {
    [ABXFeedbackViewController showFromController:controlller placeholder:nil email:nil metaData:nil image:nil];

}

@end
