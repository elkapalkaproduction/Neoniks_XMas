//
//  ViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/26/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *playIcon;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;

@end

@implementation MenuViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    NSLog(@"%@", NSStringFromCGSize(CGSizeMake(672, 638 )));
    self.fonImage = @"menu";
    [super viewDidLoad];
    [self.languageButton addTarget:self onTouchUpInsideWithAction:@selector(changeLanguage)];
    [self.playButton addTarget:self onTouchUpInsideWithAction:@selector(play)];
    [self.playIcon addTarget:self onTouchUpInsideWithAction:@selector(play)];
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(openSite)];
}

#pragma mark - Actions

- (void)changeLanguage {
    [LanguageUtils setOpositeLanguage];
    [self updateInterface];
}


- (void)play {
    [StoryboardUtils presentViewControllerWithStoryboardID:[GameViewController storyboardID] fromViewController:self];
}


- (void)openSite {
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


#pragma mark - Private Methods

- (void)updateInterface {
    [super updateInterface];
    self.siteButton.image = [UIImage imageWithUnlocalizedName:@"site"];
    self.languageButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_flag"];
    self.playButton.image = [UIImage imageWithUnlocalizedName:@"menu_button_play"];
}

@end
