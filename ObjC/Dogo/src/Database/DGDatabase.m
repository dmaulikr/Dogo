//
//  DGDatabase.m
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGDatabase.h"

#import "DGArticle.h"

@implementation DGDatabase

#pragma mark - Init

- (instancetype)init
{
    self = [super initWithPath:[[DGAppDelegate sharedInstance] applicationDatabaseDirectory]];
    [self createDatabase];
    return self;
}

#pragma mark - Get Database Connections

//! Create the database file and his tables if is necessary. If database already is created do nothing
- (void)createDatabase
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:_databasePath]) {
        
        // create the directory path of the database file (if needed)
        NSString *directoryPath = [_databasePath stringByDeletingLastPathComponent];
        if ((![fm fileExistsAtPath:directoryPath]) && (![fm fileExistsAtPath:directoryPath])) {
            [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:true attributes:nil error:nil];
        }
        
        // at last create all tables
        [self open];
        @try {
            //TODO: maybe this string must be storage in a better place/container
            NSString *statement = @"CREATE TABLE IF NOT EXISTS Article (website TEXT, title TEXT, authors TEXT, date TEXT, image TEXT, content TEXT, read INTEGER, PRIMARY KEY (title))";
            [self executeStatements:statement];
        } @catch (NSException *exception) {
            DGLog(@"Error creating database '%@'. Error: %@", _databasePath, exception.description);
            @throw;
        } @finally {
            [self close];
        }
    }
}

/******************************************************************
 * These methods are just a wrapers to same methods in FMDatabase *
 *****************************************************************/

#pragma mark - Execute Update / Statements / Query

- (BOOL)executeUpdate:(NSString*)sql, ...
{
//    DGLog(@"%@", sql);
    return [super executeUpdate:sql];
}

- (BOOL)executeStatements:(NSString *)sql
{
//    DGLog(@"%@", sql);
    return [super executeStatements:sql];
}

- (FMResultSet *)executeQuery:(NSString*)sql, ...
{
//    DGLog(@"%@", sql);
    return [super executeQuery:sql];
}

@end