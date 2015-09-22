//
//  DGArticleDAO.h
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticle.h"

/*
 * Article Data Access Object responsible for manage all articles from database (SQLite) and exec CRUD operations
 */
@interface DGArticleDAO : NSObject

#pragma mark - Load

//! Fetch articles from database (SQLite)
- (NSArray *)fetchData;

#pragma mark - Insert / Update / Delete

//! Insert one DGArticle instance into database
- (void)insertArticle:(DGArticle *)article;

//! Insert a list of DGArticle instances into database
- (void)insertArticles:(NSArray *)articles;

//! Update one DGArticle instance
- (void)updateArticle:(DGArticle *)article;

//! Clear DGArticle table
- (void)deleteAllArticles;

@end