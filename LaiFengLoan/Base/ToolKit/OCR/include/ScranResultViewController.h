//
//  ScranResultViewController.h
//  BanCardScan
//
//  Created by zhangchunlin on 15/5/27.
//  Copyright (c) 2015年 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ViewScanDelegate <NSObject>
- (void)SendBankCardSta:(int)ret;
@end
@interface ScranResultViewController : UIViewController
@property (copy, nonatomic) dispatch_block_t backBlock;
@property (retain, nonatomic) UIImageView *resultImage;
@property (retain, nonatomic) UILabel *resultLabel;
@property (retain, nonatomic) UIButton *BackButton;
@property (retain, nonatomic) UIButton *okButton;
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *info;
- (IBAction)backAction:(id)sender;
- (IBAction)okAction:(id)sender;
-(void) SetInfo:(UIImage *)image Info:(NSString *)info;
@property (nonatomic, assign) id <ViewScanDelegate> ScranViewDelegate;
@end
