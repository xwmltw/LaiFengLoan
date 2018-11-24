//
//  XWMCodeImageView.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "XWMCodeImageView.h"



@implementation XWMCodeImageView
{
    XBaseViewController *_controller;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withController:(XBaseViewController*)controller{
    if (self = [super initWithFrame:frame]) {
 
        self  = [[NSBundle mainBundle]loadNibNamed:@"XWMCodeImage" owner:nil options:nil].firstObject;

        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:10];
        
        //图形验证码
       
//       self.codeImage
        
//        [self addSubview:_codeImage];
        [self.ImageTextField.layer setMasksToBounds:YES];
        [self.ImageTextField.layer setBorderWidth:0.5];
        [self.ImageTextField.layer setBorderColor:XColorWithRGB(255, 255, 255).CGColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"codeImage"]];
        imageView.frame = CGRectMake(0, 0, 28, 28);
        self.ImageTextField.leftView = imageView;
        self.ImageTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
        //点击刷新
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_codeImage setUserInteractionEnabled:YES];
        [_codeImage addGestureRecognizer:tap];
        
    }
     _controller = controller;
    return self;
}
- (void)creatCodeIamge:(NSData *)codeImage{
    
    self.codeImage.image = [UIImage imageWithData:codeImage];
}
- (IBAction)OnBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
//            if(!([self.ImageTextField.text compare:_codeImage.imageCodeStr options:NSCaseInsensitiveSearch|NSNumericSearch] == NSOrderedSame)){
//                [_controller setHudWithName:@"请输入正确的验证码" Time:0.5 andType:3];
//
//                return;
//            }
            XBlockExec(self.block,sender);
        }
            break;
        case 101:
            XBlockExec(self.block,sender);
            break;
            
        default:
            break;
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    XBlockExec(self.tapBlock,nil);
}
@end
