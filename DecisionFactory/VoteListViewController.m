//
//  VoteListViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteListViewController.h"
#import "VoteDetailViewController.h"

@implementation VoteListViewController

- (void)setVoteList:(NSArray *)voteList {
	_voteList = voteList;
	[self.tableView reloadData];
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
		detailViewController.voteId = [[vote objectForKey:@"id"] intValue];
		detailViewController.voteText = [vote objectForKey:@"body"];
		detailViewController.type = [vote objectForKey:@"type"];
    }
}

@end
