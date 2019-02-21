//
//  ImmediateView.h
//  LaiFengLoan
//
//  Created by yanqb on 2019/1/15.
//  Copyright © 2019年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTextField.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ImmediateViewBtnDelegate <NSObject>
- (void)ImmediateViewBtnOnClick:(UIButton *)btn;
@end;
@interface ImmediateView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (nonatomic ,strong) XTextField *partMoney;
@property (weak, nonatomic) IBOutlet UIButton *partBtn;
@property (nonatomic ,copy) NSNumber *payMoney;
@property (nonatomic, weak) id<ImmediateViewBtnDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
