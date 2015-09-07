//
//  DGArticle.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticle.h"

@implementation DGArticle

#pragma mark - Init

- (instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];

    _website = [dict valueForKey:@"website"];
    _title = [dict valueForKey:@"title"];
    _authors = [dict valueForKey:@"authors"];
    _date = [dict valueForKey:@"date"];
    _content = [dict valueForKey:@"content"];

    // TODO: check this...
    NSString *imageURL = [dict valueForKey:@"image"];
    _imageURL = imageURL == (id)[NSNull null] ? nil : imageURL;
    
    return self;
}

@end