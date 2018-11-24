//
//  contactModel.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/8.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
- (instancetype)init{
    if (self = [super init]) {
        [ContactModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"contactList":[ImportantContactsInfo class],
                     @"phoneBookList":[PhoneBookInfo class],
                     };
        }];
    }
    return self;
}
@end

@implementation ImportantContactsInfo

@end
@implementation PhoneBookInfo

@end
