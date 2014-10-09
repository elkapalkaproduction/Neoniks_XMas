//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "SoundPlayer.h"
@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation LogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImages];
    [self shortAnimation];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SoundPlayer sharedPlayer] playBakgroundMusic];
}


- (void)updateImages {

    [_logoImageView setImage:[UIImage imageWithUnlocalizedName:@"logo"]];
}


- (void)shortAnimation {
    float timeInterval = 1.f;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
         _logoImageView.alpha = 1.f;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
             _logoImageView.alpha = 0.f;
         } completion:^(BOOL finished) {
             [self.navigationController popToRootViewControllerAnimated:NO];
         }];
     }];
}

@end
