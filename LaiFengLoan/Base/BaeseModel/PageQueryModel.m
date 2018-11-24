//
//  PageQueryModel.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "PageQueryModel.h"

@implementation PageQueryModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.pageSize = @10;
        self.page = @1;
    }
    return self;
}
@end
