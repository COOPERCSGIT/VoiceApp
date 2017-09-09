//
//  MoreYuYingTableViewCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReMenVoice;

@interface MoreYuYingTableViewCell : UITableViewCell

@property(nonatomic,copy)UIImageView *iconImage;

@property(nonatomic,copy)UILabel *userLable;

@property(nonatomic,copy)UILabel *pingLunWords;


@property(nonatomic,copy)UIButton *loveButton;

@property(nonatomic,copy)UILabel *loveNumber;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;
@property(nonatomic,copy)UILabel *lineLable;

@property(nonatomic,copy)UILabel *voiceTime;

@property(nonatomic,strong)ReMenVoice *voiceData;

@end
