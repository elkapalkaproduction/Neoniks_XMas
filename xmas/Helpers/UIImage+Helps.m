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


+ (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image {
    if (!image) {
        return NO;
    }
    CGSize iSize = image.size;
    CGSize bSize = [DeviceUtils screenSize];
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;
    
    UIColor *pixelColor = [[self class] colorAtPixel:point inImage:image];
    CGFloat alpha = 0.0;
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }
    
    return alpha >= 0.1f;
}


+ (UIColor *)colorAtPixel:(CGPoint)point inImage:(UIImage *)image {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0};
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY - (CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}



@end
