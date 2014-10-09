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

@interface MenuContainterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutIcon;
@property (weak, nonatomic) IBOutlet UIButton *howToButton;
@property (weak, nonatomic) IBOutlet UIButton *howToIcon;
@property (weak, nonatomic) IBOutlet UIButton *rateUsButton;
@property (weak, nonatomic) IBOutlet UIButton *rateUsIcon;

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
    NSURL *bookUrl = [NSURL openStoreToAppWithID:bookAppID];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


#pragma mark - Private Methods

- (void)updateInterface {
    self.aboutButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_about"];
    self.howToButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_how_to"];
    self.rateUsButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_rate_us"];
}

@end
