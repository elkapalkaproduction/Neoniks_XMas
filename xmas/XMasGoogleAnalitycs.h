//
//  XMasGoogleAnalitycs.h
//  xmas
//
//  Created by Andrei Vidrasco on 10/7/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const GAnalitycsCategoryMainPage;
NSString *const GAnalitycsCategoryHowTo;
NSString *const GAnalitycsCategoryAboutUs;
NSString *const GAnalitycsCategoryPlayScreen;
NSString *const GAnalitycsCategorySnapshot;

//Main Page Events
NSString *const GAnalitycsMainPageLanguageChanged;
NSString *const GAnalitycsMainPageHowToPlay;
NSString *const GAnalitycsMainPageRateUs;
NSString *const GAnalitycsMainPageAboutUs;
NSString *const GAnalitycsMainPagePlayClicked;
NSString *const GAnalitycsMainPageArrowPlay;

//Commom Events
NSString *const GAnalitycsBack;
NSString *const GAnalitycsWebsite;

//About Us Events
NSString *const GAnalitycsAboutUsReadBook;

//Play Screen Events
NSString *const GAnalitycsPlayCharacterChangedByClick;
NSString *const GAnalitycsPlayCharacterChangedByArrow;
NSString *const GAnalitycsPlayXmasToy;
NSString *const GAnalitycsPlayReturnMenu;
NSString *const GAnalitycsPlayNewGame;
NSString *const GAnalitycsPlayTakeSnapshot;
NSString *const GAnalitycsPlayOurWebsite;
NSString *const GAnalitycsPlayPopupAppeared;
NSString *const GAnalitycsPlayReadBook;
NSString *const GAnalitycsPlayArrowPopupClick;
NSString *const GAnalitycsPlayPopupClosed;

//Take Snapshot Events
NSString *const GAnalitycsSnapshotCaption;
NSString *const GAnalitycsSnapshotSend;
NSString *const GAnalitycsSnapshotSave;


@interface XMasGoogleAnalitycs : NSObject

+ (instancetype)sharedManager;
- (void)logEventWithCategory:(NSString *)category
                      action:(NSString *)action
                       label:(NSString *)label
                       value:(NSNumber *)value;

- (void)startLogTime:(NSString *)screenName;
- (void)endLogTime;


@end
