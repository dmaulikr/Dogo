//
//  DGArticlesViewController.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticlesViewController.h"

#import "DGArticle.h"
#import "DGArticleBasicCell.h"
#import "DGArticleFullCell.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface DGArticlesViewController()

@property (strong) NSMutableArray *articles;

@end

@implementation DGArticlesViewController

#pragma mark - Get Artciles from web
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
                                              alertControllerWithTitle:@"Error Retrieving Articles"
                                              message:[error localizedDescription]
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self hideProgressHUD];
        DGLog(@"Error: %@", error);
    }];
    
    // start HTTP request operation
    [operation start];
}

#pragma mark - Constants

static NSString *const DGArticleFullCellIdentifier = @"DGArticleFullCell";
static NSString *const DGArticleBasicCellIdentifier = @"DGArticleBasicCell";

#pragma mark - <UIViewController> Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshArticles];
}

#pragma mark - <UITableView>

- (void)reloadTableView
{
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
    if ([self hasImageAtIndexPath:indexPath]) {
        return [self galleryCellAtIndexPath:indexPath];
    } else {
        return [self basicCellAtIndexPath:indexPath];
    }
}

- (BOOL)hasImageAtIndexPath:(NSIndexPath *)indexPath
{
    DGArticle *article = _articles[indexPath.row];
    return article.imageURL;
}

- (DGArticleFullCell *)galleryCellAtIndexPath:(NSIndexPath *)indexPath
{
    DGArticleFullCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DGArticleFullCellIdentifier forIndexPath:indexPath];
    [self configureImageCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureImageCell:(DGArticleFullCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DGArticle *article = _articles[indexPath.row];
    
    // website
    cell.lblWebsite.text = article.website;
    // authors + date
    cell.lblAuthors.text = [NSString stringWithFormat:@"by %@ on %@", article.authors, article.date];
    // image
    [cell.imgViewThumb setImage:nil];
    [cell.imgViewThumb setImageWithURL:[NSURL URLWithString:article.imageURL]];
    // title
    cell.lblTitle.text = article.title ?: NSLocalizedString(@"[No Title]", nil);
    // content (justified)
    NSString *content = article.content;
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;
    paragraphStyles.firstLineHeadIndent = 0.1; // this is necessary to make work
    cell.lblContent.attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName: paragraphStyles}];
}

- (DGArticleBasicCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath
{
    DGArticleBasicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DGArticleBasicCellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(DGArticleBasicCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DGArticle *article = _articles[indexPath.row];
    // website
    cell.lblWebsite.text = article.website;
    // authors + date
    cell.lblAuthors.text = [NSString stringWithFormat:@"by %@ on %@", article.authors, article.date];
    // title
    cell.lblTitle.text = article.title ?: NSLocalizedString(@"[No Title]", nil);
    // content
    cell.lblContent.text = article.content;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

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
    [[MBProgressHUD HUDForView:self.view] setLabelText:@"Loading"];
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