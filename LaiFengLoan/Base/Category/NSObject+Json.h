//
//  NSObject+Json.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)
- (NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint;

- (NSString*)simpleJsonString;

///字典转JSON
+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic;

///JSON转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
