//
//  GameHamContainerViewController.h
//  xmas
//
//  Created by Andrei Vidrasco on 10/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameChooseContainerViewController.h"

@protocol HamDelegate <NSObject>

- (void)pressedToyWithID:(NSString *)toyID;

@end

@interface GameHamContainerViewController : UIViewController

+ (instancetype)instantiateWithWidth:(CGFloat)width
                           character:(GameCharacter)character
                            delegate:(id<HamDelegate>)delegate;

- (void)hideViewWithCompletion:(void (^)(void))completion;
@property (nonatomic, copy) void (^completion)(void);

@end
