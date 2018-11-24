//
//  AboutUsViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "AboutUsViewController.h"
#import "XDeviceHelper.h"
@interface AboutUsViewController ()
{
    UILabel *detail;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"LOGO"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(30);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"V%@",[XDeviceHelper getAppBundleVersion]];
    label.textColor = [UIColor colorWithRed:34/255.0 green:58/255.0 blue:80/255.0 alpha:1];
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(AdaptationWidth(20));
        make.centerX.mas_equalTo(self.view);
    }];
    
    detail = [[UILabel alloc] init];
    detail.numberOfLines = 0;
//    detail.text = @"asfasjqohdcqhcvqhdcqhsdcjhakcjaksdcbgqgcbqiuwgbeqdckqjgwbilkq";
    detail.textColor = [UIColor colorWithRed:34/255.0 green:58/255.0 blue:80/255.0 alpha:1];
    detail.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:detail];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(AdaptationWidth(20));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
    }];
    
    [self prepareDataWithCount:0];
}

- (void)setRequestParams{
    self.cmd = XAboutUsInfo;
    self.dict= [NSDictionary dictionary];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
//
//    detail.text = response.data[@"companyIntro"];
    
    NSMutableAttributedString * artical_main_text = [[NSMutableAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@",response.data[@"companyIntro"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    detail.attributedText = artical_main_text;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
