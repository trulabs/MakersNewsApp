//
//  ArticleTableViewController.m
//  MakersNewsApp
//
//  Created by Antonio Martinez on 14/08/2013.
//  Copyright (c) 2013 Truphone. All rights reserved.
//

#import "MKADArticlesTableViewController.h"

#import "MKADArticleDetailsViewController.h"
#import "MKADNewArticleViewController.h"

#import "MKADArticle.h"

@interface MKADArticlesTableViewController ()

@property (nonatomic, retain) NSMutableData *dataReceived;
@property (nonatomic, retain) NSArray *articles;
@property (nonatomic, retain) UIRefreshControl *myRefreshControl;
@property (nonatomic, retain) NSMutableArray *filteredResults;

@end

@implementation MKADArticlesTableViewController

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
    NSURL *URL = [NSURL URLWithString:self.articlesURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark Actions

-(void)openNewArticleView
{
    MKADNewArticleViewController *newArticleViewController = [[MKADNewArticleViewController alloc] initWithNibName:@"MKADNewArticleViewController" bundle:nil];
    [self presentViewController:newArticleViewController animated:YES completion:nil];
}

-(void)refreshControlChanged
{
    [self requestArticles];
}

#pragma mark - Search Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.filteredResults = [[NSMutableArray alloc] init];
    
    //Filter the results
    for (MKADArticle *article in self.articles)
    {
        if ([article.title rangeOfString:searchString].location != NSNotFound)
        {
            [self.filteredResults addObject:article];
        }
    }
    
    return YES;
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
    
    self.dataReceived = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
    if (self.myRefreshControl && [self.myRefreshControl isRefreshing])
    {
        [self.myRefreshControl endRefreshing];
    }
    
    self.dataReceived = nil;
}

#pragma mark - Parsing JSON Methods

- (void)parseReceivedJSON:(NSArray *)jsonReceivedArray
{
    //Parse it
    NSMutableArray *articlesMutableArray = [[NSMutableArray alloc] initWithCapacity:[jsonReceivedArray count]];
    for (NSDictionary *dictionaryFromJSON in jsonReceivedArray)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSLog(@"Article Received: %@", dictionaryFromJSON);
        MKADArticle *article = [[MKADArticle alloc] init];
        article.body            = [dictionaryFromJSON objectForKey:@"body"];
        article.numericIdentifier  = [dictionaryFromJSON objectForKey:@"id"];
        article.title           = [dictionaryFromJSON objectForKey:@"title"];
        article.publishedDate   = [dateFormatter dateFromString:[dictionaryFromJSON objectForKey:@"published"]];
        article.URLPath         = [dictionaryFromJSON objectForKey:@"url"];
        [articlesMutableArray addObject:article];
    }
    
    self.articles = [NSArray arrayWithArray:articlesMutableArray];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredResults count];
    else
        return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MKADArticle *article = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        article = [self.filteredResults objectAtIndex:indexPath.row];
    }
    else
    {
        article = [self.articles objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = article.body;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKADArticleDetailsViewController *detailViewController = [[MKADArticleDetailsViewController alloc] initWithNibName:@"MKADArticleDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    MKADArticle *selectedArticle = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        selectedArticle = [self.filteredResults objectAtIndex:indexPath.row];
    }
    else
    {
        selectedArticle = [self.articles objectAtIndex:indexPath.row];
    }
    
    detailViewController.bodyTextView.text = selectedArticle.body;
    detailViewController.titleLabel.text = selectedArticle.title;
    detailViewController.publishedDateLabel.text = [dateFormatter stringFromDate:selectedArticle.publishedDate];
}

@end
