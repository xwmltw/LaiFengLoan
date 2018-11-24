//
//  XChooseBankView.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XChooseBankView;

@protocol XChooseBankPickerViewDelegate <NSObject>

- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row;

@optional

- (void)userCancelPick:(XChooseBankView *)pickView;

@end

@interface XChooseBankView : UIView

@property (nonatomic, strong) NSArray *chooseThings;

@property (nonatomic, weak) id <XChooseBankPickerViewDelegate> delegate;

- (void)showView;

@end
