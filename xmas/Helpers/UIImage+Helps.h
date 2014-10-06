//
//  UIImage+Helps.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

@interface UIImage (Helpers)

+ (UIImage *)backgroundImageWithName:(NSString *)name;
+ (UIImage *)bannerImageWithName:(NSString *)name;
+ (UIImage *)textImageWithName:(NSString *)name;

+ (UIImage *)imageWithUnlocalizedName:(NSString *)name;
+ (UIImage *)imageWithLocalizedName:(NSString *)name;

+ (UIImage *)captureScreenInView:(UIView *)view;

+ (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image;

@end
