//
//  MakeACardViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/10/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MakeACardViewController.h"
#import "CaptionsViewController.h"
#import "MakeACardContainerViewController.h"
#import <MessageUI/MessageUI.h>
#import "XMasGoogleAnalitycs.h"

@interface MakeACardViewController () <MFMailComposeViewControllerDelegate, CaptionsDelegate, MakeACardDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) UIImage *cardImage;
@property (strong, nonatomic) IBOutlet UIImageView *textMessage;
@property (strong, nonatomic) IBOutlet UIButton *siteAddress;
@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (assign, nonatomic) NSInteger imageIndex;

@end

@implementation MakeACardViewController

#pragma mark - Life Cycle

+ (instancetype)instantiateWithImage:(UIImage *)image {
    MakeACardViewController *card = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:[self storyboardID]];
    card.cardImage = image;
    
    return card;

}

- (void)viewDidLoad {
    self.fonImage = @"make_card";
    [super viewDidLoad];
    self.cardImageView.image = self.cardImage;
    [self selectCaptionWithIndex:1];
    self.siteAddress.image = [UIImage imageWithUnlocalizedName:@"menu_site"];
    [self.siteAddress addTarget:self onTouchUpInsideWithAction:@selector(goToSite)];
}


#pragma mark - Actions

- (void)goToSite {
    NSURL *siteUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:siteUrl];
}


#pragma mark - MakeACardDelegate

- (void)captions {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategorySnapshot action:GAnalitycsSnapshotCaption label:[LanguageUtils currentValue] value:@(self.imageIndex)];
    CaptionsViewController *captions = [CaptionsViewController instantiateWithDelegate:self];
    captions.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    captions.view.frame = captions.view.bounds;
    [StoryboardUtils addViewController:captions onViewController:self belowSubview:nil];
}


- (void)send {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategorySnapshot action:GAnalitycsSnapshotSend label:[LanguageUtils currentValue] value:@(self.imageIndex)];
    UIImage *image = [UIImage captureScreenInView:self.cardView];
    MFMailComposeViewController *mailCont = [self createMailFromImage:image];
    if (!mailCont) return;
    [self presentViewController:mailCont animated:YES completion:NULL];
}


- (void)save {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategorySnapshot action:GAnalitycsSnapshotSave label:[LanguageUtils currentValue] value:@(self.imageIndex)];
    UIImage *image = [UIImage captureScreenInView:self.cardView];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}


#pragma mark - CaptionsDelegate

- (void)selectCaptionWithIndex:(NSInteger)index {
    self.imageIndex = index;
    self.textMessage.image = [UIImage imageWithUnlocalizedName:[NSString stringWithFormat:@"card_caption_text%ld", (long)index]];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private Methods

- (MFMailComposeViewController *)createMailFromImage:(UIImage *)image {
    NSData *myData = UIImagePNGRepresentation(image);
    
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    if ([LanguageUtils isRussian]) {
        [mailCont setSubject:@"Смешная открытка с Хэллоуином - специально для тебя"];
        [mailCont setMessageBody:@"Смотри, какая смешная открытка у меня получилась! (это из бесплатного приложения 'Неоники и Хэллоуин' для iPad и iPhone).”.\n\nhttp://bit.ly/Halloween_RU" isHTML:NO];
        [mailCont addAttachmentData:myData mimeType:@"image/png" fileName:@"otkrytka_na_halloween.png"];
    } else {
        [mailCont setSubject:@"My awesome Halloween card just for you!"];
        [mailCont setMessageBody:@"Check out this cool greeting card I created with the FREE iPad/iPhone app, Neoniks and Halloween!\n\nhttp://bit.ly/Halloween_US" isHTML:NO];
        [mailCont addAttachmentData:myData mimeType:@"image/png" fileName:@"halloween_card.png"];
    }
    
    return mailCont;
}

@end
