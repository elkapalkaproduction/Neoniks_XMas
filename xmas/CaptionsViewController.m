//
//  CaptionsViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "CaptionsViewController.h"
#import "Utils.h"

@interface CaptionsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *text1;
@property (strong, nonatomic) IBOutlet UIButton *text2;
@property (strong, nonatomic) IBOutlet UIButton *text3;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) id<CaptionsDelegate> delegate;

@end

@implementation CaptionsViewController

#pragma mark - Life Cycle

+ (instancetype)instantiateWithDelegate:(id<CaptionsDelegate>)delegate {
    CaptionsViewController *viewController = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:@"CaptionsViewController"];
    viewController.delegate = delegate;
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    [self.text1 addTarget:self onTouchUpInsideWithAction:@selector(captionSelected:)];
    [self.text2 addTarget:self onTouchUpInsideWithAction:@selector(captionSelected:)];
    [self.text3 addTarget:self onTouchUpInsideWithAction:@selector(captionSelected:)];
    [self.backButton addTarget:self onTouchUpInsideWithAction:@selector(back)];
    self.text1.tag = 1;
    self.text2.tag = 2;
    self.text3.tag = 3;
}


#pragma mark - Actions

- (void)captionSelected:(UIButton *)sender {
    [self.delegate selectCaptionWithIndex:sender.tag];
    [self back];
}


- (void)back {
    [self.view removeFromSuperview];

}


#pragma mark - Private Methods

- (void)updateInterface {
    self.text1.image = [UIImage imageWithUnlocalizedName:@"card_caption_text1"];
    self.text2.image = [UIImage imageWithUnlocalizedName:@"card_caption_text2"];
    self.text3.image = [UIImage imageWithUnlocalizedName:@"card_caption_text3"];
}

@end
