//
//  XAlertView.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/8.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XAlertView.h"
@interface XAlertView()<UIAlertViewDelegate>
@property (nonatomic, copy) XAlertViewBlock block;
@end
@implementation XAlertView


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle completion:(XAlertViewBlock)completion{
    XAlertView* alert = [[XAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle completion:completion];
    [alert show];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle otherButtonTitle:(NSString *)otherButtonTitle viewController:(UIViewController *)vc completion:(XAlertControllerBlock)completion{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSAssert(NO, @"systemVersion must >= 8.0");
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    [titleText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:AdaptationWidth(17)] range:NSMakeRange(0, title.length)];
    [titleText addAttribute:NSForegroundColorAttributeName value:LabelMainColor range:NSMakeRange(0, title.length)];
    [alert setValue:titleText forKey:@"attributedTitle"];
    // 使用富文本来改变alert的message字体大小和颜色
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message];
    [messageText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)] range:NSMakeRange(0, message.length)];
    [messageText addAttribute:NSForegroundColorAttributeName value:LabelAssistantColor range:NSMakeRange(0, message.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];
    
    if (cancelButtonTitle.length) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 0);
        }];
        [cancleAction setValue:AppMainColor forKey:@"titleTextColor"];
        [alert addAction:cancleAction];
    }
    if (confirmButtonTitle.length) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 1);
        }];
        [confirmAction setValue:AppMainColor forKey:@"titleTextColor"];
        [alert addAction:confirmAction];
    }
    if (otherButtonTitle.length) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 2);
        }];
        [otherAction setValue:AppMainColor forKey:@"titleTextColor"];
        [alert addAction:otherAction];
    }
    [vc presentViewController:alert animated:YES completion:nil];
}
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle viewController:(UIViewController *)vc completion:(XAlertControllerBlock)completion{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSAssert(NO, @"systemVersion must >= 8.0");
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    [titleText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)] range:NSMakeRange(0, title.length)];
    [titleText addAttribute:NSForegroundColorAttributeName value:LabelMainColor range:NSMakeRange(0, title.length)];
    [alert setValue:titleText forKey:@"attributedTitle"];
    // 使用富文本来改变alert的message字体大小和颜色
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message];
    [messageText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)] range:NSMakeRange(0, message.length)];
    [messageText addAttribute:NSForegroundColorAttributeName value:LabelAssistantColor range:NSMakeRange(0, message.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];

    if (cancelButtonTitle.length) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 0);
        }];
        [cancleAction setValue:AppMainColor forKey:@"titleTextColor"];
        [alert addAction:cancleAction];
    }
    if (confirmButtonTitle.length) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 1);
        }];
        [confirmAction setValue:AppMainColor forKey:@"titleTextColor"];
        [alert addAction:confirmAction];
    }
    [vc presentViewController:alert animated:YES completion:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle completion:(XAlertViewBlock)completion{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
    if (self) {
        self.block = completion;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block(alertView, buttonIndex);
    }
}

@end
