//
//  DGArticleDetailViewController.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticle.h"
#import "DGLabel.h"

@interface DGArticleDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *lblWebsite;
@property (nonatomic, weak) IBOutlet UILabel *lblAuthors;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imgViewThumb;
@property (nonatomic, weak) IBOutlet DGLabel *lblContent;

@property (nonatomic, weak) DGArticle *article;

@end