//
//  NSMutableArray+DGArticle.h
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticle.h"

@interface NSMutableArray (DGArticle)

//! Find and return the article with same title passed by param
- (DGArticle *)articleByTitle:(NSString *)title;

//! Sort array using a field passed by param
- (void)sortByField:(NSString *)field;

@end