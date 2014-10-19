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
#import "XMasGoogleAnalitycs.h"
#import "SoundPlayer.h"
#import "NNKAlertView.h"

NSString *const pathToPlist = @"toys_scalable";
//NSString *const pathToPlist = @"toys";

@interface GameViewController () <GameChooseDelegate, GameLeftMenuDelegate, PopUpDelegate, HamDelegate, StatedObjectDelegate, UIDynamicAnimatorDelegate, NNKAlertViewDelegate>

@property (assign, nonatomic) GameCharacter selectedCharacter;
@property (strong, nonatomic) PopUpViewController *popUpViewController;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;
@property (strong, nonatomic) GameHamContainerViewController *ham;
@property (strong, nonatomic) StatedObject *currentObject;
@property (strong, nonatomic) NSMutableArray *allObjects;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSTimer *checkingTimer;
@property (nonatomic, strong) StatedObject *objectToRemove;
@property (nonatomic, strong) GameChooseContainerViewController *chooseContainer;

@end

@implementation GameViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.fonImage = @"game";
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.shadowView];
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(openSite)];
}


- (void)updateInterface {
    [super updateInterface];
    self.siteButton.image = [UIImage imageWithUnlocalizedName:@"site"];
}


#pragma mark - Actions

- (void)openSite {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsWebsite label:[DeviceUtils deviceName] value:[LanguageUtils currentValue]];
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


#pragma mark - Custom Accessors

- (NSMutableArray *)allObjects {
    if (!_allObjects) {
        _allObjects = [[NSMutableArray alloc] init];
    }
    
    return _allObjects;
}


- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    
    return _animator;
}


- (void)setSelectedCharacter:(GameCharacter)selectedCharacter {
    if (selectedCharacter != _selectedCharacter) {
        _selectedCharacter = selectedCharacter;
        [self createHamWithCharacter:_selectedCharacter];
    }
}


- (GameChooseContainerViewController *)chooseContainer {
    if (_chooseContainer) {
        return _chooseContainer;
    }
    for (UIViewController *child in self.childViewControllers) {
        if ([child isKindOfClass:[GameChooseContainerViewController class]]) {
            _chooseContainer = (GameChooseContainerViewController *)child;
        }
    }
    
    return _chooseContainer;

}


#pragma mark - GameChooseDelegate

- (void)selectCharacter:(GameCharacter)character {
    [self showPopUpWithCharacter:character];
}


- (void)centralCharacterChanged:(GameCharacter)character {
    self.selectedCharacter = character;
}


#pragma mark - PopUpDelegate

- (void)close {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsPlayPopupClosed label:[@(self.popUpViewController.curentPage + 1) stringValue] value:[LanguageUtils currentValue] ];

    [self closeWithShadow:YES];
}



- (void)showPage:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsPlayArrowPopupClick label:[@(pageToShow + 1) stringValue] value:[LanguageUtils currentValue]];
    [self closeWithShadow:NO];
    PopUpParameters *param = [[PopUpParameters alloc] init];
    param.isInitialView = NO;
    param.curentPage = pageToShow;
    param.fromRightToLeft = prev;
    self.popUpViewController = [PopUpViewController instantiatePageNumber:param delegate:self];
    [self.view addSubview:self.popUpViewController.view];
}


#pragma mark - Alert View Delegate

