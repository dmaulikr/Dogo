//
//  DGUtils.m
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGUtils.h"

@implementation DGUtils

#pragma mark - General Utils

//! Check if value is null or nil
+ (BOOL)isNullValue:(id)rawValue
{
    return (!rawValue) || (rawValue == [NSNull null]);
}

#pragma mark - SQLite Utils

//! Convert the raw value to a valid statement format
+ (NSString *)convertValueToSQLiteStatement:(id)rawValue
{
    // if raw value is undefined save 'null' value into database... otherwise insert single quotes at beginning and end of them
    NSString *result = nil;
    if ([self isNullValue:rawValue]) {
        result = @"null";
    } else {
        result = [NSString stringWithFormat:@"'%@'", [rawValue stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
    }
    return result;
}

@end