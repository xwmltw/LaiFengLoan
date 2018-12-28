//
//  LzyUISlider.m
//  LzyUISlider
//
//  Created by 刘籽繇 on 2017/12/26.
//  Copyright © 2017年 刘籽繇. All rights reserved.
//

#import "LzyUISlider.h"

// 屏幕宽屏幕高 屏幕bounds
#define LZYSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define LZYSCREENHEIGH  [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)

// 适配
#define LZYNEWWIDTH                     [UIScreen mainScreen].bounds.size.width/375
#define LZYNEWHEIGHT                    [UIScreen mainScreen].bounds.size.height/667

#define LZYScale_WIDTH(a)               (a*LZYNEWWIDTH)
#define LZYScale_HEIGHT(a)              (a*LZYNEWHEIGHT)
@implementation LzyUISlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0,LZYScale_WIDTH(302), LZYScale_HEIGHT(10));
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 12 ;
    rect.size.width = rect.size.width + 20;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}
@end
