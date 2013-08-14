//
//  ArticleTableViewController.m
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import "ArticlesTableViewController.h"

#import "ArticleDetailsViewController.h"
#import "NewArticleViewController.h"

#import "Article.h"

@interface ArticlesTableViewController ()

@property (nonatomic, retain) NSMutableData *dataReceived;
@property (nonatomic, retain) NSArray *articlesArray;
@property (nonatomic, retain) UIRefreshControl *myRefreshControl;

@end

@implementation ArticlesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Articles";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add the refrehsing control
    self.myRefreshControl = [[UIRefreshControl alloc] init];
    [self.myRefreshControl addTarget:self action:@selector(refreshControlChanged) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.myRefreshControl;
    
    //Add new article button
    UIBarButtonItem *newArticleButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(openNewArticleView)];
    self.navigationItem.rightBarButtonItem = newArticleButton;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestArticles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestArticles
{
    //Start url request
    NSURL *url = [NSURL URLWithString:self.articlesURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark Actions

-(void)openNewArticleView
{
    NewArticleViewController *newArticleViewController = [[NewArticleViewController alloc] initWithNibName:@"NewArticleViewController" bundle:nil];
    [self.navigationController pushViewController:newArticleViewController animated:YES];
}

-(void)refreshControlChanged
{
    [self requestArticles];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.dataReceived = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataReceived appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Get the JSON array
    NSError *error = nil;
    NSArray *jsonReceivedArray = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:0 error:&error];
    
    [self parseReceivedJSON:jsonReceivedArray];
    
    if (self.myRefreshControl && [self.myRefreshControl isRefreshing])
    {
        [self.myRefreshControl endRefreshing];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
    if (self.myRefreshControl && [self.myRefreshControl isRefreshing])
    {
        [self.myRefreshControl endRefreshing];
    }
}

#pragma mark - Parsing JSON Methods

- (void)parseReceivedJSON:(NSArray *)jsonReceivedArray
{
    //Parse it
    NSMutableArray *articlesMutableArray = [[NSMutableArray alloc] initWithCapacity:[jsonReceivedArray count]];
    for (NSDictionary *dictionaryFromJSON in jsonReceivedArray)
    {
        NSLog(@"Article Received: %@", dictionaryFromJSON);
        Article *article = [[Article alloc] init];
        article.body            = [dictionaryFromJSON objectForKey:@"body"];
        article.idArticle       = [dictionaryFromJSON objectForKey:@"id"];
        article.title           = [dictionaryFromJSON objectForKey:@"title"];
        article.publishedDate   = [dictionaryFromJSON objectForKey:@"published"];
        article.url             = [dictionaryFromJSON objectForKey:@"url"];
        [articlesMutableArray addObject:article];
    }
    
    self.articlesArray = [NSArray arrayWithArray:articlesMutableArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.articlesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Article *selectedArticle = [self.articlesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = selectedArticle.title;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleDetailsViewController *detailViewController = [[ArticleDetailsViewController alloc] initWithNibName:@"ArticleDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    Article *selectedArticle = [self.articlesArray objectAtIndex:indexPath.row];
    detailViewController.bodyView.text = selectedArticle.body;
    detailViewController.titleLabel.text = selectedArticle.title;
    detailViewController.publishedDateLabel.text = selectedArticle.publishedDate;
}

@end
