//
//  CastVoteTVC.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/27/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "CastVoteTVC.h"
#import "RankVoteCell.h"

@interface CastVoteTVC ()
@property (strong, nonatomic) NSMutableArray *cellData;
@property (strong, nonatomic) NSMutableDictionary *decision;
@end

@implementation CastVoteTVC

- (NSMutableArray *)cellData {
	if (!_cellData) _cellData = [[NSMutableArray alloc] init];
	return _cellData;
}

- (NSDictionary *)decision {
	if (!_decision) {
		NSMutableDictionary *choices = [[NSMutableDictionary alloc] init];
		_decision = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(self.voteId), @"id", choices, @"choices", nil];
	}
	return _decision;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.optionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *option = [[NSDictionary alloc] initWithDictionary:[self.optionList objectAtIndex:indexPath.row]];
	
	if ([self.algorithm isEqualToString:@"rank"]) {
		RankVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankVoteCell" forIndexPath:indexPath];
		cell.optionText.text = [option objectForKey:@"text"];
		return cell;
	} else if([self.algorithm isEqualToString:@"majority"]) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MajorityVoteCell" forIndexPath:indexPath];
		cell.textLabel.text = [option objectForKey:@"text"];
		return cell;
	} return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self.algorithm isEqualToString:@"majority"]) {
		for (UITableViewCell *cell in [tableView visibleCells]) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		NSDictionary *option = [[NSDictionary alloc] initWithDictionary:[self.optionList objectAtIndex:indexPath.row]];
		[self.decision setObject:[option objectForKey:@"id"] forKey:@"option"];
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	NSLog(@"%i", indexPath.row);
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
}

- (IBAction)submitButtonPressed:(UIBarButtonItem *)sender {
	if ([self.algorithm isEqualToString:@"rank"]) {
		/*NSMutableDictionary *optionWithRankValue = [NSMutableDictionary dictionary];
		
		for (RankVoteCell *cell in [self.tableView visibleCells]) {
			if ([cell.sliderValueLabel.text intValue] != 0) {
				[optionWithRankValue setObject:cell.sliderValueLabel.text forKey:@(cell.optionId)];
			}
		}
		
		if ([optionWithRankValue count] == 0) {
			NSLog(@"You need to rank at least one option.");
		} else if ([optionWithRankValue count] > 5) {
			NSLog(@"You can only rank five or less options.");
		} else {
			NSLog(@"%@", optionWithRankValue);
		}*/
	} else if ([self.algorithm isEqualToString:@"majority"]) {
		if (![self.decision objectForKey:@"option"]) {
			NSLog(@"No option selected!");
		}
	}
}

@end
