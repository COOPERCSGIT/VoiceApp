//
//  ReMenVoice.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/14.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReMenVoice : NSObject

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *user;
@property(nonatomic,assign)NSInteger zan;

@property(nonatomic,assign)NSInteger clength;
@property(nonatomic,copy)NSString *headpic;

@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *is_zan;
@property(nonatomic,copy)NSString *uid;

@end
