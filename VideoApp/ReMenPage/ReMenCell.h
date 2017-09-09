//
//  ReMenCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReMenModel,ReMenPingLunView;

@interface ReMenCell : UITableViewCell

@property (nonatomic, copy) void (^callBackPinLun)(NSInteger);
@property (nonatomic, copy) void (^callBackPinLunMore)(NSInteger);
@property (nonatomic, copy) void (^callBackUserCenter)(NSInteger);
@property (nonatomic, copy) void (^callBackUserCenterIcon)(NSMutableArray * );
@property (nonatomic, copy) void (^callBackPlay)(NSInteger);
@property (nonatomic,copy)void (^callBackGuanZhu)();
@property (nonatomic, copy) void (^callBackRefresh)();

@property (nonatomic, copy) void (^callBackTapToShowDetail)(NSInteger);

@property(nonatomic,strong)ReMenModel *reMenData;
//@property(nonatomic,strong)NewReMenModel *newReMenData;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;
@property(nonatomic,copy)UIView *headView;
@property(nonatomic,copy)UILabel *lineLabel;

@property(nonatomic,copy)UIButton *iconButton;

@property(nonatomic,copy)UILabel *nameLabel;

@property(nonatomic,copy)UIButton *guanZhuButton;

@property(nonatomic,copy)UILabel *voiceName;

@property(nonatomic,copy)UILabel *voiceTime;

@property(nonatomic,copy)UIImageView *pictures;

@property(nonatomic,copy)UIImageView *playBtn;

@property(nonatomic,copy)UIView *middleView;

@property(nonatomic,copy)UIImageView *seePicture;

@property(nonatomic,copy)UILabel *seeNumber;

@property(nonatomic,copy)UIButton *pingLuButton;

@property(nonatomic,strong)ReMenPingLunView *pinLunView;

@property(nonatomic,assign)NSInteger cellIndex;

@property(nonatomic,assign)NSInteger tagIndex;

@property(nonatomic,copy)NSString *number;


@end
