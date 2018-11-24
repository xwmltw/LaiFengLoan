//
//  XTextField.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/7.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XTextField.h"

@implementation XTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x += 10; //右边偏10
    return leftRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightRect = [super rightViewRectForBounds:bounds];
    rightRect.origin.x -= 10; //左边偏10
    return rightRect;
}

@end
