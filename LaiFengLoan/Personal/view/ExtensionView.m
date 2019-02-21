//
//  ExtensionView.m
//  LaiFengLoan
//
//  Created by yanqb on 2019/1/15.
//  Copyright © 2019年 xwm. All rights reserved.
//

#import "ExtensionView.h"

@implementation ExtensionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ExtensionView" owner:nil options:nil].firstObject;
        [self.bgView setCornerValue:8];
        
        [self.oldDateBtn setBorderWidth:0.5 andColor:XColorWithRBBA(34, 58, 80, 0.5)];
        [self.oldDateBtn setCornerValue:4];
        [self.oldDateBtn.titleLabel setNumberOfLines:0];
        [self.oldDateBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.nowDateBtn setCornerValue:4];
        [self.nowDateBtn.titleLabel setNumberOfLines:0];
        [self.nowDateBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.goToBtn setCornerValue:12];
    }
    return self;
}
- (IBAction)btnOnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(extensionBtnOnClick:)]) {
        [self.delegate extensionBtnOnClick:sender];
    }
}

@end
