//
//  CastVoteViewController.h
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/17/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CastVoteViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSArray *optionList;
@property (nonatomic) NSInteger voteId;
@end
