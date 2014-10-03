//
//  GameLeftContainerViewController.h
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameLeftMenuDelegate <NSObject>

- (void)takeSnapshot;
- (void)startNewGame;

@end


@interface GameLeftContainerViewController : UIViewController

@property (weak, nonatomic) id<GameLeftMenuDelegate> delegate;

@end
