//
//  XCountDownButton.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCountDownButton;
typedef NSString* (^CountDownChanging)(XCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(XCountDownButton *countDownButton,NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(XCountDownButton *countDownButton,NSInteger tag);

@interface XCountDownButton : UIButton

@property(nonatomic,strong) id userInfo;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;

@end
