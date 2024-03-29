//
//  STAAbstractAd.h
//  StartAppAdSDK
//
//  Copyright (c) 2013 StartApp. All rights reserved.
//  SDK version 2.2.0

#import <Foundation/Foundation.h>
@class STAAbstractAd; // << Forward declaration
@protocol STADelegateProtocol <NSObject>
@optional

- (void) didLoadAd:(STAAbstractAd*)ad;
- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error;
- (void) didShowAd:(STAAbstractAd*)ad;
- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error;
- (void) didCloseAd:(STAAbstractAd*)ad;

@end


@interface STAUserLocation : NSObject
@property  double latitude;
@property  double longitude;
@end

// STAAdPreferences holds params specific to an ad
@interface STAAdPreferences : NSObject
@property (nonatomic,retain) STAUserLocation *userLocation;
@property (nonatomic, retain) NSString *adTag;

+ (instancetype)prefrencesWithLatitude:(double) latitude andLongitude:(double)longitude andAdTag:(NSString *) adTag;
@end




@interface STAAbstractAd : NSObject

@property (nonatomic, strong) STAAdPreferences *preferences;

- (BOOL) isReady;   // always check if ready before calling showAd

@end
