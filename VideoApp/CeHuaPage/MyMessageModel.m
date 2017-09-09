//
//  MyMessageModel.m
//  VideoApp
//
//  Created by 叶健东 on 17/3/2.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MyMessageModel.h"
#import  "MessageModel.h"

@implementation MyMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comments" : [MessageModel class]};
}

@end
