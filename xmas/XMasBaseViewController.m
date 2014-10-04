//
//  XMasBaseViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "XMasBaseViewController.h"

@interface XMasBaseViewController ()
@property (weak, nonatomic) id delegate;
@end

@implementation XMasBaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    [self.backButton addTarget:self onTouchUpInsideWithAction:@selector(back)];
}


#pragma mark - Actions

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Methods

- (void)updateInterface {
    if (self.backgroundImage) self.backgroundImage.image = [UIImage backgroundImageWithName:self.fonImage];
    if (self.bannerImage) self.bannerImage.image = [UIImage bannerImageWithName:self.fonImage];
    if (self.textImage) self.textImage.image = [UIImage textImageWithName:self.fonImage];
    for (XMasBaseViewController *child in self.childViewControllers) {
        if ([child respondsToSelector:@selector(setDelegate:)]) {
            child.delegate = self;
        }
        if ([child respondsToSelector:@selector(updateInterface)]) {
            [child updateInterface];
        }
    }
}


+ (NSString *)storyboardID {
    return NSStringFromClass([self class]);
}


@end
