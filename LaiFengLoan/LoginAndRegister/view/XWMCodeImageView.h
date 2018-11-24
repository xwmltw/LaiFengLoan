//
//  XWMCodeImageView.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XBaseViewController.h"

@interface XWMCodeImageView : UIView

@property (weak, nonatomic) IBOutlet UITextField *ImageTextField;

@property (copy ,nonatomic) XBlock block;
@property (copy ,nonatomic) XBlock tapBlock;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

- (instancetype)initWithFrame:(CGRect)frame withController:(XBaseViewController*)controller;
- (void)creatCodeIamge:(NSData *)codeImage;
@end
