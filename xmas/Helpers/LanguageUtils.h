//
//  LanguageSettings.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

@interface LanguageUtils : NSObject

+ (void)setupLanguage;

+ (BOOL)isRussian;
+ (BOOL)isEnglish;

+ (void)setRussianLanguage;
+ (void)setEnglishLanguage;

+ (void)setOpositeLanguage;

+ (NSNumber *)currentValue;

@end