- (void)alertView:(NNKAlertView *)alertView pressedButtonWithResponse:(BOOL)response {
    if (!response) {
        return;
    }
    if (alertView.messageType == AlertViewMessageNewGame) {
        [self updateInterface];
        [self.chooseContainer changeMainCharacter:GameCharacterPhoebe];
        
        [self cleanAllResources];
     } else if (alertView.messageType == AlertViewMessageQuit) {
        [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen action:GAnalitycsPlayReturnMenu label:nil value:[LanguageUtils currentValue]];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}


#pragma mark - GameLeftMenuDelegate

- (void)takeSnapshot {
    [self hideAllChilds];
    UIImage *image = [UIImage captureScreenInView:self.view];
    [self showAllChilds];
    [self goToMakeCard:image];

}


- (void)startNewGame {

    NNKAlertView *alert = [NNKAlertView initWithMessageType:AlertViewMessageNewGame delegate:self];
    [StoryboardUtils addViewController:alert onViewController:self belowSubview:nil];
}


#pragma mark - Game Ham Delegate

- (void)pressedToyWithID:(NSString *)toyID {
    if (self.currentObject) {
        [self.currentObject cleanResources];
    }

    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:pathToPlist extension:@"plist"]];
    NNKObjectParameters *params = [[NNKObjectParameters alloc] initWithDictionary:dict[toyID]];
    self.currentObject = [[StatedObject alloc] initWithParameters:params delegate:self];
}


- (void)draggedToyWithID:(NSString *)toyID position:(CGPoint)position end:(BOOL)end {
    if (self.currentObject) {
        [self.currentObject cleanResources];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:pathToPlist extension:@"plist"]];
    NNKObjectParameters *params = [[NNKObjectParameters alloc] initWithDictionary:dict[toyID]];
    params.frame = CGRectMake(position.x - params.frame.size.width / 2, position.y - params.frame.size.height / 2, params.frame.size.width, params.frame.size.height);
    self.currentObject = [[StatedObject alloc] initWithParameters:params delegate:self];
    if (end) {
        [self.currentObject performActions];
        [self objectInteracted:self.currentObject];
    }
}


#pragma mark - StatedObjectDelegate

- (void)objectInteracted:(StatedObject *)object {
    if ([self.currentObject isEqual:object]) {
        [self.allObjects addObject:self.currentObject];
        self.currentObject = nil;
    }
}


- (void)fireSelector:(NSString *)stringSelector inObjectId:(NSObject *)objectId {
}


- (void)shouldRemoveObject:(StatedObject *)object {
    self.objectToRemove = object;
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[object]];
    [self.animator addBehavior:gravityBehavior];
    [[SoundPlayer sharedPlayer] playSoundWithName:@"doll_falling"];
    self.checkingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkPos) userInfo:nil repeats:YES];
}


#pragma mark - Private Methods

- (void)createHamWithCharacter:(GameCharacter)character {
    if (!self.ham) {
        self.ham = [GameHamContainerViewController instantiateWithWidth:0.4 * CGRectGetWidth(self.view.frame)
                                                              character:character
                                                               delegate:self];
        [StoryboardUtils addViewController:self.ham onViewController:self belowSubview:nil];

    } else {
        __weak GameViewController *weakSelf = self;
        if (self.ham.completion) {
            self.ham.completion = ^{
                [weakSelf.ham.view removeFromSuperview];
                weakSelf.ham = [GameHamContainerViewController instantiateWithWidth:0.4 * CGRectGetWidth(weakSelf.view.frame)
                                                                      character:character
                                                                       delegate:weakSelf];
                [StoryboardUtils addViewController:weakSelf.ham onViewController:weakSelf belowSubview:weakSelf.shadowView];
            };
        } else {
            [self.ham hideViewWithCompletion:^{
                [weakSelf.ham.view removeFromSuperview];
                weakSelf.ham = [GameHamContainerViewController instantiateWithWidth:0.4 * CGRectGetWidth(weakSelf.view.frame)
                                                                          character:character
                                                                           delegate:weakSelf];
                [StoryboardUtils addViewController:self.ham onViewController:weakSelf belowSubview:weakSelf.shadowView];
            }];
        }
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
    self.popUpViewController = [PopUpViewController instantiatePageNumber:params delegate:self];
    [StoryboardUtils addViewController:self.popUpViewController onViewController:self belowSubview:nil];
}


- (void)checkPos {
    if ([[self.animator itemsInRect:self.view.bounds] count] == 0) {
        [self.checkingTimer invalidate];
        [self.animator removeAllBehaviors];
        [self.objectToRemove cleanResources];
    }
}

@end