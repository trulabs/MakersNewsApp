//
//  MainViewController.h
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const MakersNewsURLKey;

@interface MKADMainViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *urlTextField;

-(IBAction)receiveNewsPressed:(id)sender;

@end
