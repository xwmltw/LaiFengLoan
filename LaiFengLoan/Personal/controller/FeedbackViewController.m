//
//  FeedbackViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "FeedbackViewController.h"
#import "XPlaceHolderTextView.h"
#import "XAlertView.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
{
    XPlaceHolderTextView *textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    textView = [[XPlaceHolderTextView alloc]init];
    textView.placeholder = @"若有什么问题或建议，就请告诉我们吧";
    textView.placeholderColor = XColorWithRBBA(34, 58, 80, 0.32);
    textView.backgroundColor = XColorWithRGB(245, 245, 250);
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    [self.view addSubview:textView];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = 100;
    [btn setCornerValue:5];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setBackgroundColor:AppMainColor];
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(20));
        make.height.mas_equalTo(AdaptationWidth(218));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self->textView.mas_bottom).offset(AdaptationWidth(45));
        make.height.mas_equalTo(AdaptationWidth(48));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
}
- (void)btnOnClick:(UIButton *)btn{
    if (!textView.text.length) {
        [self setHudWithName:@"请写下您的宝贵意见" Time:2 andType:1];
        return;
    }
    [self prepareDataWithCount:0];
}
- (void)BarbuttonClick:(UIButton *)button{
    [self check:^(id result) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)check:(XBlock)block{
    if (textView.text.length != 0) {
        
        [XAlertView alertWithTitle:@"温馨提示" message:@"您输入的意见尚未保存,确认退出?" cancelButtonTitle:@"取消" confirmButtonTitle:@"退出" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 1:
                    XBlockExec(block,nil);
                    break;
                    
                default:
                    break;
            }
        }];
    }
    XBlockExec(block,nil);
}
- (void)setRequestParams{
    self.cmd = XFeedback;
    self.dict = [NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"feedbackContent", nil];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    [self setHudWithName:response.rspMsg Time:1.5 andType:1];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
