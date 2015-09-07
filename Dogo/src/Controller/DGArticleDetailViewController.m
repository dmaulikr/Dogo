//
//  DGArticleDetailViewController.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleDetailViewController.h"

#import "UIImageView+AFNetworking.h"

@implementation DGArticleDetailViewController

#pragma mark - <UIViewController> Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadArticle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // set article as read
    _article.read = true;
}

#pragma mark - Load Article

- (void)loadArticle
{
    // view title
    self.navigationItem.title = _article.title;
    
    // website
    _lblWebsite.text = _article.website;
    // authors + date
    _lblAuthors.text = [NSString stringWithFormat:@"by %@ on %@", _article.authors, _article.date];
    // image
    [_imgViewThumb setImage:nil];
    [_imgViewThumb setImageWithURL:[NSURL URLWithString:_article.imageURL]];
    // title
    _lblTitle.text = _article.title ?: NSLocalizedString(@"[No Title]", nil);
    // content (justified)
    NSString *content = [NSString stringWithFormat:@"%@%@%@%@", _article.content, _article.content, _article.content, _article.content];
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;
    paragraphStyles.firstLineHeadIndent = 0.1; // this is necessary to make work
    _lblContent.attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName: paragraphStyles}];
}

@end