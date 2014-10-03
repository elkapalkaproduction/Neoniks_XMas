//
//  GameChooseContainerViewController.h
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GameCharacter) {
    GameCharacterUnselected,
    GameCharacterPhoebe,
    GameCharacterJay,
    GameCharacterMystie,
    GameCharacterHarold,
    GameCharacterJustacreep,
    GameCharacterWanda,
    GameCharacterRusty,
    GameCharacterFurcoat,
};

@protocol GameChooseDelegate <NSObject>

- (void)selectCharacter:(GameCharacter)character;
- (BOOL)isCharacterSelected:(GameCharacter)character;

@end

@interface GameChooseContainerViewController : UIViewController

@property (weak, nonatomic) id<GameChooseDelegate> delegate;

@end
