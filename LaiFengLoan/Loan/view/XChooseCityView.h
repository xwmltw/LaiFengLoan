//
//  XChooseCityView.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XChooseCityView;
@protocol XChooseCityViewDelegate <NSObject>

- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(XChooseCityView *)chooseView;

@end

@interface XChooseCityView : UIView

@property (nonatomic, weak) id <XChooseCityViewDelegate> delegate;
- (void)showView;
@end
