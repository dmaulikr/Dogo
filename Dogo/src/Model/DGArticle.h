//
//  DGArticle.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

/**
 * Represents an Article entity in this app
 */
@interface DGArticle : NSObject

#pragma mark - Properties

//! Identify the place where Article came from
@property (nonatomic, strong) NSString *website;
//! Identify the Article title
@property (nonatomic, strong) NSString *title;
//! Identify all Article authors
@property (nonatomic, strong) NSString *authors;
//! Identify the date when Article was published
@property (nonatomic, strong) NSDate *date;
//! Image associated to Article (Optional)
@property (nonatomic, strong) NSString *image;
//! The Article content itself
@property (nonatomic, strong) NSString *content;
//! Informs that Article was read by user
@property (nonatomic) BOOL read;

#pragma mark - Init

//! Use this to init a DGArticle instance using dictionary
- (instancetype)initWithDict:(NSDictionary *)dict;

@end