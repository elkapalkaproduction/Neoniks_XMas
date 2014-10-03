//
//  GameViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameViewController.h"
#import "GameChooseContainerViewController.h"
#import "GameLeftContainerViewController.h"
#import "MakeACardViewController.h"
#import "PopUpViewController.h"
#import "PopUpAnimations.h"
#import "GameHamContainerViewController.h"
#import "StatedObject.h"
#import "NNKObjectParameters.h"

@interface GameViewController () <GameChooseDelegate, GameLeftMenuDelegate, PopUpDelegate, HamDelegate, StatedObjectDelegate>

@property (assign, nonatomic) GameCharacter selectedCharacter;
@property (strong, nonatomic) PopUpViewController *popUpViewController;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;
@property (strong, nonatomic) GameHamContainerViewController *ham;
@property (strong, nonatomic) StatedObject *currentObject;
@property (strong, nonatomic) NSMutableArray *allObjects;

@end

@implementation GameViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.fonImage = @"game";
    [super viewDidLoad];
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(openSite)];
}


#pragma Actions

- (void)openSite {
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (NSMutableArray *)allObjects {
    if (!_allObjects) {
        _allObjects = [[NSMutableArray alloc] init];
    }
    
    return _allObjects;
}


#pragma mark - GameChooseDelegate

- (BOOL)isCharacterSelected:(GameCharacter)character {
    return self.selectedCharacter == character;
}


- (void)selectCharacter:(GameCharacter)character {
    if ([self isCharacterSelected:character]) {
        [self showPopUpWithCharacter:character];
    } else {
        [self createHamWithCharacter:character];
        self.selectedCharacter = character;
    }
}


#pragma mark - PopUpDelegate

- (void)close {
    [self closeWithShadow:YES];
}



- (void)showPage:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [self closeWithShadow:NO];
    PopUpParameters *param = [[PopUpParameters alloc] init];
    param.isInitialView = NO;
    param.curentPage = pageToShow;
    param.fromRightToLeft = prev;
    self.popUpViewController = [PopUpViewController instantiatePageNumber:param delegate:self];
    [self.view addSubview:self.popUpViewController.view];
}



#pragma mark - GameLeftMenuDelegate

- (void)takeSnapshot {
    [self hideAllChilds];
    UIImage *image = [UIImage captureScreenInView:self.view];
    [self showAllChilds];
    [self goToMakeCard:image];

}


- (void)startNewGame {
    [self.ham hideViewWithCompletion:nil];
    [self cleanAllResources];
}


- (void)pressedToyWithID:(NSString *)toyID {
    if (self.currentObject) {
        [self.currentObject cleanResources];
    }

    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:@"toys" extension:@"plist"]];
    NNKObjectParameters *params = [[NNKObjectParameters alloc] initWithDictionary:dict[toyID]];
    self.currentObject = [[StatedObject alloc] initWithParameters:params delegate:self];

    NSLog(@"toyID = %@", toyID);
}


- (void)objectInteracted:(StatedObject *)object {
    if ([self.currentObject isEqual:object]) {
        [self.allObjects addObject:self.currentObject];
        self.currentObject = nil;
    }
}


#pragma mark - Private Methods

- (void)createHamWithCharacter:(GameCharacter)character {
    if (!self.ham) {
        self.ham = [GameHamContainerViewController instantiateWithWidth:0.4 * CGRectGetWidth(self.view.frame)
                                                              character:character
                                                               delegate:self];
        [StoryboardUtils addViewController:self.ham onViewController:self];

    } else {
    [self.ham hideViewWithCompletion:^{
        [self.ham.view removeFromSuperview];
        self.ham = [GameHamContainerViewController instantiateWithWidth:0.4 * CGRectGetWidth(self.view.frame)
                                                              character:character
                                                               delegate:self];
        [StoryboardUtils addViewController:self.ham onViewController:self];
    }];
    }
}


- (void)hideAllChilds {
    for (UIViewController *child in self.childViewControllers) {
        child.view.hidden = YES;
    }
}


- (void)showAllChilds {
    for (UIViewController *child in self.childViewControllers) {
        child.view.hidden = NO;
    }
}


- (void)goToMakeCard:(UIImage *)image {
    MakeACardViewController *makeCard = [MakeACardViewController instantiateWithImage:image];
    [self presentViewController:makeCard animated:YES completion:nil];
}


- (void)closeWithShadow:(BOOL)withShadow {
    if (withShadow) {
        [self closeAndHideShadow];
    } else {
        [self closeWithoutHidingShadow];
    }
}


- (void)closeAndHideShadow {
    __weak GameViewController *weakSelf = self;
    [PopUpAnimations animationForAppear:NO forView:self.shadowView withCompletionBlock:^(BOOL finished) {
        [weakSelf.popUpViewController.view removeFromSuperview];
        weakSelf.popUpViewController = nil;
    }];
}


- (void)closeWithoutHidingShadow {
    [self.popUpViewController.view removeFromSuperview];
    self.popUpViewController = nil;
}


- (void)cleanAllResources {
    for (StatedObject *object in self.allObjects) {
        [object cleanResources];
    }
    if (self.currentObject) {
        [self.currentObject cleanResources];
    }
}


- (void)showPopUpWithCharacter:(GameCharacter)character {
    [self.view bringSubviewToFront:self.shadowView];
    [PopUpAnimations animationForAppear:YES forView:self.shadowView withCompletionBlock:nil];
    PopUpParameters *params = [[PopUpParameters alloc] init];
    params.fromRightToLeft = NO;
    params.curentPage = character - 1;
    params.isInitialView = YES;
    PopUpViewController *popUp = [PopUpViewController instantiatePageNumber:params delegate:self];
    [StoryboardUtils addViewController:popUp onViewController:self];
}

@end