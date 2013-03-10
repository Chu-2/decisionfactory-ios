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
}

@end
