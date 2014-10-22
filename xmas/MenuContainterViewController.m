//
//  MenuContainterViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MenuContainterViewController.h"
#import "AboutViewController.h"
#import "HowToViewController.h"
#import "XMasGoogleAnalitycs.h"
#ifdef FreeVersion
#import "AdsManager.h"
#else
#endif
@interface MenuContainterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutIcon;
@property (weak, nonatomic) IBOutlet UIButton *howToButton;
@property (weak, nonatomic) IBOutlet UIButton *howToIcon;
@property (weak, nonatomic) IBOutlet UIButton *rateUsButton;
@property (weak, nonatomic) IBOutlet UIButton *rateUsIcon;
@property (weak, nonatomic) IBOutlet UIButton *moreIcon;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation MenuContainterViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.aboutButton  addTarget:self onTouchUpInsideWithAction:@selector(goToAbout)];
    [self.aboutIcon    addTarget:self onTouchUpInsideWithAction:@selector(goToAbout)];
    [self.howToButton  addTarget:self onTouchUpInsideWithAction:@selector(goToHowTo)];
    [self.howToIcon    addTarget:self onTouchUpInsideWithAction:@selector(goToHowTo)];
    [self.rateUsButton addTarget:self onTouchUpInsideWithAction:@selector(goToRateUs)];
    [self.rateUsIcon   addTarget:self onTouchUpInsideWithAction:@selector(goToRateUs)];
    [self.moreIcon     addTarget:self onTouchUpInsideWithAction:@selector(moreApps)];
    [self.moreButton   addTarget:self onTouchUpInsideWithAction:@selector(moreApps)];
}


#pragma mark - Actions

- (void)goToAbout {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryMainPage action:GAnalitycsMainPageAboutUs label:nil value:[LanguageUtils currentValue]];
    [StoryboardUtils presentViewControllerWithStoryboardID:[AboutViewController storyboardID] fromViewController:self];
}


- (void)goToHowTo {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryMainPage action:GAnalitycsMainPageHowToPlay label:nil value:[LanguageUtils currentValue]];
    [StoryboardUtils presentViewControllerWithStoryboardID:[HowToViewController storyboardID] fromViewController:self];
}


- (void)goToRateUs {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryMainPage action:GAnalitycsMainPageRateUs label:nil value:[LanguageUtils currentValue]];
#ifdef FreeVersion
    NSURL *bookUrl = [NSURL openStoreToAppWithID:xmasAppID];
    [[UIApplication sharedApplication] openURL:bookUrl];
#else
     NSURL *bookUrl = [NSURL openStoreToAppWithID:xmasPaidAppID];
    [[FloopSdkManager sharedInstance] showParentalGate:^(BOOL success) {
        if (success) {
            [[UIApplication sharedApplication] openURL:bookUrl];
        }
    }];
#endif
}


- (void)moreApps {
#ifdef FreeVersion
    [[AdsManager sharedManager] chartboostShowMoreApps];
#else
    [[FloopSdkManager sharedInstance] showParentalGate:^(BOOL success) {
        if (success) {
                [[FloopSdkManager sharedInstance] showCrossPromotionPageWithName:nil completion:nil];
        }
    }];
#endif
}


#pragma mark - Private Methods

- (void)updateInterface {
    self.aboutButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_about"];
    self.howToButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_how_to"];
    self.rateUsButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_rate_us"];
    self.moreButton.image = [UIImage imageWithUnlocalizedName:@"more_games"];
}

@end
