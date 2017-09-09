//
//  ReMenModel.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/13.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//
#import <Foundation/Foundation.h>
@class ReMenUser,ReMenVoice,ReMenText;
@interface ReMenModel : NSObject
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,copy)NSString *backgrund;
@property(nonatomic,copy)NSString *allbackgrund;
@property(nonatomic,copy)NSString *fav_num;
@property(nonatomic,assign)NSInteger is_focus;
@property(nonatomic,assign)NSInteger length;
@property(nonatomic,copy)NSString *play_num;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString *reurl;
@property(nonatomic,copy)NSString *vid;
@property(nonatomic,strong)NSArray<ReMenText *> *comment_t;
@property(nonatomic,strong)ReMenUser *user;
@property(nonatomic,strong)NSArray<ReMenVoice *> *comment_c;
@property (nonatomic, assign) CGFloat cellHeight;

@property(nonatomic,strong)NSMutableArray *backgrunds;
@property(nonatomic,strong)NSMutableArray *allbackgrunds;
@property(nonatomic,strong)NSMutableArray *reurls;

@end
