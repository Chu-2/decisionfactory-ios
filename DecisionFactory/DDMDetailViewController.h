//
//  DDMDetailViewController.h
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/16/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *voteIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *algorithmLabel;
@property (weak, nonatomic) IBOutlet UITextView *optionView;
@property (nonatomic) NSInteger voteId;
@end
