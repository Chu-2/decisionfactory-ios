//
//  RankVoteCell.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 2/27/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "RankVoteCell.h"

@implementation RankVoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
	NSUInteger sliderValue = round(sender.value);
	self.sliderValueLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
}

@end
