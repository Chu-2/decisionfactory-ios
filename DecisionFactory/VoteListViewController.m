//
//  VoteListViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteListViewController.h"
#import "VoteDetailViewController.h"
#import "VoteResultsViewController.h"

@implementation VoteListViewController

- (void)setVoteList:(NSArray *)voteList {
	_voteList = [voteList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		return [[a objectForKey:@"id"] compare:[b objectForKey:@"id"]];
	}];
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
	self.navigationItem.rightBarButtonItem = logoutButton;
	
	[self.refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshList {
	[self.refreshControl beginRefreshing];
	[self viewDidLoad];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteCell" forIndexPath:indexPath];
	NSDictionary *vote = self.voteList[indexPath.row];
	cell.textLabel.text = [vote objectForKey:@"body"];
	cell.detailTextLabel.text = [vote objectForKey:@"type"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowVoteDetail"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *vote = self.voteList[indexPath.row];
		VoteDetailViewController *detailViewController = [segue destinationViewController];
		detailViewController.voteId = [[vote objectForKey:@"id"] intValue];
		detailViewController.voteText = [vote objectForKey:@"body"];
		detailViewController.type = [vote objectForKey:@"type"];
		detailViewController.hasCast = [[vote objectForKey:@"has_cast"] boolValue];
    }
	else if ([[segue identifier] isEqualToString:@"ShowVoteResults"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *vote = self.voteList[indexPath.row];
		VoteResultsViewController *resultsViewController = [segue destinationViewController];
		resultsViewController.voteId = [[vote objectForKey:@"id"] intValue];
		resultsViewController.voteText = [vote objectForKey:@"body"];
		resultsViewController.type = [vote objectForKey:@"type"];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self performSegueWithIdentifier:@"Logout" sender:self];
	}
}

- (IBAction)logoutButtonPressed:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Do you really want to log out?"
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
}

@end
