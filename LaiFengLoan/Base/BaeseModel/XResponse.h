//
//  XResponse.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XResponse : NSObject
@property (nonatomic, copy) NSString *rspMsg;
@property (nonatomic, copy) NSNumber *rspCode;
@property (nonatomic, copy) NSDictionary *content;
@property (nonatomic, copy) NSDictionary *data;

- (BOOL)success;
@end
