//
//  NSObject+Json.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "NSObject+Json.h"

@implementation NSObject (Json)
- (NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        MyLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString*)simpleJsonString {
    NSDictionary* dic = [self mj_keyValues];
    return [dic jsonStringWithPrettyPrint:YES];
}

///字典转JSON
+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

///JSON转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}
@end
