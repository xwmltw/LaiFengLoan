//
//  PayAlertView.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/20.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayAlertBtnDelegate <NSObject>
- (void)payBtnOnClick:(UIButton *)btn;
@end;
@interface PayAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;
@property (nonatomic, weak) id<PayAlertBtnDelegate> delegate;
@end
