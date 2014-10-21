//
//  AboutContainerViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AboutContainerViewController.h"
#import <MessageUI/MessageUI.h>
#import "XMasGoogleAnalitycs.h"

@interface AboutContainerViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *readBookButton;
@property (weak, nonatomic) IBOutlet UIButton *readBookIcon;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackIcon;

@end

@implementation AboutContainerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.readBookButton  addTarget:self onTouchUpInsideWithAction:@selector(goToReadBook)];
    [self.readBookIcon    addTarget:self onTouchUpInsideWithAction:@selector(goToReadBook)];
    [self.feedbackButton  addTarget:self onTouchUpInsideWithAction:@selector(goToFeedback)];
    [self.feedbackIcon    addTarget:self onTouchUpInsideWithAction:@selector(goToFeedback)];
}


#pragma mark - Actions

- (void)goToReadBookParentGate {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryAboutUs action:GAnalitycsWebsite label:[DeviceUtils deviceName] value:[LanguageUtils currentValue]];
    NSURL *bookAppUrl = [NSURL URLWithString:NeoniksBookLink];
    if ([[UIApplication sharedApplication] canOpenURL:bookAppUrl]) {
        [[UIApplication sharedApplication] openURL:bookAppUrl];
    } else {
        NSURL *bookUrl = [NSURL openStoreToAppWithID:bookAppID];
        [[UIApplication sharedApplication] openURL:bookUrl];
    }
}

- (void)goToReadBook {
#ifdef FreeVersion
    [self goToReadBookParentGate];
#else
    [[FloopSdkManager sharedInstance] showParentalGate:^(BOOL success) {
        if (success) {
            [self goToReadBookParentGate];
        }
    }];
#endif
}


- (void)goToFeedback {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [self createMailCompose];
        [self presentViewController:mailCont animated:YES completion:NULL];
    } else {
        #ifdef FreeVersion
        NSURL *bookUrl = [NSURL openStoreToAppWithID:xmasAppID];
        #else
        NSURL *bookUrl = [NSURL openStoreToAppWithID:xmasPaidAppID];
        #endif
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
}

#pragma mark - Private Methods

- (void)updateInterface {
    self.readBookButton.image = [UIImage imageWithUnlocalizedName:@"about_button_read_book"];
    self.feedbackButton.image = [UIImage imageWithUnlocalizedName:@"about_button_feedback"];
}


- (MFMailComposeViewController *)createMailCompose {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    if ([LanguageUtils isRussian]) {
        [mailCont setSubject:@"Отзыв на Неоники и Новогодняя Ёлка"];
    } else {
        [mailCont setSubject:@"Feedback on Neoniks XMas Tree"];
    }
    [mailCont setToRecipients:[NSArray arrayWithObject:@"info@neoniks.com"]];
    [mailCont setMessageBody:@"" isHTML:NO];
    
    return mailCont;
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
