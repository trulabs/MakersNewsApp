//
//  ArticleTableViewController.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKADArticlesTableViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, retain) NSString *articlesURLString;

@end
