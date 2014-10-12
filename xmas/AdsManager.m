//
//  AdsManager.m
//  xmas
//
//  Created by Andrei Vidrasco on 10/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AdsManager.h"
#import "TSTapstream.h"
#import <Chartboost/Chartboost.h>
#import "SoundPlayer.h"

NSString *const TAP_STREAM_KEY = @"c_9ek3--RY-PeLND6eR4_Q";
NSString *const CHARTBOOST_APP_ID = @"54377f15c26ee43451b3fcf0";
NSString *const CHARTBOOST_APP_SIGNATURE = @"5f8be4653b7088a82759825449103baff5ca8fe3";

@interface AdsManager () <ChartboostDelegate>

@property (assign, nonatomic) BOOL isPlayingMusic;

@end

@implementation AdsManager

+ (instancetype)sharedManager {
    
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}



- (void)setupAllLibraries {
    // Tapstream SDK
    TSConfig *config = [TSConfig configWithDefaults];
    [TSTapstream createWithAccountName:@"neoniks" developerSecret:TAP_STREAM_KEY config:config];
    [Chartboost startWithAppId:CHARTBOOST_APP_ID
                  appSignature:CHARTBOOST_APP_SIGNATURE
                      delegate:self];

}


- (void)showStartVideo {
    [self playVideos];
}

- (void)playVideos {
    [Chartboost showInterstitial:CBLocationHomeScreen];
}

- (void)didDismissInterstitial:(CBLocation)location {
    if (self.isPlayingMusic) {
        [[SoundPlayer sharedPlayer] playBakgroundMusic];
    }
}

- (void)didDisplayInterstitial:(CBLocation)location {
    self.isPlayingMusic = [[SoundPlayer sharedPlayer] isPlayingBackgroundMusic];
    [[SoundPlayer sharedPlayer] pauseBackgroundMusic];
}



@end
