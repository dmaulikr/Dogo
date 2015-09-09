//
//  NSMutableArray+DGArticle.m
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "NSMutableArray+DGArticle.h"

@implementation NSMutableArray (DGArticle)

//! Find and return the article with same title passed by param
- (DGArticle *)articleByTitle:(NSString *)title
{
    DGArticle *result = nil;
    for (DGArticle *article in self) {
        if ([article.title isEqualToString:title]) {
            result = article;
            break;
        }
    }
    return result;
}

//! Sort array using a field passed by param
- (void)sortByField:(NSString *)field
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:field ascending:YES];
    NSArray *customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [self sortUsingDescriptors:customSortDescription];
}

@end