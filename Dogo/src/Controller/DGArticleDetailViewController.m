//
//  DGArticleDetailViewController.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleDetailViewController.h"

#import "DGArticleDAO.h"
#import "NSDate+Dogo.h"

#import "UIImageView+AFNetworking.h"

@implementation DGArticleDetailViewController

#pragma mark - <UIViewController> Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadArticle];
}

#pragma mark - Load Article

//! Load all article info
- (void)loadArticle
{
    // view title as article title
    self.navigationItem.title = _article.title;
    
    // website
    _lblWebsite.text = _article.website;
    // authors + date
    _lblAuthors.text = [NSString stringWithFormat:@"by %@ on %@", _article.authors, [_article.date dateToStringWithDateFormat:NSLocalizedString(@"[Localized Date Format]", nil)]];
    // image
    [_imgViewThumb setImageWithURL:[NSURL URLWithString:_article.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    // title
    _lblTitle.text = _article.title ?: NSLocalizedString(@"[No Title]", nil);
    // content (justified)
    NSString *content = _article.content;
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;
    paragraphStyles.firstLineHeadIndent = 0.1; // this is necessary to make work
    _lblContent.attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName: paragraphStyles}];
    
    // finally set article as read
    _article.read = true;
    [[[DGArticleDAO alloc] init] updateArticle:_article];
}

@end