//
//  SortTagList.m
//
//  Created by Dominic Wroblewski on 02/07/2013.
//  Copyright (c) 2013 Zhao Yiqi. All rights reserved.
//

#import "SortTagList.h"
#import <QuartzCore/QuartzCore.h>

//#define CORNER_RADIUS 4.0f
//#define LABEL_MARGIN 5.0f
//#define BOTTOM_MARGIN 5.0f
//#define FONT_SIZE 13.0f
//#define HORIZONTAL_PADDING 7.0f
//#define VERTICAL_PADDING 4.0f
//#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
//#define TEXT_COLOR [UIColor blackColor]
//#define TEXT_SHADOW_COLOR [UIColor whiteColor]
//#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
//#define BORDER_COLOR [UIColor lightGrayColor].CGColor
//#define BORDER_WIDTH 1.0f
//#define TAG_HEIGHT 14.0f

@implementation SortTagList

@synthesize  textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)dealloc{
    if (textArray!=nil) {
        [textArray removeAllObjects];
        [textArray release];
    }
    if (lblBackgroundColor!=nil) {
        [lblBackgroundColor release];
    }
    [super dealloc];
}
- (void)setTags:(NSArray *)array
{
    if (textArray!=nil) {
        [textArray removeAllObjects];
        [textArray release];
    }
    textArray = [[NSMutableArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}



- (void)display
{
    for (UIButton *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (int i=0;i<textArray.count;i++) {
        NSString *text= [NSString stringWithFormat:@"#%@", textArray[i]];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING;
        textSize.height = TAG_HEIGHT;
//        textSize.height += VERTICAL_PADDING*2;
        UIButton *tagButton = nil;
        if (!gotPreviousFrame) {
            tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            int num=i;
            while (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width||num-1>=(textArray.count-1)) {
                num++;
                if (num<textArray.count) {
                    text= [NSString stringWithFormat:@"#%@", textArray[num]];
                    [textArray exchangeObjectAtIndex:i withObjectAtIndex:num];
                    textSize = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
                    textSize.width += HORIZONTAL_PADDING;
                    textSize.height = TAG_HEIGHT;
//                    textSize.height += VERTICAL_PADDING*2;
                }
                else{
                    break;
                }
            }

            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = CGSizeMake(textSize.width, textSize.height);
            tagButton = [[UIButton alloc] initWithFrame:newRect];
        }
        previousFrame = tagButton.frame;
        gotPreviousFrame = YES;
        [tagButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        if (!lblBackgroundColor) {
//            [tagButton setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8]];
//        } else {
//            [tagButton setBackgroundColor:lblBackgroundColor];
//        }
//        [tagButton setTitleColor:[UIColor colorWithRed:9.0f/255.0f green:124.0f/255.0f blue:37.0f/255.0f alpha:1.0f] forState:UIControlStateNormal ];
        [tagButton setTitleColor:[UIColor colorWithRed:226.0f/255.0f green:73.0f/255.0f blue:18.0f/255.0f alpha:1.0f] forState:UIControlStateNormal ];
        [tagButton setTitle:text forState:UIControlStateNormal];
        [tagButton.titleLabel setTextAlignment:UITextAlignmentCenter];

//        [tagButton.layer setMasksToBounds:YES];
//        [tagButton.layer setCornerRadius:CORNER_RADIUS];
        [tagButton addTarget:self action:@selector(tagButtonDidTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tagButton];
        [tagButton release];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}

- (void)tagButtonDidTaped:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tagDidTaped:)]) {
        NSString *tag = [((UIButton *)sender).titleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [_delegate tagDidTaped:tag];
    }
}
- (CGSize)fittedSize
{
    return sizeFit;
}

@end
