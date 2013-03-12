//
//  VoteResultsViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/5/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteResultsViewController.h"
#import "MyAPIClient.h"
#import "AFJSONRequestOperation.h"

@interface VoteResultsViewController ()

@end

@implementation VoteResultsViewController

- (void)configureView {
	self.titleLabel.text = self.voteText;
	self.typeLabel.text = [NSString stringWithFormat:@"Type: %@", self.type];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	MyAPIClient *client = [MyAPIClient sharedClient];
	
	NSString *path = [NSString stringWithFormat:@"membervote/%d/results/", self.voteId];
	NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"%@", JSON);
		
		[self configureView];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

@end
