//
//  XControllerViewHelper.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/14.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XControllerViewHelper : NSObject
+ (instancetype)sharedInstance;

/** 获取顶层 View*/
+ (UIView *)getTopView;

/** 获取当前 ViewController*/
+ (UIViewController *)getCurrentRootViewController;

/** 根据 windowLevel 获取当前 ViewController*/
+ (UIViewController *)getCurrentRootViewControllerWithWindowLevel:(CGFloat)windowLevel;

/** 获取当前屏幕中 present 出来的 viewcontroller */
+ (UIViewController *)getPresentedViewController;

/** 获取最顶层VC */
+ (UIViewController *)getTopViewController;

/** 获取最顶层VC的navigationCtrl */
+ (void)getTopNavigationCtrl:(XBlock)block;

/** 绘制纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
