//
//  PingLunTableViewCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReMenText;
@interface PingLunTableViewCell : UITableViewCell

@property(nonatomic,copy)UIImageView *iconImage;

@property(nonatomic,copy)UILabel *userLable;

@property(nonatomic,copy)UILabel *pingLunWords;


@property(nonatomic,copy)UIButton *loveButton;

@property(nonatomic,copy)UILabel *loveNumber;

@property(nonatomic,strong)ReMenText *reMen;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;

@property (nonatomic, copy) void (^callBackTextIconTap)(NSString *);

@end
