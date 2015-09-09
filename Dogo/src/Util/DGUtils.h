//
//  DGUtils.h
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

/*
 * A collection of utils methods and functions to make the world a better place :D
 */
@interface DGUtils : NSObject

#pragma mark - General Utils

//! Check if value is null or nil
+ (BOOL)isNullValue:(id)rawValue;

#pragma mark - SQLite Utils

//! Convert the raw value to a valid statement format
+ (NSString *)convertValueToSQLiteStatement:(id)rawValue;

@end