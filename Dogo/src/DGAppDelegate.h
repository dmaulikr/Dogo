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

@property (strong, nonatomic) UIWindow *window;

@end