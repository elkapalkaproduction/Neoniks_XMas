//
//  XMasGoogleAnalitycs.m
//  xmas
//
//  Created by Andrei Vidrasco on 10/7/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "XMasGoogleAnalitycs.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

NSString *const GOOGLE_ANALITYCS_TRACKING_ID = @"UA-33114261-8";

//Categories
NSString *const GAnalitycsCategoryMainPage = @"Main Page";
NSString *const GAnalitycsCategoryHowTo = @"How to page";
NSString *const GAnalitycsCategoryAboutUs = @"About Us";
NSString *const GAnalitycsCategoryPlayScreen = @"Play Screen";
NSString *const GAnalitycsCategorySnapshot = @"Snapshot Screen";

//Main Page Events
NSString *const GAnalitycsMainPageLanguageChanged = @"Change Language is clicked";
NSString *const GAnalitycsMainPageHowToPlay = @"How to play clicked";
NSString *const GAnalitycsMainPageRateUs = @"Rate Us clicked";
NSString *const GAnalitycsMainPageAboutUs = @"About Us clicked";
NSString *const GAnalitycsMainPagePlayClicked = @"Play is clicked";
NSString *const GAnalitycsMainPageArrowPlay = @"Arrow to play is clicked";

//Commom Events
NSString *const GAnalitycsBack = @"Back button is clicked";
NSString *const GAnalitycsWebsite = @"Our website is clicked";

//About Us Events
NSString *const GAnalitycsAboutUsReadBook = @"Read the Book Clicked";

//Play Screen Events
NSString *const GAnalitycsPlayCharacterChangedByClick = @"Character is selected by click";
NSString *const GAnalitycsPlayCharacterChangedByArrow = @"Character is selected by arrow";
NSString *const GAnalitycsPlayXmasToy = @"Xmas Toy is clicked and placed on a tree";
NSString *const GAnalitycsPlayReturnMenu = @"Return to Menu is clicked";
NSString *const GAnalitycsPlayNewGame = @"New Game is clicked";
NSString *const GAnalitycsPlayTakeSnapshot = @"Take a Snapshot is clicked";
NSString *const GAnalitycsPlayOurWebsite = @"Our website is clicked";
NSString *const GAnalitycsPlayPopupAppeared = @"Pop-up appeared";
NSString *const GAnalitycsPlayReadBook  = @"Read the book is clicked on Pop-Up";
NSString *const GAnalitycsPlayArrowPopupClick = @"Arrow is clicked on Pop-Up";
NSString *const GAnalitycsPlayPopupClosed = @"Pop-up is closed";

//Take Snapshot Events
NSString *const GAnalitycsSnapshotCaption = @"Caption is selected";
NSString *const GAnalitycsSnapshotSend = @"Send button is clicked";
NSString *const GAnalitycsSnapshotSave = @"Save is clicked";

@interface XMasGoogleAnalitycs ()
@property (strong, nonatomic) GAIDictionaryBuilder *builder;
@end

@implementation XMasGoogleAnalitycs

+ (instancetype)sharedManager {
    
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAnalitycs];
    }
    
    return self;
}


- (void)setupAnalitycs {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALITYCS_TRACKING_ID];
}


- (void)logEventWithCategory:(NSString *)category
                      action:(NSString *)action
                       label:(NSString *)label
                       value:(NSNumber *)value {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:category
                                                           action:action
                                                            label:label
                                                            value:value] set:@"start" forKey:kGAISessionControl] build]];
}



- (void)startLogTime:(NSString *)screenName {
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    self.builder = [GAIDictionaryBuilder createScreenView];
    [self.builder set:@"start" forKey:kGAISessionControl];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[self.builder build]];
}

- (void)endLogTime {
    [self.builder set:@"end" forKey:kGAISessionControl];
}

@end
