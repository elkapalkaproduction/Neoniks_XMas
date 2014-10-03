//
//  NSString+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NSString+Helps.h"
#import "LanguageUtils.h"

@implementation NSString (Helpers)

+ (NSString *)neoniksLocalizedString:(NSString *)input {
    NSString *string = (NSString *)input;
    string = [NSString stringWithFormat:@"%@_%@", string, [LanguageUtils isRussian] ? @"rus":@"eng"];

    return string;
}

@end
