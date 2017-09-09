//
//  MyMessageModel.h
//  VideoApp
//
//  Created by 叶健东 on 17/3/2.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageModel;

@interface MyMessageModel : NSObject


@property(nonatomic,strong)NSArray<MessageModel *> *comments;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *vid;

@end
