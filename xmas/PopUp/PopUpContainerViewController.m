//
//  PopUpContainerViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/28/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PopUpContainerViewController.h"
#import "XMasGoogleAnalitycs.h"
#import "PopUpViewController.h"

@interface PopUpContainerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *readBookIcon;
@property (weak, nonatomic) IBOutlet UIButton *readBookButton;

@end

@implementation PopUpContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.readBookButton addTarget:self onTouchUpInsideWithAction:@selector(readTheBook)];
    [self.readBookIcon addTarget:self onTouchUpInsideWithAction:@selector(readTheBook)];
}


- (void)updateInterface {
    self.readBookButton.image = [UIImage imageWithUnlocalizedName:@"pop_up_button_read_book"];
}


- (void)readTheBook {
    NSInteger pageToShow =  ((PopUpViewController *)self.parentViewController).curentPage;
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsPlayReadBook label:[DeviceUtils deviceName] value:@(pageToShow + 1)];
    NSURL *bookAppUrl = [NSURL URLWithString:NeoniksBookLink];
    if ([[UIApplication sharedApplication] canOpenURL:bookAppUrl]) {
        [[UIApplication sharedApplication] openURL:bookAppUrl];
    } else {
        NSURL *bookUrl = [NSURL openStoreToAppWithID:bookAppID];
        [[UIApplication sharedApplication] openURL:bookUrl];
    }
}


@end
