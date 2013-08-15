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

@interface MKADMainViewController ()

@end

@implementation MKADMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
        //Open a new view with the url
        MKADArticlesTableViewController *articleTableViewController = [[MKADArticlesTableViewController alloc] initWithStyle:UITableViewStylePlain URLString:self.urlTextField.text];
        [self.navigationController pushViewController:articleTableViewController animated:YES];
    }
}

@end
