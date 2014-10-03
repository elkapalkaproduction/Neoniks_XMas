//
//  UIImage+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "UIImage+Helps.h"
#import "NSString+Helps.h"
#import "DeviceUtils.h"

NSString *const fonSufix = @"_fon";
NSString *const iphone4FonPrefix = @"iphone4_";
NSString *const iphone6FonPrefix = @"iphone6_";
NSString *const ipadFonPrefix = @"ipad_";

NSString *const bannerPrefix = @"banner_";
NSString *const textPrefix = @"text_";

@implementation UIImage (Helpers)

+ (UIImage *)backgroundImageWithName:(NSString *)name {
    if (!name) return nil;
    NSString *imageName = [name stringByAppendingString:fonSufix];
    if ([DeviceUtils isIphone4]) {
        imageName = [iphone4FonPrefix stringByAppendingString:imageName];
    } else if ([DeviceUtils isIphone]) {
        imageName = [iphone6FonPrefix stringByAppendingString:imageName];
    } else {
        imageName = [ipadFonPrefix stringByAppendingString:imageName];
    }
    UIImage *image = [UIImage imageWithLocalizedName:imageName];
    if (image) return image;
    image = [UIImage imageWithUnlocalizedName:imageName];
    
    return image;
}


+ (UIImage *)bannerImageWithName:(NSString *)name {
    if (!name) return nil;
    NSString *imageName = [bannerPrefix stringByAppendingString:name];
    
    return [UIImage imageWithUnlocalizedName:imageName];
}

+ (UIImage *)textImageWithName:(NSString *)name {
    if (!name) return nil;
    NSString *imageName = [textPrefix stringByAppendingString:name];
    
    return [UIImage imageWithUnlocalizedName:imageName];
}


+ (UIImage *)imageWithUnlocalizedName:(NSString *)name {
    if (!name) return nil;
    NSString *localizedString = [NSString neoniksLocalizedString:name];

    return [UIImage imageWithLocalizedName:localizedString];
}


+ (UIImage *)imageWithLocalizedName:(NSString *)name {
    if (!name) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    if (!path)
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}


+ (UIImage *)captureScreenInView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}


@end
