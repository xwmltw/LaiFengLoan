//
//  XResponse.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XResponse.h"

@implementation XResponse
- (BOOL)success{
    return self.rspCode.intValue == 0;
}
@end
