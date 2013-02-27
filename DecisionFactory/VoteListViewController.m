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
	NSURL *url = [NSURL URLWithString:[kMyAppBaseURLString stringByAppendingPathComponent:@"voteList.json"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		self.voteList = [JSON objectForKey:@"votes"];
		[self.tableView reloadData];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	[operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

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
	NSDictionary *vote = [[NSDictionary alloc] initWithDictionary:[self.voteList objectAtIndex:indexPath.row]];
	cell.textLabel.text = [vote objectForKey:@"vote"];
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowVoteDetail"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *vote = [[NSDictionary alloc] initWithDictionary:[self.voteList objectAtIndex:indexPath.row]];
		VoteDetailViewController *detailViewController = [segue destinationViewController];
		detailViewController.title = [vote objectForKey:@"vote"];
		detailViewController.voteId = [[vote objectForKey:@"id"] intValue];
    }
}

@end
