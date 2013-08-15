//
//  ArticleDetailsViewController.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKADArticleDetailsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *publishedDateLabel;
@property (nonatomic, retain) IBOutlet UITextView *bodyTextView;

@end
