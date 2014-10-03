//
//  MakeACardContainerViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/28/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MakeACardContainerViewController.h"

@interface MakeACardContainerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *captionsButton;
@property (weak, nonatomic) IBOutlet UIButton *captionsIcon;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UIButton *mailIcon;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *saveIcon;

@end

@implementation MakeACardContainerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.captionsButton  addTarget:self onTouchUpInsideWithAction:@selector(captions)];
    [self.captionsIcon    addTarget:self onTouchUpInsideWithAction:@selector(captions)];
    [self.mailButton  addTarget:self onTouchUpInsideWithAction:@selector(sendMail)];
    [self.mailIcon    addTarget:self onTouchUpInsideWithAction:@selector(sendMail)];
    [self.saveButton addTarget:self onTouchUpInsideWithAction:@selector(saveImage)];
    [self.saveIcon   addTarget:self onTouchUpInsideWithAction:@selector(saveImage)];
}


#pragma mark - Actions

- (void)captions {
    [self.delegate captions];
}


- (void)sendMail {
    [self.delegate send];
}


- (void)saveImage {
    [self.delegate save];
}


#pragma mark - Private Methods

- (void)updateInterface {
    self.captionsButton.image = [UIImage imageWithUnlocalizedName:@"card_button_captions"];
    self.mailButton.image = [UIImage imageWithUnlocalizedName:@"card_button_mail"];
    self.saveButton.image = [UIImage imageWithUnlocalizedName:@"card_button_save"];
}

@end
