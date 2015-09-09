//
//  DGArticleFetcher.m
//  Dogo
//
//  Created by Marsal on 07/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleFetcher.h"

#import "DGArticle.h"
#import "DGArticleDAO.h"

#import <AFNetworking/AFNetworking.h>
#import <KVNProgress/KVNProgress.h>

@interface DGArticleFetcher ()

@property (nonatomic, strong) DGArticleDAO *articleDAO;;

@end

@implementation DGArticleFetcher

#pragma mark - Constants

static NSString *const FetchArticlesFromURL = @"http://www.ckl.io/challenge";

#pragma mark - Init

//! Initialize and return a new DGArticleFetcher instance with a delegate
- (instancetype) initWithDelegate:(id<DGArticleFetcherDelegate>) delegate
{
    self = [super init];
    _delegate = delegate;
    _articleDAO = [[DGArticleDAO alloc] init];
    return self;
}

#pragma mark - Fetch Data (Articles)

/*
 * Responsible for fetch Articles following these rules:
 *  - If app doesn't have any Article saved into database (SQLite) get all articles from website and save its into into app;
 *  - Get all app and return its to delegate;
 * If reset @param is 'true' all device articles will be erased and refetch them from web again.
 */
- (void) fetchData:(BOOL)reset
{
    [self showProgressHUD];
    
    // first check 'reset' param... if 'true' delete all app articles and refetch them from web... otherwise continue normally
    if (reset) {
    
        [_articleDAO deleteAllArticles];
        [self fetchDataFromWeb];
        
    } else {
    
        // try to get articles from disk... if found return its, otherwise try to get data from web
        NSArray *articlesFromDisk = [_articleDAO fetchData];
        if (articlesFromDisk.count > 0) {
            // just check delegate and send articles
            [self checkDelegate];
            [_delegate fetchDataSuccess:articlesFromDisk];
            [self hideProgressHUD];
        } else {
            // get articles from web
            [self fetchDataFromWeb];
        }
    }
}

/*
 * Get articles from web, save its into disk and return the result to delegate
 */
- (void)fetchDataFromWeb
{
    // create and configure HTTP request operation
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: FetchArticlesFromURL]]];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        DGLog(@"HTTP Request Sucess. Response status code: %ld", (long)operation.response.statusCode);
        
        // get articles from web and extract its into a new array to persist its into disk.
        NSMutableArray *articlesFromWeb = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in (NSArray *) responseObject) {
            [articlesFromWeb addObject:[[DGArticle alloc] initWithDict:dict]];
        }
        [_articleDAO insertArticles:articlesFromWeb];
        
        // finally check delegate and send result
        [self checkDelegate];
        [_delegate fetchDataSuccess:articlesFromWeb];
        [self hideProgressHUD];
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        DGLog(@"Error: %@", error);
        
        // just send error sign to delegate
        [self checkDelegate];
        [_delegate fetchDataError:error];
        [self hideProgressHUD];
        
    }];
    
    // start HTTP request operation in a separated thread
    [requestOperation start];
}

#pragma mark - Progress HUD Control

- (void)showProgressHUD
{
    // this must be executed in the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showWithStatus:NSLocalizedString(@"[Loading]", nil)];
    });
}

- (void)hideProgressHUD
{
    // this must be executed in the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}

#pragma mark - Utils

//! Just check if fetcher has a delegate associated... if not raise an exception
- (void)checkDelegate
{
    if (![_delegate respondsToSelector:@selector(fetchDataSuccess:)]) {
        [NSException raise:@"DGArticleFetcher Error" format:@"There isn't any delegate defined."];
    }
}

//! Return if device has or doesn't have internet/network connection
- (BOOL)hasNetworkConnection
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end