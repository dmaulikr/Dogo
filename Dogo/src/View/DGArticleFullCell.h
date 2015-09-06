//
//  DGArticleFullCell.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleBasicCell.h"

/**
 * Cell design used when article is full with all basic data and image
 */
@interface DGArticleFullCell : DGArticleBasicCell

@property (nonatomic, weak) IBOutlet UIImageView *imgViewThumb;

@end