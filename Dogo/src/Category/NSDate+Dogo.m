//
//  NSDate+Dogo.m
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "NSDate+Dogo.h"

@implementation NSDate (Dogo)

#pragma mark - Constants

static NSString *const DefaultDateFormat = @"MM/dd/yyyy";

#pragma mark - Utils

//! return a date formatter instance with custom date format
+ (NSDateFormatter *)getDateFormatterWithDateFormat:(NSString *)dateFormat
{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"]];
    }
    [formatter setDateFormat:dateFormat];
    return formatter;
}

#pragma mark - Class Methods

//! convert a date from string to NSDate object using date format passed by param
+ (NSDate *)stringToDate:(NSString *)string withDateFormat:(NSString *)dateFormat
{
    return [[self getDateFormatterWithDateFormat:dateFormat] dateFromString:string];
}

//! convert a date from string to NSDate object using default date format
+ (NSDate *)stringToDate:(NSString *)string
{
    return [self stringToDate:string withDateFormat:DefaultDateFormat];
}

#pragma mark - Instance Methods

//! extract date value an return it as NSString value using date format passed by param
- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormat
{
    return [[NSDate getDateFormatterWithDateFormat:dateFormat] stringFromDate:self];
}

//! extract date value an return it as NSString value using default date format
- (NSString *)dateToString
{
    return [self dateToStringWithDateFormat:DefaultDateFormat];
}

@end