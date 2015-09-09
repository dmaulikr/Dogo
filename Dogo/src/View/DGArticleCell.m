//
//  DGArticleCell.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleCell.h"

#import "UIImageView+AFNetworking.h"
#import "UIColor+Dogo.h"
#import "NSDate+Dogo.h"

@implementation DGArticleCell

#pragma mark - <UITableViewCell>

- (void)prepareForReuse
{
    [super prepareForReuse];
    _lblWebsite.text = nil;
    _lblAuthors.text = nil;
    _lblTitle.text = nil;
    _lblContent.text = nil;
    _imgViewThumb.image = [UIImage imageNamed:@"placeholder"];
}

#pragma mark - Load Article

- (void)loadArticle:(DGArticle *)article
{
    // website
    _lblWebsite.text = article.website;
    // authors + date
    _lblAuthors.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"[by]", nil), article.authors, NSLocalizedString(@"[on]", nil), [article.date dateToStringWithDateFormat:NSLocalizedString(@"[Localized Date Format]", nil) ]];
    // image
    [_imgViewThumb setImageWithURL:[NSURL URLWithString:article.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    // title
    _lblTitle.text = article.title;
    // content (justified)
    NSString *content = article.content;
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;
    paragraphStyles.firstLineHeadIndent = 0.1; // this is necessary to make work
    _lblContent.attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName: paragraphStyles}];
    
    // if article alredy is read change the background color
    self.backgroundColor = (article.read) ? [UIColor backgroundCellReadColor] : [UIColor backgroundCellUnreadColor];
}

@end