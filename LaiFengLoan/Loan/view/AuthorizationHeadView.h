//
//  AuthorizationHeadView.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *liveImage;
@property (weak, nonatomic) IBOutlet UIImageView *telImage;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UIImageView *phineImage;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line3;

- (void)setHeadImage:(NSNumber *)vc;
@end
