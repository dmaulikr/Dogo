//
//  DGAppDelegate.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

// Custom logging 
#ifdef DEBUG
#define DGLog(x, ...) NSLog(@"%s[%d] %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:x, ##__VA_ARGS__] );
#else
#define DGLog(x, ...) {}
#endif

@interface DGAppDelegate : UIResponder <UIApplicationDelegate>

#pragma mark - Default

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Singleton / Fast Access

//! Return shared app delegate instance (singleton)
+ (instancetype)sharedInstance;

#pragma mark - Utils

//! Return the database full path (directory+databasename)
- (NSString *)applicationDatabaseDirectory;

//! Return the status bar height if it's visible
- (CGFloat)statusBarHeight;

//! Check if device is in landscape orientation
- (BOOL)isLandscapeOrientation;

@end