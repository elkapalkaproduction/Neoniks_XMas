//
//  XMasBaseViewController.h
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GAITrackedViewController.h"


@interface XMasBaseViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) NSString *fonImage;

- (void)updateInterface;
+ (NSString *)storyboardID;

@end
