//
//  XCodeImageView.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCodeImageBlock)(NSString *codeStr);

@interface XCodeImageView : UIView
@property (nonatomic, strong) NSString *imageCodeStr;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, copy) XCodeImageBlock bolck;

-(void)freshVerCode;
@end
