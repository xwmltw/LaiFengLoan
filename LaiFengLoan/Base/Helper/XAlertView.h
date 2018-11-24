//
//  XAlertView.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/8.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XAlertViewBlock)(UIAlertView* alertView, NSInteger buttonIndex);
typedef void(^XAlertControllerBlock)(UIAlertAction *action, NSInteger buttonIndex);

@interface XAlertView : UIAlertView
/*!< UIAlertView*/
/**
 UIAlertView

 @param title <#title description#>
 @param message <#message description#>
 @param cancelButtonTitle <#cancelButtonTitle description#>
 @param confirmButtonTitle <#confirmButtonTitle description#>
 @param completion <#completion description#>
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle
            completion:(XAlertViewBlock)completion;
/*!< UIAlertController*/

/**
 UIAlertController

 @param title <#title description#>
 @param message <#message description#>
 @param cancelButtonTitle <#cancelButtonTitle description#>
 @param confirmButtonTitle <#confirmButtonTitle description#>
 @param vc <#vc description#>
 @param completion <#completion description#>
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle
        viewController:(UIViewController *)vc
            completion:(XAlertControllerBlock)completion;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle
      otherButtonTitle:(NSString *)otherButtonTitle
        viewController:(UIViewController *)vc
            completion:(XAlertControllerBlock)completion;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle
                   completion:(XAlertViewBlock)completion;
@end
