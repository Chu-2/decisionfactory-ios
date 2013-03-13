//
//  VoteResultsView.m
//  DecisionFactory
//
//  Created by RuiQi Yu on 3/12/13.
//  Copyright (c) 2013 TeamNameFactory. All rights reserved.
//

#import "VoteResultsView.h"

@interface VoteResultsView ()
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) NSInteger total;
@end

@implementation VoteResultsView

- (void)setResults:(NSArray *)results {
	_results = results;
	[self setNeedsDisplay];
}

- (NSArray *)colors {
	if (!_colors) {
		_colors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
	}
	return _colors;
}

- (void)setup
{
	self.delegate = self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	[self setup];
    return self;
}

#define CORNER_OFFSET 4.0
#define OPTION_HEIGHT 60.0
#define BAR_HEIGHT 20.0
#define FONT_SIZE 16.0

- (void)drawRect:(CGRect)rect
{
	CGFloat viewHeight = [self.results count] * OPTION_HEIGHT + CORNER_OFFSET * 2;
	if (viewHeight > self.bounds.size.height) {
		self.contentSize = CGSizeMake(self.bounds.size.width, viewHeight);
	}
	
	int total = 0;
	for (int i = 0; i < [self.results count]; i++) {
		total += [[[self.results objectAtIndex:i] objectForKey:@"info"] intValue];
	}
	self.total = total;
	
	for (int i = 0; i < [self.results count]; i++) {
		[self drawOption:CGPointMake(CORNER_OFFSET, CORNER_OFFSET + OPTION_HEIGHT * i) optionIndex:i];
	}
}

- (void)drawOption:(CGPoint)point optionIndex:(NSUInteger)index {
	// draw text
	NSString *body = [NSString stringWithFormat:@"%d. %@  ", index+1, [[self.results objectAtIndex:index] objectForKey:@"body"]];
	
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
	[attributes setObject:font forKey:NSFontAttributeName];
	
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:body attributes:attributes];
	NSAttributedString *winner = [[NSAttributedString alloc] initWithString:@"Winner!" attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor greenColor], NSFontAttributeName: font }];
	
	if ([[[self.results objectAtIndex:index] objectForKey:@"winner"] boolValue]) {
		[text appendAttributedString:winner];
	}
	
	CGRect textBounds;
	textBounds.origin = point;
	textBounds.size = text.size;
	[text drawInRect:textBounds];
	
	// draw bar
	CGFloat percent = [[[self.results objectAtIndex:index] objectForKey:@"info"] floatValue] / self.total;
	CGFloat barWidth = (self.bounds.size.width - 2 * CORNER_OFFSET) * percent;
	
	UIBezierPath *bar = [UIBezierPath bezierPathWithRect:CGRectMake(point.x, point.y + 25, barWidth, BAR_HEIGHT)];
	
	NSUInteger colorIndex = index % [self.colors count];
	[self.colors[colorIndex] setFill];
	[bar fill];
	
	// draw spreading line
	UIBezierPath *line = [[UIBezierPath alloc] init];
	[line moveToPoint:CGPointMake(CORNER_OFFSET, point.y + 54)];
	[line addLineToPoint:CGPointMake(self.bounds.size.width - CORNER_OFFSET, point.y + 54)];
	[[UIColor blackColor] setStroke];
	[line stroke];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self setNeedsDisplay];
}

@end
