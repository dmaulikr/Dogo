//
//  DGArticlesViewController.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticlesViewController.h"

#import "DGArticle.h"
#import "DGArticleCell.h"
#import "DGArticleDetailViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import <AFNetworking/AFNetworking.h>

@interface DGArticlesViewController()

@property (strong) NSMutableArray *articles;

@end

@implementation DGArticlesViewController

#pragma mark - Get Articles from web
//TODO: Workaround... this behavior must be encapsulated in another class/concept

static NSString *const DogoBaseURLString = @"http://www.ckl.io/challenge";

//! Get all Articles from website and reload table view data with these results.
- (void)refreshArticles
{
    // first show progress HUD and create the HTTP request operation
    [self showProgressHUD];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: DogoBaseURLString]]];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // if operation is completed with success populate articles array and reload table view data
        _articles = [[NSMutableArray alloc] init];
        DGArticle *article;
        NSArray *result = (NSArray *) responseObject;
        for (NSDictionary *dict in result) {
            article = [[DGArticle alloc] init];
            article.website = [dict valueForKey:@"website"];
            article.title = [dict valueForKey:@"title"];
            article.authors = [dict valueForKey:@"authors"];
            article.date = [dict valueForKey:@"date"];
            article.imageURL = [dict valueForKey:@"image"];
            article.imageURL = article.imageURL == (id)[NSNull null] ? nil : article.imageURL;
            article.content = [dict valueForKey:@"content"];
            [_articles addObject:article];
        }
        [self reloadTableView];
        [self hideProgressHUD];
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // if occurs any error show it to user and cancel operation
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:NSLocalizedString(@"[Error Retrieving Articles]", nil)
                                              message:[error localizedDescription]
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"[OK]", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self hideProgressHUD];
        DGLog(@"Error: %@", error);
    }];
    
    // start HTTP request operation
    [operation start];
}

#pragma mark - Constants

static NSString *const ArticleCellIdentifier = @"ArticleCell";
static NSString *const ArticleCellWithImageIdentifier = @"ArticleCellWithImage";

#pragma mark - <UIViewController> Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshArticles];
}

#pragma mark - <Navigation>

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DGArticle *article = _articles[indexPath.row];
    DGArticleDetailViewController *viewController = [segue destinationViewController];
    viewController.article = article;
}

#pragma mark - <UITableView>

- (void)reloadTableView
{
    // this must be executed in the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get correct cell design and load article fields into it
    DGArticleCell *cell;
    if ([self hasImageAtIndexPath:indexPath]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:ArticleCellWithImageIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:ArticleCellIdentifier forIndexPath:indexPath];
    }
    [cell loadArticle:_articles[indexPath.row]];
    return cell;
}

- (BOOL)hasImageAtIndexPath:(NSIndexPath *)indexPath
{
    DGArticle *article = _articles[indexPath.row];
    return article.imageURL;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self hasImageAtIndexPath:indexPath]) {
        return [self isLandscapeOrientation] ? 275 : 300;
    } else {
        return [self isLandscapeOrientation] ? 125 : 150;
    }
}

#pragma mark - <Progress HUD>

- (void)showProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MBProgressHUD HUDForView:self.view] setLabelText:NSLocalizedString(@"[Loading]", nil)];
}

- (void)hideProgressHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - Utils

- (BOOL)isLandscapeOrientation
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

@end