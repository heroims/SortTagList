//
//  SortTagList.h
//
//  Created by Zhao Yiqi on 02/07/2013.
//  Copyright (c) 2013 Zhao Yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortTagListDelegate <NSObject>

- (void)tagDidTaped:(NSString *)tag;

@end
@interface SortTagList : UIView
{
    NSMutableArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}
@property (nonatomic, retain) NSMutableArray *textArray;
@property (nonatomic, assign) id <SortTagListDelegate> delegate;
- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
