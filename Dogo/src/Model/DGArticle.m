//
//  DGArticle.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticle.h"

#import "NSDate+Dogo.h"
#import "DGUtils.h"

@implementation DGArticle

#pragma mark - Init

//! Use this to init a DGArticle instance using dictionary
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _website = [dict valueForKey:@"website"];
    _title = [dict valueForKey:@"title"];
    _authors = [dict valueForKey:@"authors"];
    _date = [NSDate stringToDate:[dict valueForKey:@"date"]];
    _content = [dict valueForKey:@"content"];
    _image = [DGUtils isNullValue:[dict valueForKey:@"image"]] ? nil : [dict valueForKey:@"image"];
    _read = [DGUtils isNullValue:[dict valueForKey:@"read"]] ? false : [[dict valueForKey:@"read"] boolValue];
    
    return self;
}

@end