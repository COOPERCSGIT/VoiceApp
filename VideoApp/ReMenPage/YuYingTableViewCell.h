//
//  YuYingTableViewCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReMenVoice;

@interface YuYingTableViewCell : UITableViewCell

@property(nonatomic,copy)UIImageView *iconImage;

@property(nonatomic,copy)UILabel *userLable;

@property(nonatomic,copy)UILabel *pingLunWords;


@property(nonatomic,copy)UIButton *loveButton;

@property(nonatomic,copy)UILabel *loveNumber;


@property(nonatomic,copy)UILabel *voiceTime;

@property(nonatomic,copy)ReMenVoice *reMen;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;


@property (nonatomic, copy) void (^callBackVoiceIconTap)(NSString *);

@end
