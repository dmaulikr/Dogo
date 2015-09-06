//
//  DGArticleCell.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticle.h"

@interface DGArticleCell : UITableViewCell

#pragma mark - Properties

@property (nonatomic, weak) IBOutlet UILabel *lblWebsite;
@property (nonatomic, weak) IBOutlet UILabel *lblAuthors;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;
@property (nonatomic, weak) IBOutlet UIImageView *imgViewThumb;

#pragma mark - Methods

//! Load all article info into cell fields
- (void)loadArticle:(DGArticle *)article;

@end