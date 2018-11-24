//
//  AuthorizationHeadView.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "AuthorizationHeadView.h"

@implementation AuthorizationHeadView
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        self  = [[[NSBundle mainBundle]loadNibNamed:@"AuthorizationHead" owner:nil options:nil]lastObject];
//       
//    }
//    return self;
//}
- (void)setHeadImage:(NSNumber *)vc{
    switch (vc.integerValue) {
        case 1:
            [self.liveImage setImage:[UIImage imageNamed:@"authorized"]];
            break;
        case 2:
            [self.liveImage setImage:[UIImage imageNamed:@"认证通过"]];
            [self.telImage setImage:[UIImage imageNamed:@"authorized"]];
            self.line1.backgroundColor = XColorWithRGB(155, 155, 155);
            [self.line1 setImage:nil];
            break;
        case 3:
            [self.liveImage setImage:[UIImage imageNamed:@"认证通过"]];
            [self.telImage setImage:[UIImage imageNamed:@"认证通过"]];
            [self.infoImage setImage:[UIImage imageNamed:@"authorized"]];
            self.line1.backgroundColor = XColorWithRGB(155, 155, 155);
            [self.line1 setImage:nil];
            self.line2.backgroundColor = XColorWithRGB(155, 155, 155);
            [self.line2 setImage:nil];
            break;
        case 4:
            [self.liveImage setImage:[UIImage imageNamed:@"认证通过"]];
            [self.telImage setImage:[UIImage imageNamed:@"认证通过"]];
            [self.infoImage setImage:[UIImage imageNamed:@"认证通过"]];
            [self.phineImage setImage:[UIImage imageNamed:@"authorized"]];
            self.line1.backgroundColor = XColorWithRGB(155, 155, 155);
            [self.line1 setImage:nil];
            self.line2.backgroundColor = XColorWithRGB(155, 155, 155);
            [self.line2 setImage:nil];
            self.line3.backgroundColor = XColorWithRGB(155, 155, 155);
            [self.line3 setImage:nil];
            break;
            
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
