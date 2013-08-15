//
//  MainViewController.m
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import "MKADMainViewController.h"

#import "MKADArticlesTableViewController.h"

#import "MKADArticle.h"

NSString * const MakersNewsURLKey = @"MakersNewsURLKey";

@interface MKADMainViewController ()

@end

@implementation MKADMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *makersURL = [[NSUserDefaults standardUserDefaults] objectForKey:MakersNewsURLKey];
	if ([makersURL length])
	{
		[self.urlTextField setText:makersURL];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

-(IBAction)receiveNewsPressed:(id)sender
{
    if ([self.urlTextField.text length] > 0)
    {
		[[NSUserDefaults standardUserDefaults] setObject:[self.urlTextField text] forKey:MakersNewsURLKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
        //Open a new view with the url
        MKADArticlesTableViewController *articleTableViewController = [[MKADArticlesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        articleTableViewController.articlesURLString = self.urlTextField.text;
        [self.navigationController pushViewController:articleTableViewController animated:YES];
    }
}

@end
