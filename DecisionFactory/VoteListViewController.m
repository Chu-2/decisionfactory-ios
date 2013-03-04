//
//  VoteListViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteListViewController.h"
#import "VoteDetailViewController.h"
#import "AFJSONRequestOperation.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@implementation VoteListViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSURL *url = [NSURL URLWithString:[kMyAppBaseURLString stringByAppendingPathComponent:@"membervote/voteList.json"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		self.voteList = [JSON copy];
		[self.tableView reloadData];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	[operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.voteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	NSDictionary *vote = [NSDictionary dictionaryWithDictionary:[self.voteList objectAtIndex:indexPath.row]];
	cell.textLabel.text = [vote objectForKey:@"body"];
	cell.detailTextLabel.text = [vote objectForKey:@"type"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowVoteDetail"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *vote = [NSDictionary dictionaryWithDictionary:[self.voteList objectAtIndex:indexPath.row]];
		VoteDetailViewController *detailViewController = [segue destinationViewController];
		detailViewController.title = [vote objectForKey:@"body"];
		detailViewController.voteId = [[vote objectForKey:@"id"] intValue];
    }
}

@end
