//
//  VoteDetailViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteDetailViewController.h"
#import "CastVoteTVC.h"
#import "MyAPIClient.h"
#import "AFJSONRequestOperation.h"

@interface VoteDetailViewController ()
@property (strong, nonatomic) NSArray *optionList;
@end

@implementation VoteDetailViewController

- (void)configureView
{
	self.titleLabel.text = self.voteText;
	self.typeLabel.text = [NSString stringWithFormat:@"Type: %@", self.type];
	
	int i = 1;
	NSString *displayText = @"Options:\n";
	for (NSDictionary *option in self.optionList) {
		displayText = [displayText stringByAppendingFormat:@"%d. %@\n", i, option[@"body"]];
		i++;
	}
	self.optionView.text = displayText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	MyAPIClient *client = [MyAPIClient sharedClient];
	
	NSString *path = [NSString stringWithFormat:@"membervote/%d/options/", self.voteId];
	NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		
		NSArray *sortedList = [JSON sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
			return [[a objectForKey:@"id"] compare:[b objectForKey:@"id"]];
		}];
		self.optionList = [[NSArray alloc] initWithArray:sortedList];
		[self configureView];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"CastVote"]) {
		CastVoteTVC *castVote = [segue destinationViewController];
		castVote.optionList = [self.optionList copy];
		castVote.type = self.type;
		castVote.voteId = self.voteId;
	}
}

@end
