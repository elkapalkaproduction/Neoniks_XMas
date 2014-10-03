//
//  LanguageSettings.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LanguageUtils.h"

NSString *const PreferedLanguage = @"PreferedLanguage";
NSString *const RussianLanguageTag = @"ru";
NSString *const EnglishLanguageTag = @"en";

@implementation LanguageUtils

+ (void)setupLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults stringForKey:PreferedLanguage]) {
        NSString *preferredLanguage = [NSLocale preferredLanguages][0];
        preferredLanguage = [preferredLanguage isEqualToString:RussianLanguageTag] ? RussianLanguageTag : EnglishLanguageTag;
        [userDefaults setObject:preferredLanguage forKey:PreferedLanguage];
    }
}


+ (BOOL)isRussian {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:PreferedLanguage];

    return [savedLanguage isEqualToString:RussianLanguageTag];
}


+ (BOOL)isEnglish {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:PreferedLanguage];

    return [savedLanguage isEqualToString:EnglishLanguageTag];
}


+ (void)setRussianLanguage {
    [[NSUserDefaults standardUserDefaults] setObject:RussianLanguageTag forKey:PreferedLanguage];
}


+ (void)setEnglishLanguage {
    [[NSUserDefaults standardUserDefaults] setObject:EnglishLanguageTag forKey:PreferedLanguage];
}


+ (void)setOpositeLanguage {
    if ([LanguageUtils isRussian]) {
        [LanguageUtils setEnglishLanguage];
    } else {
        [LanguageUtils setRussianLanguage];
    }
}

@end
