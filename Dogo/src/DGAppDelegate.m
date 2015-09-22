//
//  DGAppDelegate.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>

@implementation DGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // enable AFNetwork logger and network activity indicator
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Singleton / Fast Access

//! Return shared app delegate instance (singleton)
+ (instancetype)sharedInstance
{
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark - Utils

//! Return the database full path (directory+databasename)
- (NSString *)applicationDatabaseDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Database/Dogo.sqlite"];
}

//! Return the status bar height if it's visible
- (CGFloat)statusBarHeight
{
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarHidden ? CGSizeMake(0, 0) : [UIApplication sharedApplication].statusBarFrame.size;
    statusBarSize = CGSizeMake(MAX(statusBarSize.width, statusBarSize.height), MIN(statusBarSize.width, statusBarSize.height));
    return statusBarSize.height;
}

//! Check if device is in landscape orientation
- (BOOL)isLandscapeOrientation
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

@end