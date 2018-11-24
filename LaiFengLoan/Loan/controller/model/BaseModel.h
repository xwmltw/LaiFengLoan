//
//  BaseModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/8.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic, copy) NSString *companyAddr;
@property (nonatomic, copy) NSString *companyCity;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyPayDay;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyProvince;
@property (nonatomic, copy) NSString *companyTown;
@property (nonatomic, copy) NSString *homeAddr;
@property (nonatomic, copy) NSString *homeCity;
@property (nonatomic, copy) NSString *homeProvince;
@property (nonatomic, copy) NSString *homeTown;
@property (nonatomic, copy) NSString *isMarry;
@end
//description:
//提交用户基本信息数据
//
//companyAddr*    string
//公司地址
//
//companyCity*    string
//公司所在城市
//
//companyName*    string
//公司名称
//
//companyPayDay*    string
//公司发薪日
//
//companyPhone*    string
//公司电话
//
//companyProvince*    string
//公司所在省份
//
//companyTown*    string
//公司所在区县
//
//homeAddr*    string
//用户家庭地址 例： xxxxxxx
//
//homeCity*    string
//用户所在城市 例： 厦门市
//
//homeProvince*    string
//用户所在省份 例： 福建省
//
//homeTown*    string
//用户所在区县 例： 同安区
//
//isMarry*    string
//婚姻情况: 未婚，已婚， 其他
