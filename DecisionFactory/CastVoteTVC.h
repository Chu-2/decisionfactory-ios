//
//  CastVoteTVC.h
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/27/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CastVoteTVC : UITableViewController <UIAlertViewDelegate>
@property (strong, nonatomic) NSArray *optionList;
@property (nonatomic) NSString *type;
@property (nonatomic) NSInteger voteId;
@end
