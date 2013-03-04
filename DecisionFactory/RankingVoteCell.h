//
//  RankingVoteCell.h
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/27/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingVoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionText;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderValueLabel;
@property (nonatomic) NSUInteger row;
@end
