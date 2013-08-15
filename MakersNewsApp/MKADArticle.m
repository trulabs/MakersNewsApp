//
//  ArticleParsed.m
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import "MKADArticle.h"

@implementation MKADArticle

- (void)dealloc{
    self.numericIdentifier = nil;
    self.title = nil;
    self.body = nil;
    self.publishedDate = nil;
    self.URLPath = nil;
}

@end
