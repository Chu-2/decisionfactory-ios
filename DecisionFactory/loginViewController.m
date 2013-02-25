//
//  loginViewController.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "loginViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation loginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)loginButtonPressed {
	NSURL *url = [NSURL URLWithString:kMyAppBaseURLString];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
	[httpClient defaultValueForHeader:@"Accept"];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[self.username text], @"username", [self.password text], @"password", nil];
	
	NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"login.php" parameters:params];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		if ([JSON objectForKey:@"user_token"]) {
			self.resultLabel.text = @"Correct!";
			
			NSMutableDictionary *userInfo = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user_info"] mutableCopy];
			if (!userInfo) userInfo = [[NSMutableDictionary alloc] init];
			[userInfo setObject:[JSON objectForKey:@"user_id"] forKey:@"user_id"];
			[userInfo setObject:[JSON objectForKey:@"user_token"] forKey:@"user_token"];
			[[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user_info"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[self performSegueWithIdentifier:@"Login" sender:self];
		} else if ([JSON objectForKey:@"error_text"]) {
			self.resultLabel.text = [JSON objectForKey:@"error_text"];
		} else {
			NSLog(@"%@", JSON);
		}
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return NO;
}

@end
