//
//  ArticleDetailsViewController.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MKADArticleDetailsViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *publishedDateLabel;
@property (nonatomic, strong) IBOutlet UITextView *bodyTextView;

-(IBAction)shareButtonPressed:(id)sender;

@end
