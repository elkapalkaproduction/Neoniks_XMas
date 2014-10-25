//
//  AboutViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AboutViewController.h"
#import "XMasGoogleAnalitycs.h"
#import "ABX.h"
#import "ABXPromptView.h"
#import "NSString+ABXLocalized.h"
#import "UIViewController+ABXScreenshot.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contributorsText;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;
@property (weak, nonatomic) ABXPromptView *promptView;

@end

@implementation AboutViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.fonImage = @"about";
    [super viewDidLoad];
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(openSite)];
    UIAccessibilityIsGuidedAccessEnabled();
}


#pragma Actions

- (ABXPromptView *)promptView {
    if (_promptView) {
        return _promptView;
    }
    for (UIViewController *child in self.childViewControllers) {
        if ([child isKindOfClass:[ABXPromptView class]]) {
            _promptView = (ABXPromptView *)child;
        }
    }
    
    return _promptView;
    
}


- (void)openSite {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryAboutUs action:GAnalitycsWebsite label:[DeviceUtils deviceName] value:[LanguageUtils currentValue]];
    NSURL *bookUrl = [NSURL urlForSite];
#ifdef FreeVersion
    [[UIApplication sharedApplication] openURL:bookUrl];
#else
    [[FloopSdkManager sharedInstance] showParentalGate:^(BOOL success) {
        if (success) {
            [[UIApplication sharedApplication] openURL:bookUrl];
        }
    }];
#endif
}


#pragma mark - Private Methods

- (void)updateInterface {
    [super updateInterface];
    self.siteButton.image = [UIImage imageWithUnlocalizedName:@"about_button_site"];
    self.contributorsText.image = [UIImage textImageWithName:@"contributors"];
}


- (void)appbotPromptForReview
{
#ifdef FreeVersion
    [ABXAppStore openAppStoreReviewForApp:xmasAppID];
#else
    [[FloopSdkManager sharedInstance] showParentalGate:^(BOOL success) {
        if (success) {
            [ABXAppStore openAppStoreReviewForApp:xmasPaidAppID];
        }
    }];
#endif
    self.promptView.view.hidden = YES;
}

- (void)appbotPromptForFeedback
{
    [ABXFeedbackViewController showFromController:self placeholder:nil];
    self.promptView.view.hidden = YES;
}

- (void)appbotPromptClose
{
    self.promptView.view.hidden = YES;
}


@end
