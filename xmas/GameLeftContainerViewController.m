//
//  GameLeftContainerViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameLeftContainerViewController.h"
#import "XMasGoogleAnalitycs.h"
#import "NNKAlertView.h"

@interface GameLeftContainerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backIcon;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameIcon;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;
@property (weak, nonatomic) IBOutlet UIButton *takeIcon;

@end

@implementation GameLeftContainerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backButton  addTarget:self onTouchUpInsideWithAction:@selector(goBack)];
    [self.backIcon    addTarget:self onTouchUpInsideWithAction:@selector(goBack)];
    [self.startNewGameButton  addTarget:self onTouchUpInsideWithAction:@selector(startNewGame)];
    [self.startNewGameIcon    addTarget:self onTouchUpInsideWithAction:@selector(startNewGame)];
    [self.takeButton addTarget:self onTouchUpInsideWithAction:@selector(takeSnapshot)];
    [self.takeIcon   addTarget:self onTouchUpInsideWithAction:@selector(takeSnapshot)];
}

#pragma mark - Actions

- (void)goBack {
    NNKAlertView *alert = [NNKAlertView initWithMessageType:AlertViewMessageQuit delegate:(UIViewController<NNKAlertViewDelegate> *)self.parentViewController];
    [StoryboardUtils addViewController:alert onViewController:self.parentViewController belowSubview:nil];

} 


- (void)startNewGame {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsPlayNewGame label:nil value:[LanguageUtils currentValue]];
    [self.delegate startNewGame];
}


- (void)takeSnapshot {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsPlayTakeSnapshot label:nil value:[LanguageUtils currentValue]];
    [self.delegate takeSnapshot];
}

#pragma mark - Private Methods

- (void)updateInterface {
    self.backButton.image = [UIImage imageWithUnlocalizedName:@"play_button_back"];
    self.startNewGameButton.image = [UIImage imageWithUnlocalizedName:@"play_button_new_game"];
    self.takeButton.image = [UIImage imageWithUnlocalizedName:@"play_button_take"];
}

@end
