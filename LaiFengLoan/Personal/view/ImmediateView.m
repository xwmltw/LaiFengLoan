//
//  ImmediateView.m
//  LaiFengLoan
//
//  Created by yanqb on 2019/1/15.
//  Copyright © 2019年 xwm. All rights reserved.
//

#import "ImmediateView.h"
#import "XAlertView.h"
@implementation ImmediateView
{
    BOOL isHaveDian;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"Immediate" owner:nil options:nil].firstObject;
        [self.bgView setCornerValue:8];
   
        [self.surePayBtn setCornerValue:12];
        
        self.partMoney = [[XTextField alloc]init];
        self.partMoney.clearButtonMode = UITextFieldViewModeAlways;
        self.partMoney.borderStyle = UITextBorderStyleNone;
        self.partMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入金额" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
        [self.partMoney setTextColor:XColorWithRBBA(22, 28, 42, 1)];
        self.partMoney.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
//        [self.partMoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.partMoney.delegate = self;
        self.partMoney.keyboardType = UIKeyboardTypeASCIICapable;
        [self.partMoney setCornerValue:AdaptationWidth(4)];
        [self.partMoney setBorderWidth:1 andColor:LineColor];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, AdaptationWidth(16), AdaptationWidth(22))];
        lab.text = @"￥";
        self.partMoney.leftView  = lab;
        self.partMoney.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.partMoney];
        [self.partMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.partBtn);
            make.right.mas_equalTo(self.bgView).offset(-30);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
        
        self.allBtn.selected = YES;
    }
    return self;
}
- (IBAction)btnOnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ImmediateViewBtnOnClick:)]) {
        [self.delegate ImmediateViewBtnOnClick:sender];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.allBtn.selected = NO;
    self.partBtn.selected = YES;
//    NSLog(@"开始输入");
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    double newMoney = [textField.text doubleValue];
    double oldMoney = [self.payMoney doubleValue];
    if (newMoney == 0 || newMoney > oldMoney) {
        [XAlertView alertWithTitle:@"错误提示" message:[NSString stringWithFormat:@"部分还款金额必须为【0~%@】，请重新输入",self.payMoney.description] cancelButtonTitle:nil confirmButtonTitle:@"知道了"
                        completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            
                        }];
        textField.text = @"";
    }
//    NSLog(@"结束输入");
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];

        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [XAlertView alertWithTitle:@"错误提示" message:[NSString stringWithFormat:@"部分还款金额必须为【0~%@】，请重新输入",self.payMoney.description] cancelButtonTitle:nil confirmButtonTitle:@"知道了"
                            completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                
                            }];
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            [XAlertView alertWithTitle:@"错误提示" message:[NSString stringWithFormat:@"部分还款金额必须为【0~%@】，请重新输入",self.payMoney.description] cancelButtonTitle:nil confirmButtonTitle:@"知道了"
                            completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                
                            }];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [XAlertView alertWithTitle:@"错误提示" message:[NSString stringWithFormat:@"部分还款金额必须为【0~%@】，请重新输入",self.payMoney.description] cancelButtonTitle:nil confirmButtonTitle:@"知道了"
                                    completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        
                                    }];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    [XAlertView alertWithTitle:@"错误提示" message:[NSString stringWithFormat:@"部分还款金额必须为【0~%@】，请重新输入",self.payMoney.description] cancelButtonTitle:nil confirmButtonTitle:@"知道了"
                                    completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        
                                    }];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [XAlertView alertWithTitle:@"错误提示" message:[NSString stringWithFormat:@"部分还款金额小数点后最多能输入两位，请重新输入",self.payMoney.description] cancelButtonTitle:nil confirmButtonTitle:@"知道了"
                                    completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        
                                    }];
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
}
@end
