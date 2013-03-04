//
//  CastVoteTVC.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/27/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "CastVoteTVC.h"
#import "RankingVoteCell.h"
#import "MyAPIClient.h"
#import "AFJSONRequestOperation.h"

@interface CastVoteTVC ()
@property (strong, nonatomic) NSMutableArray *cellData;
@property (strong, nonatomic) NSMutableDictionary *decision;
@end

@implementation CastVoteTVC

#define PLURALITY_VOTE @"plurality"
#define RANKING_VOTE @"ranking"

- (NSMutableArray *)cellData {
	if (!_cellData) {
		_cellData = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < self.optionList.count; i++) {
			if ([self.type isEqualToString:RANKING_VOTE]) {
				[_cellData insertObject:@(0) atIndex:i];
			} else if ([self.type isEqualToString:PLURALITY_VOTE]) {
				[_cellData insertObject:@(NO) atIndex:i];
			}
		}
	}
	return _cellData;
}

- (NSDictionary *)decision {
	if (!_decision) _decision = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(self.voteId), @"id", nil];
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
	NSDictionary *option = [NSDictionary dictionaryWithDictionary:[self.optionList objectAtIndex:indexPath.row]];
	
	if ([self.type isEqualToString:RANKING_VOTE]) {
		RankingVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingVoteCell" forIndexPath:indexPath];
		cell.optionText.text = [option objectForKey:@"body"];
		
		float sliderValue = [[self.cellData objectAtIndex:indexPath.row] floatValue];
		cell.slider.value = sliderValue;
		cell.sliderValueLabel.text = [NSString stringWithFormat:@"%d", (int)round(sliderValue)];
		
		cell.row = indexPath.row;
		return cell;
	} else if([self.type isEqualToString:PLURALITY_VOTE]) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PluralityVoteCell" forIndexPath:indexPath];
		cell.textLabel.text = [option objectForKey:@"body"];
		
		BOOL checked = [[self.cellData objectAtIndex:indexPath.row] boolValue];
		cell.accessoryType = (checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
		
		return cell;
	} return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self.type isEqualToString:PLURALITY_VOTE]) {
		for (UITableViewCell *cell in [tableView visibleCells]) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		if ([self.cellData indexOfObject:@(YES)] != NSNotFound) {
			[self.cellData replaceObjectAtIndex:[self.cellData indexOfObject:@(YES)] withObject:@(NO)];
		}
		[self.cellData replaceObjectAtIndex:indexPath.row withObject:@(YES)];
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (BOOL)checkRankingValues:(NSMutableArray *)rankingValues {
	NSMutableArray *check = [NSMutableArray arrayWithObjects:@(NO), @(NO), @(NO), @(NO), @(NO), nil];
	
	for (int i = 0; i < [rankingValues count]; i++) {
		NSUInteger rankingValue = [[rankingValues objectAtIndex:i] intValue];
		
		if (rankingValue != 0) {
			if ([[check objectAtIndex:(rankingValue - 1)] boolValue]) {
				return NO;
			} else [check replaceObjectAtIndex:(rankingValue - 1) withObject:@(YES)];
		}
	}
	
	return YES;
}

- (void)postDecision {
	[self.decision setObject:[[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user_info"] objectForKey:@"user_token"] forKey:@"token"];
	
	/*// NSDictionary to JSON using Apple's JSON parser
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.decision options:NSJSONWritingPrettyPrinted error:&error];
	
	if (!jsonData) {
		NSLog(@"%@", error);
	} else {
		NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		NSLog(@"%@", jsonString);
	}*/
	
	MyAPIClient *client = [MyAPIClient sharedClient];
	
	NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:self.decision];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"%@", response);
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		//[self postDecision];
	}
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
	RankingVoteCell *cell = (RankingVoteCell *)[[sender superview] superview];
	[self.cellData replaceObjectAtIndex:cell.row withObject:@(sender.value)];
}

- (IBAction)submitButtonPressed:(UIBarButtonItem *)sender {
	NSMutableArray *choices = [NSMutableArray array];
	UIAlertView *alert;
	
	if ([self.type isEqualToString:RANKING_VOTE]) {
		NSMutableArray *rankingValues = [NSMutableArray array];
		
		int count = 0;
		for (int i = 0; i < [self.cellData count]; i++) {
			NSUInteger rankingValue = round([[self.cellData objectAtIndex:i] floatValue]);
			
			[rankingValues insertObject:@(rankingValue) atIndex:i];
			
			if (rankingValue != 0) count++;
		}
		
		if (count == 0) {
			alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You need to rank at least one option."
											  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		} else if (count > 5) {
			alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can only rank five or less options."
											  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		} else {
			if ([self checkRankingValues:rankingValues]) {
				for (int i = 0; i < [rankingValues count]; i++) {
					NSUInteger value = [[rankingValues objectAtIndex:i] intValue];
					if (value != 0) {
						NSMutableDictionary *choice = [NSMutableDictionary dictionary];
						NSDictionary *option = [NSDictionary dictionaryWithDictionary:[self.optionList objectAtIndex:i]];
						
						[choice setObject:[option objectForKey:@"id"] forKey:@"option_id"];
						[choice setObject:@(value) forKey:@"value"];
						
						[choices addObject:choice];
					}
				}
				
				[self.decision setObject:choices forKey:@"choices"];
				
				alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Do you want to submit your decision?"
												  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
				[alert show];
			}
			else {
				alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please rank the options from 1 to 5 without duplicates."
												  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];
			}
		}
	} else if ([self.type isEqualToString:PLURALITY_VOTE]) {
		NSUInteger row = [self.cellData indexOfObject:@(YES)];
		if (row != NSNotFound) {
			NSMutableDictionary *choice = [NSMutableDictionary dictionary];
			NSDictionary *option = [NSDictionary dictionaryWithDictionary:[self.optionList objectAtIndex:row]];
			
			[choice setObject:[option objectForKey:@"id"] forKey:@"option_id"];
			[choice setObject:@(1) forKey:@"value"];
			
			[choices addObject:choice];
			
			[self.decision setObject:choices forKey:@"choices"];
			
			alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Do you want to submit your decision?"
											  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[alert show];
		} else {
			alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Nothing is selected."
											  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		}
	}
}

@end
