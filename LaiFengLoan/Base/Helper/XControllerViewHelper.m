//
//  XControllerViewHelper.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/14.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "XControllerViewHelper.h"
#import <MessageUI/MessageUI.h>

@implementation XControllerViewHelper
XSharedInstance(XControllerViewHelper);

+ (UIView *)getTopView{
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}

+ (UIViewController *)getCurrentRootViewController{
    return [self getCurrentRootViewControllerWithWindowLevel:UIWindowLevelNormal];
}

+ (UIViewController *)getCurrentRootViewControllerWithWindowLevel:(CGFloat)windowLevel{
    UIViewController *result = nil;
    
    result = [self getPresentedViewController];
    if (result) {
        return result;
    }
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != windowLevel) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in windows) {
            //            ELog(@"window level:%f",window.windowLevel);
            if (window.windowLevel == windowLevel) {
                topWindow = window;
            }
        }
    }
    
    UIView *rootView;
    NSArray* subViews = [topWindow subviews];
    if (subViews.count) {
        rootView = [subViews objectAtIndex:0];
    }else{
        rootView = topWindow;
    }
    
    id nextResponder = [rootView nextResponder];
    //    UIWindow* nextResWindow;
    //    if ([nextResponder isKindOfClass:[UIWindow class]]) {
    //        nextResWindow = (UIWindow*)nextResponder;
    //    }
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        //    }else if (nextResWindow != nil && [nextResponder respondsToSelector:@selector(rootViewController)] && nextResWindow.rootViewController != nil){
        //        result = nextResWindow.rootViewController;
    }else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }
    NSAssert(result, @"Could not find a root view controller. ");
    return result;
}

+ (UIViewController *)getPresentedViewController{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = topWindow.rootViewController;
    UIViewController *topVC = nil;
    if (appRootVC.presentedViewController) {
        if (![appRootVC.presentedViewController isKindOfClass:[UIAlertController class]] &&
            ![appRootVC.presentedViewController isKindOfClass:[UIImagePickerController class]] &&
            ![appRootVC.presentedViewController isKindOfClass:[MFMessageComposeViewController class]])
        {
            topVC = appRootVC.presentedViewController;
        }
    }
    return topVC;
}

+ (UIViewController *)getTopViewController{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in windows) {
            //            ELog(@"window level:%f",window.windowLevel);
            if (window.windowLevel == UIWindowLevelNormal) {
                topWindow = window;
            }
        }
    }
    
    UIView *firstView = [topWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    id nextResponder = [secondView nextResponder];
    while (nextResponder) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            break;
        }
        nextResponder = [nextResponder nextResponder];
    }
    
    UINavigationController *tmpNav;
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)nextResponder;
        if ([[tabVC selectedViewController] isKindOfClass:[UINavigationController class]]) {
            tmpNav =(UINavigationController *) [tabVC selectedViewController];
            return [[tmpNav viewControllers] lastObject];
        }else{
            return [tabVC selectedViewController];
        }
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        tmpNav = (UINavigationController *)nextResponder;
        return [[tmpNav viewControllers] lastObject];
    }else{
        return nextResponder;
    }
    return nil;
    
}


+ (void)getTopNavigationCtrl:(XBlock)block{
    UIViewController *vc = [self getTopViewController];
    if (vc && vc.navigationController) {
        XBlockExec(block, vc.navigationController);
    }
}
//
//+ (UIViewController *)getTopVC{
//    UIView *view = [MKUIHelper getTopView];
//    id nextResponse = [view nextResponder];
//    if ([nextResponse isKindOfClass:[UIViewController class]]) {
//        if ([[nextResponse isKindOfClass:]]) {
//
//        }
//    }else{
//        return [self getTopVC];
//    }
//}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
