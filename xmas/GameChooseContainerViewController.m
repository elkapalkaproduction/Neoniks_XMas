//
//  GameChooseContainerViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameChooseContainerViewController.h"

@interface GameChooseContainerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *leftCharacterImage;
@property (weak, nonatomic) IBOutlet UIButton *centerCharacterButton;
@property (weak, nonatomic) IBOutlet UIImageView *centerCharacterName;
@property (weak, nonatomic) IBOutlet UIButton *rightCharacterImage;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (assign, nonatomic) GameCharacter currentMainCharacter;

@end

@implementation GameChooseContainerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftButton addTarget:self onTouchUpInsideWithAction:@selector(loadPreviousCharacter)];
    [self.leftCharacterImage addTarget:self onTouchUpInsideWithAction:@selector(loadPreviousCharacter)];
    [self.rightButton addTarget:self onTouchUpInsideWithAction:@selector(loadNextCharacter)];
    [self.rightCharacterImage addTarget:self onTouchUpInsideWithAction:@selector(loadNextCharacter)];
    [self.centerCharacterButton addTarget:self onTouchUpInsideWithAction:@selector(selectCharacter)];
}


- (void)setCurrentMainCharacter:(GameCharacter)currentMainCharacter {
    _currentMainCharacter = currentMainCharacter;
    [self.delegate centralCharacterChanged:currentMainCharacter];
}


#pragma mark - Actions


- (void)changeMainCharacter:(GameCharacter)character {
    self.currentMainCharacter = character;
    [self updateInterface];
}


- (void)loadNextCharacter {
    self.currentMainCharacter = [self nextCharacter];
    [self updateInterface];
}


- (void)loadPreviousCharacter {
    self.currentMainCharacter = [self previousCharacter];
    [self updateInterface];
}


- (void)selectCharacter {
    if ([self.delegate respondsToSelector:@selector(selectCharacter:)]) {
        [self.delegate selectCharacter:self.currentMainCharacter];
    }
    [self updateInterface];
}


#pragma mark - Private Methods

- (void)updateInterface {
    if (self.currentMainCharacter == GameCharacterUnselected) {
        self.currentMainCharacter = GameCharacterPhoebe;
    }
    self.leftCharacterImage.image = [UIImage imageWithLocalizedName:[self iconImageNameFromCharacter:[self previousCharacter]]];
    self.rightCharacterImage.image = [UIImage imageWithLocalizedName:[self iconImageNameFromCharacter:[self nextCharacter]]];
    self.centerCharacterButton.image = [UIImage imageWithLocalizedName:[self iconImageNameFromCharacter:self.currentMainCharacter]];
    NSInteger index = self.currentMainCharacter;
    self.centerCharacterName.image = [UIImage imageWithUnlocalizedName:[NSString stringWithFormat:@"game_choice_%ld", (long)index]];
}


- (GameCharacter)nextCharacter {
    if (self.currentMainCharacter == GameCharacterFurcoat) {
        return GameCharacterPhoebe;
    }
    
    return self.currentMainCharacter + 1;
}


- (GameCharacter)previousCharacter {
    if (self.currentMainCharacter == GameCharacterPhoebe) {
        return GameCharacterFurcoat;
    }
    
    return self.currentMainCharacter - 1;
}

- (NSString *)iconImageNameFromCharacter:(GameCharacter)character {
    NSInteger index = character;
    
    return [NSString stringWithFormat:@"game_choice_%ld_icon", (long)index];
}

@end
