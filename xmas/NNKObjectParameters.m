//
//  NNKObjectParameters.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKObjectParameters.h"
#import "NNKObjectState.h"
#import "Utils.h"

NSString *const NNKType = @"type";
NSString *const NNKAnimationDirectoryPath = @"animationDirectoryPath";
NSString *const NNKFrame = @"frame";
NSString *const NNKSize = @"size";
NSString *const NNKIphone4Frame = @"iphone4Frame";
NSString *const NNKIphone5Frame = @"iphone5Frame";
NSString *const NNKIpadFrame = @"ipadFrame";
NSString *const NNKStates = @"states";

NSString *const CharacterInitialPosition = @"CharactersInitialPosition";

@interface NNKObjectParameters ()

@property (strong, nonatomic) NSString *animationDirectoryPath;
@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) NSArray *states;

@end

@implementation NNKObjectParameters

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _dict = dict;
        _frame = [self frameFromDictionary:self.dict];

    }
    
    return self;
}


- (Class)type {
    if (!_type) {
        _type = NSClassFromString(self.dict[NNKType]);
    }
    
    return _type;
}


- (NSString *)animationDirectoryPath {
    if (!_animationDirectoryPath) {
        _animationDirectoryPath = self.dict[NNKAnimationDirectoryPath];
    }
    
    return _animationDirectoryPath;
}


- (NNKObjectState *)stateAtIndex:(NSInteger)index {
    return self.states[index];
}


- (NSInteger)statesCount {
    return [self.states count];
}


- (NSArray *)states {
    if (!_states) {
        NSMutableArray *localStates = [[NSMutableArray alloc] init];
        NSArray *states = self.dict[NNKStates];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:self.animationDirectoryPath ofType:nil];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
        
        for (NSDictionary *state in states) {
            NNKObjectState *object = [[NNKObjectState alloc] initWithDictionary:state filesCount:[files count]];
            [localStates addObject:object];
        }
        _states = [[NSArray alloc] initWithArray:localStates];

    }
    
    return _states;
}


- (NSArray *)animationImages {
    if (_animationImages) return _animationImages;
    if (!self.animationDirectoryPath) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:self.animationDirectoryPath ofType:nil];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *localAnimationImages = [[NSMutableArray alloc] initWithCapacity:[files count]];
    
    for (NSString *file in files) {
        UIImage *image = [UIImage imageNamed:[self.animationDirectoryPath stringByAppendingPathComponent:[file stringByDeletingPathExtension]]];
        [localAnimationImages addObject:image];
    }
    _animationImages = [NSArray arrayWithArray:localAnimationImages];
    
    return _animationImages;
}


- (CGRect)frameFromDictionary:(NSDictionary *)dict {
    NSString *frameKey;
    if ([DeviceUtils isIphone]) {
        if ([DeviceUtils isIphone4]) {
            frameKey = NNKIphone4Frame;
        } else {
            frameKey = NNKIphone5Frame;
        }
    } else {
        frameKey = NNKIpadFrame;
    }
    NSString *deviceFrame = dict[frameKey];
    NSString *generalFrame = dict[NNKFrame];
    if (deviceFrame) {
        return CGRectFromString(deviceFrame);
    } else if (generalFrame) {
        return CGRectFromString(generalFrame);
    } else {
        NSString *size = dict[NNKSize];
        if (size) {
            CGSize siz = CGSizeFromString(size);
            siz.width /= 2;
            siz.height /= 2;
            if ([DeviceUtils isIphone]) {
                siz.width /= 2;
                siz.height /= 2;
            }
            return CGRectMake(([DeviceUtils screenSize].width - siz.width) / 2,
                              ([DeviceUtils screenSize].height - siz.height) / 2,
                              siz.width,
                              siz.height);
        }
        return CGRectZero;
    }
}

@end
