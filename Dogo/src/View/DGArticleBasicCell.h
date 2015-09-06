//
//  DGArticleBasicCell.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

/**
 * Cell design used when article doesn't have an image
 */
@interface DGArticleBasicCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblWebsite;
@property (nonatomic, weak) IBOutlet UILabel *lblAuthors;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;

@end