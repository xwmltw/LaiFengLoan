//
//  QuestsModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestsModel : NSObject
@property (nonatomic ,strong) NSString *answer;
@property (nonatomic ,strong) NSString *question;
@property (nonatomic, assign) BOOL isExpand;

@end
