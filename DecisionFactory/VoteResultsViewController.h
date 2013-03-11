//
//  VoteResultsViewController.h
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/5/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic) NSInteger voteId;
@property (nonatomic) NSString *voteText;
@property (nonatomic) NSString *type;
@end
