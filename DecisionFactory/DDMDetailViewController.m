//
//  DDMDetailViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "DDMDetailViewController.h"
#import "CastVoteViewController.h"
#import "AFJSONRequestOperation.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@interface DDMDetailViewController ()
@property (strong, nonatomic) NSDictionary *detailList;
@property (strong, nonatomic) NSArray *optionList;
@end

@implementation DDMDetailViewController

- (void)configureView
{
	self.voteIdLabel.text = [NSString stringWithFormat:@"Vote id: %i", self.voteId];
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
	NSURL *url = [NSURL URLWithString:[kMyAppBaseURLString stringByAppendingPathComponent:@"voteDetail.json"]];
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
		CastVoteViewController *castVote = [segue destinationViewController];
		castVote.optionList = [self.optionList copy];
		castVote.voteId = self.voteId;
	}
}

@end
