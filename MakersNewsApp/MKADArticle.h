//
//  ArticleParsed.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKADArticle : NSObject

@property (nonatomic, retain) NSNumber *numericIdentifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *publishedDate;
@property (nonatomic, retain) NSString *URLPath;

@end
