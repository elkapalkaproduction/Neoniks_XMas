//
//  AppDelegate.m
//  xmas
//
//  Created by Andrei Vidrasco on 9/26/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "XMasGoogleAnalitycs.h"
#import "MenuViewController.h"
#import "LogoViewController.h"
#import "ABX.h"

#ifdef FreeVersion
#import "AdsManager.h"
#endif

NSString *const xmasAppID = @"918984559";
NSString *const bookAppID = @"899196882";

@interface AppDelegate ()

@property (strong, nonatomic) MenuViewController *viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LanguageUtils setupLanguage];
    [XMasGoogleAnalitycs sharedManager];
#ifdef FreeVersion
    [[ABXApiClient instance] setApiKey:@"4032c9dec97ddfe4dbfa59759476b332c042e486"];
    [[AdsManager sharedManager] setupAllLibraries];
#else
    [[ABXApiClient instance] setApiKey:@"b340d70c56709abe373b9a90ce25d2a10a745d61"];
#endif

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LogoViewController *logoViewController = [[LogoViewController alloc] initWithNibName:@"LogoViewController" bundle:nil];
    self.viewController = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:[MenuViewController storyboardID]];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.navController pushViewController:logoViewController animated:NO];
    [self.navController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];    // Override point for customization after application launch.
    

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
