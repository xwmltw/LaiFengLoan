//
//  XRedrawLabel.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XRedrawLabel.h"

@implementation XRedrawLabel

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.5);
    CGContextSetLineWidth(context, kCGLineJoinRound);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    self.textColor = [UIColor blackColor];
    //蓝色空心字
    [super drawRect:rect];
    CGContextSetTextDrawingMode(context, kCGTextFill);
    self.textColor = [UIColor blackColor];
    //白色实心字
    [super drawRect:rect];
}

@end
