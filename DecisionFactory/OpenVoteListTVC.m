//
//  OpenVoteListTVC.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/6/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "OpenVoteListTVC.h"
#import "AFJSONRequestOperation.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@implementation OpenVoteListTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSURL *url = [NSURL URLWithString:[kMyAppBaseURLString stringByAppendingPathComponent:@"membervote/voteList.json"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSMutableArray *list = [NSMutableArray array];
		for (int i = 0; i < [JSON count]; i++) {
			if (![JSON[i][@"has_cast"] boolValue]) [list addObject:JSON[i]];
		}
		self.voteList = [[NSArray alloc] initWithArray:list];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

@end
