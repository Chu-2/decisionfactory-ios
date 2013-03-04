//
//  VoteDetailViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteDetailViewController.h"
#import "CastVoteTVC.h"
#import "AFJSONRequestOperation.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@interface VoteDetailViewController ()
@property (strong, nonatomic) NSDictionary *detailList;
@property (strong, nonatomic) NSArray *optionList;
@end

@implementation VoteDetailViewController

- (void)configureView
{
	self.voteIdLabel.text = [NSString stringWithFormat:@"Vote id: %d", self.voteId];
	self.algorithmLabel.text = [NSString stringWithFormat:@"Algorithm: %@", [self.detailList objectForKey:@"algorithm"]];
	
	NSString *displayText = @"Options:\n";
	for (NSDictionary *option in self.optionList) {
		displayText = [displayText stringByAppendingFormat:@"%@: %@\n", [option objectForKey:@"id"], [option objectForKey:@"text"]];
	}
	self.optionView.text = displayText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSURL *baseURL = [NSURL URLWithString:kMyAppBaseURLString];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"vote/%d.json", self.voteId] relativeToURL:baseURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		self.detailList = [JSON copy];
		self.optionList = [JSON objectForKey:@"options"];
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
