//
//  LoginViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "LoginViewController.h"
#import "MyAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

static NSString * const baseURLString = @"http://cis422ddm.herokuapp.com/api-root/";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.username.delegate = self;
	self.password.delegate = self;
	
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicatorView.hidesWhenStopped = YES;
	self.activityIndicatorView.center = self.view.center;
	[self.view addSubview:self.activityIndicatorView];
}

- (void)sendDeviceToken {
	MyAPIClient *client = [MyAPIClient sharedClient];
	
	NSDictionary *params = @{ @"deviceToken": [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"] };
	NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"device_token/" parameters:params];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		// NSLog(@"success: %@", operation.responseString);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"error: %@", error);
	}];
	
	[operation start];
}

// UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)loginButtonPressed {
	[self.activityIndicatorView startAnimating];
	
	// Dismiss the keyboard
	if ([self.username isFirstResponder]) [self.username resignFirstResponder];
	else if ([self.password isFirstResponder]) [self.password resignFirstResponder];
	
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
	
	NSDictionary *params = @{ @"username": [self.username text], @"password": [self.password text] };
	
	NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"api-token-auth/" parameters:params];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[self.activityIndicatorView stopAnimating];
		if ([JSON objectForKey:@"token"]) {
			self.resultLabel.text = @"Login successful!";
			
			NSString *token = [NSString stringWithFormat:@"token %@", [JSON objectForKey:@"token"]];
			[[MyAPIClient sharedClient] setDefaultHeader:@"Authorization" value:token];
			
			NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];
			if (deviceToken) [self sendDeviceToken];
			else {
				[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"DeviceToken"];
				[self sendDeviceToken];
			}
			
			[self performSegueWithIdentifier:@"Login" sender:self];
		} else if ([JSON objectForKey:@"message"]) {
			self.resultLabel.text = [JSON objectForKey:@"message"];
		} else {
			NSLog(@"%@", JSON);
		}
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[self.activityIndicatorView stopAnimating];
		if ([JSON objectForKey:@"username"]) self.resultLabel.text = @"Username is required.";
		else if ([JSON objectForKey:@"password"]) self.resultLabel.text = @"Password is required.";
		else if ([JSON objectForKey:@"non_field_errors"]) self.resultLabel.text = @"Username or password is incorrect.";
		else self.resultLabel.text = @"Connection field.";
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

@end
