//
//  MakeACardContainerViewController.h
//  xmas
//
//  Created by Andrei Vidrasco on 9/28/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//


@protocol MakeACardDelegate <NSObject>

- (void)captions;
- (void)send;
- (void)save;

@end

@interface MakeACardContainerViewController : UIViewController
@property (weak, nonatomic) id<MakeACardDelegate> delegate;
@end
