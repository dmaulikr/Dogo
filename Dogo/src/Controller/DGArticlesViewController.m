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

@import EventKit;

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
        NSArray *result = (NSArray *) responseObject;
        for (NSDictionary *dict in result) {
            [_articles addObject:[[DGArticle alloc] initWithDic:dict]];
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
    
    [self setup];
    [self refreshArticles];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadTableView];
}

- (void)setup
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(organize:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Sort by]", nil) style:UIBarButtonItemStylePlain target:self action:@selector(organize:)];
}

- (void)organize:(id)organize
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"[Sort by]", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"[Cancel]", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"[Website]", nil), NSLocalizedString(@"[Authors]", nil), NSLocalizedString(@"[Date]", nil), NSLocalizedString(@"[Title]", nil), nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

#pragma mark - <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSSortDescriptor *sortDescriptor;
    NSArray *customSortDescription;
    
    switch (buttonIndex) {
        case 0:
            //Authors
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"authors" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            break;
        case 1:
            //Date
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            break;
        case 2:
            //Title
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            break;
        case 3:
            //Website
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"website" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            break;
        default:
            break;
    }

    // if not canceled sort the article list
    if (customSortDescription) {
        [_articles sortUsingDescriptors:customSortDescription];
        [self reloadTableView];
    }
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