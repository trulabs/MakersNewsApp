//
//  ArticleParsed.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKADArticle : NSObject

@property (nonatomic, strong) NSNumber *numericIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *publishedDate;
@property (nonatomic, strong) NSString *URLPath;

@end
