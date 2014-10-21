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
#import <StartApp/StartApp.h>

NSString *const TAP_STREAM_KEY = @"c_9ek3--RY-PeLND6eR4_Q";
NSString *const CHARTBOOST_APP_ID = @"54377f15c26ee43451b3fcf0";
NSString *const CHARTBOOST_APP_SIGNATURE = @"5f8be4653b7088a82759825449103baff5ca8fe3";

NSString *const START_APP_DEVELOPER_KEY = @"105068540";
NSString *const START_APP_APP_KEY = @"210300540";


@interface AdsManager () <ChartboostDelegate, STADelegateProtocol>

@property (assign, nonatomic) BOOL isPlayingMusic;
@property (strong, nonatomic) STAStartAppAd *appAd;
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

- (STAStartAppAd *)appAd {
    if (!_appAd) {
        _appAd = [[STAStartAppAd alloc] init];
    }
    
    return _appAd;
}


- (void)showSplashAd {
    [self.appAd showAd];
}

- (void)setupAllLibraries {
    // Tapstream SDK
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = START_APP_APP_KEY;
    sdk.devID = START_APP_DEVELOPER_KEY;
    [self.appAd loadAdWithDelegate:self];
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
    [self showSplashAd];
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

- (void)didShowAd:(STAAbstractAd *)ad {
    self.isPlayingMusic = [[SoundPlayer sharedPlayer] isPlayingBackgroundMusic];
    [[SoundPlayer sharedPlayer] pauseBackgroundMusic];
}


- (void)didCloseAd:(STAAbstractAd *)ad {
    if (self.isPlayingMusic) {
        [[SoundPlayer sharedPlayer] playBakgroundMusic];
    }
    self.appAd = nil;
    [self.appAd loadAdWithDelegate:self];
}

@end
