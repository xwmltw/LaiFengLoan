//
//  ExtensionView.h
//  LaiFengLoan
//
//  Created by yanqb on 2019/1/15.
//  Copyright © 2019年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ExtensionBtnDelegate <NSObject>
- (void)extensionBtnOnClick:(UIButton *)btn;
@end;
@interface ExtensionView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *oldDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *poundageLab;
@property (weak, nonatomic) IBOutlet UIButton *goToBtn;
@property (nonatomic, weak) id<ExtensionBtnDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
