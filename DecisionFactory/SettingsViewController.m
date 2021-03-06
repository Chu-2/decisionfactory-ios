//
//  SettingsViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/10/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "SettingsViewController.h"
 
@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.settingCell.textLabel.text = @"Push Notification";
	UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
	switchObj.on = YES;
	[switchObj addTarget:self action:@selector(switchValueChanged:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
	self.settingCell.accessoryView = switchObj;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self performSegueWithIdentifier:@"Logout" sender:self];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0 && indexPath.section == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Do you really want to log out?"
													   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[alert show];
	}
	
	if (indexPath.row == 0 && indexPath.section == 1) {
		NSURL *url = [NSURL URLWithString:@"http://cis422ddm.herokuapp.com/"];
		
		if (![[UIApplication sharedApplication] openURL:url]) {
			NSLog(@"Failed to open url: %@", [url description]);
		}
	}
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
	[[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"PushNotification"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
