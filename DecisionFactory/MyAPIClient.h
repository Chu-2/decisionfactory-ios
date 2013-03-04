//
//  MyAPIClient.h
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/4/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "AFHTTPClient.h"

@interface MyAPIClient : AFHTTPClient

+ (MyAPIClient *)sharedClient;

@end
