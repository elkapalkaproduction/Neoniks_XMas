//
//  AboutViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AboutViewController.h"
#import "XMasGoogleAnalitycs.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contributorsText;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;

@end

@implementation AboutViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.fonImage = @"about";
    [super viewDidLoad];
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(openSite)];
}


#pragma Actions

- (void)openSite {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryAboutUs action:GAnalitycsWebsite label:[DeviceUtils deviceName] value:[LanguageUtils currentValue]];
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


#pragma mark - Private Methods

- (void)updateInterface {
    [super updateInterface];
    self.siteButton.image = [UIImage imageWithUnlocalizedName:@"about_button_site"];
    self.contributorsText.image = [UIImage textImageWithName:@"contributors"];
}

@end
