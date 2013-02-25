//
//  CastVoteViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/17/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "CastVoteViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@interface CastVoteViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickOption;
@property (nonatomic) NSInteger pickedOptionId;
@end

@implementation CastVoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.pickOption.delegate = self;
	self.pickOption.dataSource = self;
	
	NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user_info"] objectForKey:@"user_token"]);
	NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user_info"] objectForKey:@"user_id"]);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.pickedOptionId = [[[self.optionList objectAtIndex:row] objectForKey:@"id"] intValue];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSDictionary *option = [[NSDictionary alloc] initWithDictionary:[self.optionList objectAtIndex:row]];
	return [option objectForKey:@"text"];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.optionList count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (IBAction)submitButtonPressed {
	NSURL *url = [NSURL URLWithString:kMyAppBaseURLString];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
	[httpClient defaultValueForHeader:@"Accept"];
}

@end
