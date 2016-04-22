//
//  NSDate+Dogo.h
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

@interface NSDate (Dogo)

#pragma mark - Class Methods

//! convert a date from string to NSDate object using the format passed by param.
+ (NSDate *)stringToDate:(NSString *)string withDateFormat:(NSString *)dateFormat;

//! convert a date from string to NSDate object using default date format
+ (NSDate *)stringToDate:(NSString *)string;

#pragma mark - Instance Methods

//! extract date value an return it as NSString value using date format passed by param
- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormat;

//! extract date value an return it as NSString value using default date format
- (NSString *)dateToString;

@end