//
//  XPlaceHolderTextView.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/17.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic,assign) NSInteger maxLength;
- (void)textChanged:(NSNotification*)notification;

//编辑中  执行的block代码
@property (nonatomic,strong) XBlock block;
@end
