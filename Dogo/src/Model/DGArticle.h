//
//  DGArticle.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

/**
 * Represents an Article in this app
 */
@interface DGArticle : NSObject

#pragma mark - from web

@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *authors;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *content;

#pragma mark - user action

@property (nonatomic) BOOL read;

#pragma mark - Init

- (instancetype)initWithDic:(NSDictionary *)dict;

@end