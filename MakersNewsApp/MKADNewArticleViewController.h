//
//  NewArticleViewController.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKADNewArticleViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextView *bodyTextView;


-(IBAction)sendArticlePressed:(id)sender;
-(IBAction)cancelPressed:(id)sender;

@end
