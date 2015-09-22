//
//  DGArticleDAO.m
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleDAO.h"

#import "DGDatabase.h"

#import "NSDate+Dogo.h"
#import "DGUtils.h"

@interface DGArticleDAO ()

@property (nonatomic, strong) DGDatabase *database;

@end

@implementation DGArticleDAO

#pragma mark - Static Query Statements

// Query statement used to get all articles
static NSString *const queryStatement = @"SELECT website, title, authors, date, image, content, read FROM Article ORDER BY date";
static NSString *const insertStatement = @"INSERT INTO Article (website, title, authors, date, image, content, read) VALUES (%@, %@, %@, %@, %@, %@, %@)";
static NSString *const updateStatement = @"UPDATE Article set read = %@ WHERE title = %@";
static NSString *const deleteAllStatement = @"DELETE FROM Article";

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    _database = [[DGDatabase alloc] init];
    return self;
}

#pragma mark - Load

//! Fetch articles from database (SQLite)
- (NSArray *)fetchData
{
//    DGLog([[DGAppDelegate sharedInstance] applicationDatabaseDirectory]);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    _database = [[DGDatabase alloc] init];
    [_database open];
    @try {
        FMResultSet *rs = [_database executeQuery:queryStatement];
        while ([rs next]) {
            [result addObject:[[DGArticle alloc] initWithDict:[rs resultDictionary]]];
        }
        [rs close];
    } @catch (NSException *exception) {
        DGLog(@"Exception: %@", exception.description);
        @throw;
    } @finally {
        [_database close];
    }
    return result;
}

#pragma mark - Insert / Update / Delete

//! Insert one DGArticle instance into database
- (void)insertArticle:(DGArticle *)article
{
    [_database open];
    @try {
        [_database executeUpdate:[NSString stringWithFormat:insertStatement,
                                  [DGUtils convertValueToSQLiteStatement:article.website],
                                  [DGUtils convertValueToSQLiteStatement:article.title],
                                  [DGUtils convertValueToSQLiteStatement:article.authors],
                                  [NSString stringWithFormat:@"'%@'", [article.date dateToString]],
                                  [DGUtils convertValueToSQLiteStatement:article.image],
                                  [DGUtils convertValueToSQLiteStatement:article.content],
                                  [NSNumber numberWithBool:article.read]]];
    } @catch (NSException *exception) {
        NSLog(@"[%@][%@] Exception: %@", [self class], NSStringFromSelector(_cmd), exception.description);
        @throw;
    } @finally {
        [_database close];
    }
}

//! Insert a list of DGArticle instances into database
- (void)insertArticles:(NSArray *)articles
{
    for (DGArticle *article in articles) {
        [self insertArticle:article];
    }
}

//! Update one DGArticle instance
- (void)updateArticle:(DGArticle *)article
{
    [_database open];
    @try {
        [_database executeUpdate:[NSString stringWithFormat:updateStatement, [NSNumber numberWithBool:article.read], [DGUtils convertValueToSQLiteStatement:article.title]]];
    } @catch (NSException *exception) {
        NSLog(@"[%@][%@] Exception: %@", [self class], NSStringFromSelector(_cmd), exception.description);
        @throw;
    } @finally {
        [_database close];
    }
}

//! Clear DGArticle table
- (void)deleteAllArticles
{
    [_database open];
    @try {
        [_database executeUpdate:deleteAllStatement];
    } @catch (NSException *exception) {
        NSLog(@"[%@][%@] Exception: %@", [self class], NSStringFromSelector(_cmd), exception.description);
        @throw;
    } @finally {
        [_database close];
    }
}

@end