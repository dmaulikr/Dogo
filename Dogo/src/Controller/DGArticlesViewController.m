//
//  DGArticlesViewController.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticlesViewController.h"

#import "UIColor+Dogo.h"
#import "NSMutableArray+DGArticle.h"

#import "DGArticle.h"
#import "DGArticleCell.h"
#import "DGArticleDetailViewController.h"

@import EventKit;

@interface DGArticlesViewController()

@property (nonatomic, strong) DGArticleFetcher *fetcher;
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) UILabel *lblDefaultMessage;

@end

@implementation DGArticlesViewController

#pragma mark - Constants

static NSString *const ArticleCellIdentifier = @"ArticleCell";
static NSString *const ArticleCellWithImageIdentifier = @"ArticleCellWithImage";

#pragma mark - <UIViewController> Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupDefaultMessage];
    [self setupFetcherAndGetData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // just reload table view items
    [self reloadTableView];
}

#pragma mark - Setup

- (void)setupNavigationBar
{
    // style; solid color
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.translucent = false;
    navigationBar.barStyle = UIBarStyleBlack;
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.barTintColor = [UIColor backgroundNavigationColor];
    
    // setup title and back button font size
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont  systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];

    // right buttons. Sort and Refresh buttons
    UIBarButtonItem *btnSortBy = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar-sort-by"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSortByClick:)];
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar-refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(btnRefreshClick)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSortBy, btnRefresh, nil];
}

- (void)setupTableView
{
    self.tableView.alwaysBounceVertical = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // This will remove extra separators from tableview
}

- (void)setupDefaultMessage
{
    // now configure no article label and show it
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    _lblDefaultMessage = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, (self.view.frame.size.height-navBarHeight)/2, self.view.frame.size.width-30, 20))];
    _lblDefaultMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin; // auto resize width / center
    _lblDefaultMessage.textAlignment = NSTextAlignmentCenter;
    _lblDefaultMessage.numberOfLines = 0;
    _lblDefaultMessage.textColor = [UIColor defaultFontColor];
    _lblDefaultMessage.font = [UIFont systemFontOfSize:16];
    _lblDefaultMessage.text = NSLocalizedString(@"[Loading Articles]", nil);
    [self.view addSubview:_lblDefaultMessage];
}

- (void)setupFetcherAndGetData
{
    // first create fetcher so start fetch data operation
    _fetcher = [[DGArticleFetcher alloc] initWithDelegate:self];
    [_fetcher fetchData:false];
}

#pragma mark - <Navigation>

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DGArticle *article = _articles[indexPath.row];
    DGArticleDetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.article = article;
}

#pragma mark - <UITableView>

- (void)reloadTableView
{
    [self.tableView reloadData];
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
    return article.image != nil;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Workaround. This can be improved with autolayout features but I don't know how :(
    if ([self hasImageAtIndexPath:indexPath]) {
        return [[DGAppDelegate sharedInstance] isLandscapeOrientation] ? 275 : 300;
    } else {
        return [[DGAppDelegate sharedInstance] isLandscapeOrientation] ? 125 : 150;
    }
}

#pragma mark - <DGArticleFetcherDelegate>

//! Receive a success message from request
- (void)fetchDataSuccess:(NSArray *)articles
{
    // refresh articles list and reload table view...
    _articles = [NSMutableArray arrayWithArray:articles];
    [self reloadTableView];
    
    // now check if has articles to show... if has hide default message, otherwise show a label with custom message
    if (_articles.count > 0) {
        [self hideDefaultMessage];
    } else {
        [self showDefaultMessageWithText:NSLocalizedString(@"[No Articles]", nil)];
    }
}

//! Receive an error from request
- (void)fetchDataError:(NSError *)error
{
    // clear table view and show default message with error text...
    _articles = [[NSMutableArray alloc] init];
    [self reloadTableView];
    [self showDefaultMessageWithText:[NSString stringWithFormat:@"%@. %@", NSLocalizedString(@"[Error Retrieving Articles]", nil), [error localizedDescription]]];

    // ... and show alert with error message
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
}

#pragma mark - Default Message Control

//! Show lblDefaultMessage with custom text passed by param
- (void)showDefaultMessageWithText:(NSString *)text
{
    _lblDefaultMessage.text = text;
    [self.view addSubview:_lblDefaultMessage];
}

//! Just remove lblDefaultMessage from view
- (void)hideDefaultMessage
{
    [_lblDefaultMessage removeFromSuperview];
}

#pragma mark - Navigation Bar Buttons Handle

//! Ask to user wich field he wants sort the articles list and apply to articles list
- (void)btnSortByClick:(id)sender
{
    // create and configure
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"[Sort by]", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.view.tintColor = [UIColor defaultFontColor];
    
    // fields list
    UIAlertAction *websiteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[Website]", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self sortByField:@"website"]; }];
    UIAlertAction *authorsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[Authors]", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self sortByField:@"authors"]; }];
    UIAlertAction *dateAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[Date]", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self sortByField:@"date"]; }];
    UIAlertAction *titleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[Title]", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self sortByField:@"title"]; }];
    // cancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[Cancel]", nil) style:UIAlertActionStyleCancel handler:nil];

    // add all actions
    [alertController addAction:websiteAction];
    [alertController addAction:authorsAction];
    [alertController addAction:dateAction];
    [alertController addAction:titleAction];
    [alertController addAction:cancelAction];
    
    // configure popover (for iPad)... put it below navigation bar
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.navigationController.navigationBar;
        popover.sourceRect = self.navigationController.navigationBar.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    // finally show alert as popover action sheet
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sortByField:(NSString *)field
{
    [_articles sortByField:field];
    [self reloadTableView];
}

//! Ask to user if refresh operation can be executed
- (void)btnRefreshClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"[Reset Articles Title]", nil) message:NSLocalizedString(@"[Reset Articles Message]", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[Yes]", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){ [_fetcher fetchData:true]; }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"[No]", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end