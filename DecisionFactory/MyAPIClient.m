//
//  MyAPIClient.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/4/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "MyAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kMyAppBaseURLString = @"http://ix.cs.uoregon.edu/~ruiqi/cis422/mobile/";

@implementation MyAPIClient

+ (MyAPIClient *)sharedClient {
	static MyAPIClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kMyAppBaseURLString]];
	});
	return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (!self) return nil;
	
	[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	self.parameterEncoding = AFJSONParameterEncoding;
	
	return self;
}

@end
