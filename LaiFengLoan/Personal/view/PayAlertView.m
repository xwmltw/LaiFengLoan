//
//  PayAlertView.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/20.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "PayAlertView.h"

@implementation PayAlertView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PayAlertView" owner:nil options:nil].firstObject;
        
    }
    return self;
}
- (IBAction)btnOnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payBtnOnClick:)]) {
        [self.delegate payBtnOnClick:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
