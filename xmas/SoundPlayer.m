//
//  SoundPlayer.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "SoundPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *backgroundPlayer;
@property (strong, nonatomic) AVAudioPlayer *effectPlayer;

@end

@implementation SoundPlayer

+ (instancetype)sharedPlayer {
    static SoundPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *soundName = @"button_click.mp3";
        if (!soundName) return nil;
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
        if (!soundFilePath) return nil;
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        [_audioPlayer prepareToPlay];
    }
    
    return _audioPlayer;

}


- (AVAudioPlayer *)backgroundPlayer {
    if (!_backgroundPlayer) {
        NSString *soundName = @"xmas_bells.mp3";
        if (!soundName) return nil;
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
        if (!soundFilePath) return nil;
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        _backgroundPlayer.numberOfLoops = -1;
        [_backgroundPlayer prepareToPlay];
    }
    
    return _backgroundPlayer;
}


- (void)playClick {
    [self.audioPlayer play];
}


- (void)pauseBackgroundMusic {
    [self.backgroundPlayer pause];
}


- (void)playBakgroundMusic {
    [self.backgroundPlayer play];
}


- (BOOL)isPlayingBackgroundMusic {
    return [self.backgroundPlayer isPlaying];
}

- (void)playSoundWithName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        name = @"rmi_show";
    }
    if (!name) return;
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    if (!soundFilePath) return;
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];

    self.effectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    [self.effectPlayer prepareToPlay];
    [self.effectPlayer play];
}

@end
