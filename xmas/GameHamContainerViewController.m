//
//  GameHamContainerViewController.m
//  xmas
//
//  Created by Andrei Vidrasco on 10/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameHamContainerViewController.h"
#import "NNKShapedButton.h"
#import "XMasGoogleAnalitycs.h"
#import "SoundPlayer.h"

@interface GameHamContainerViewController () <UIDynamicAnimatorDelegate>
@property (strong, nonatomic) IBOutletCollection(NNKShapedButton) NSArray *toys;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) GameCharacter character;
@property (weak, nonatomic) id<HamDelegate> delegate;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSTimer *checkingTimer;

@end

@implementation GameHamContainerViewController

+ (instancetype)instantiateWithWidth:(CGFloat)width
                           character:(GameCharacter)character
                            delegate:(id<HamDelegate>)delegate {
    GameHamContainerViewController *ham = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:@"GameHamContainerViewController"];
    ham.view.frame = CGRectMake(0, 0, width, width * 638 / 672);
    ham.character = character;
    ham.delegate = delegate;
    
    return ham;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SoundPlayer sharedPlayer] playSoundWithName:@"puff"];
    [self setupToys];
    [self adjustView];
    [self.view layoutIfNeeded];
    [self startAnimation];
}


- (void)startAnimation {
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    self.contentView.frame = CGRectMake(- width / 2, - height, width, height);
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finished) {
    }];
}


- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    
    return _animator;
}


- (void)hideViewWithCompletion:(void (^)(void))completion {
    _completion = completion;
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.contentView]];
    gravityBehavior.gravityDirection = CGVectorMake(-0.5, -1);
    [self.animator addBehavior:gravityBehavior];
    self.checkingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(chechPos) userInfo:nil repeats:YES];
}


- (void)chechPos {
    if ([[self.animator itemsInRect:self.view.bounds] count] == 0) {
        [self.checkingTimer invalidate];
        [self.animator removeAllBehaviors];
        if (_completion) {
            _completion();
        }
    }
}


- (void)toyPressed:(NNKShapedButton *)sender {
    NSInteger idx = [self.toys indexOfObject:sender];
    NSString *toyID = [self toyForCharacter:self.character imageNumber:idx];
    [[XMasGoogleAnalitycs sharedManager] logEventWithCategory:GAnalitycsCategoryPlayScreen
                                                       action:GAnalitycsPlayXmasToy
                                                        label:toyID
                                                        value:[LanguageUtils currentValue]];

    [self.delegate pressedToyWithID:toyID];
}


- (void)setupToys {
    [self.toys enumerateObjectsUsingBlock:^(NNKShapedButton *toy, NSUInteger idx, BOOL *stop) {
        NSString *imageName = [self toyForCharacter:self.character imageNumber:idx];
        toy.image = [UIImage imageWithLocalizedName:imageName];
        [toy addTarget:self action:@selector(toyPressed:) forControlEvents:UIControlEventTouchUpInside];
        [toy addTarget:[SoundPlayer sharedPlayer] action:@selector(playSoundWithName:) forControlEvents:UIControlEventTouchUpInside];
    }];
}


- (void)adjustView {
    if (self.character == GameCharacterJay ||
        self.character == GameCharacterJustacreep) {
        [self.contentView bringSubviewToFront:self.toys[0]];
    }
}


- (NSString *)toyForCharacter:(NSInteger)character imageNumber:(NSInteger)toy {
    return [NSString stringWithFormat:@"toy_%ld_%ld", (long)character, (long)toy];
    
}

@end
