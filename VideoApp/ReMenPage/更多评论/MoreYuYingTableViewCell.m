//
//  MoreYuYingTableViewCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MoreYuYingTableViewCell.h"
#import "ReMenVoice.h"

@implementation MoreYuYingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 26, 26)];
        CALayer *layer = _iconImage.layer;
        _iconImage.image=[UIImage imageNamed:@"icon1.jpeg"];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:13];
        [self addSubview:_iconImage];
        
        _userLable=[UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
//        _userLable.text=@"成龙";
        _userLable.frame=CGRectMake(56, 18, 100, 13);
        [self addSubview:_userLable];
        
        _pingLunWords=[UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:mainPagePingLun numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        _pingLunWords.backgroundColor=yuYingBackView;
        CALayer *layer1 = _pingLunWords.layer;
        
        [layer1 setMasksToBounds:YES];
        [layer1 setCornerRadius:6];
        
        [self addSubview:_pingLunWords];
        
        _voiceTime=[UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
//        _voiceTime.text=@"15'";
        //        _loveNumber.backgroundColor=[UIColor redColor];
        
        [self addSubview:_voiceTime];
        
        
        _loveButton=[[UIButton alloc]init];
        [self addSubview:_loveButton];
        
        [_loveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-KScreenWidth*0.1);
            make.top.equalTo(self.mas_top).offset(18);
            make.size.mas_equalTo(CGSizeMake(22, 18));
        }];
        [_loveButton setImage:[UIImage imageNamed:@"Hot__Normal_like_14x12@2x"] forState:UIControlStateNormal];
        [_loveButton setImage:[UIImage imageNamed:@"Hot_Down_like_14x12@2x"] forState:UIControlStateSelected];
        [_loveButton addTarget:self action:@selector(loveAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        _loveNumber=[UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
//        _loveNumber.text=@"65";
        [self addSubview:_loveNumber];
        [_loveNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_loveButton.mas_right).offset(2);
            make.top.equalTo(self.mas_top).offset(21);
            make.size.mas_equalTo(CGSizeMake(30, 12));
        }];

        
        _lineLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 68, KScreenWidth-20, 2)];
        [self addSubview:_lineLable];
        _lineLable.backgroundColor=VideoMainPageBack;
        
    }
    return self;
}




-(void)setVoiceData:(ReMenVoice *)voiceData{
    
    _voiceData=voiceData;
    
    _loveNumber.text=[NSString stringWithFormat:@"%ld",(long)_voiceData.zan];
    
    _userLable.text=_voiceData.user;
    
    [_iconImage setImageWithURL:[NSURL URLWithString:_voiceData.headpic] placeholderImage:[UIImage imageNamed:@"icon2.jpeg"]];
    
    _voiceTime.text=[NSString stringWithFormat:@"%ld'", (long)_voiceData.clength];
    
    CGFloat singleLength=(KScreenWidth-KScreenWidth*0.355)/60;
    NSInteger totalLength=singleLength*(_voiceData.clength);
    
    _pingLunWords.frame=CGRectMake(56, 46, totalLength, 12);
    
    _voiceTime.frame=CGRectMake(totalLength+60, 44, 36, 12);
    
    if ([_voiceData.is_zan isEqualToString:@"1"]) {
        _loveButton.selected=YES;
    }
 
}

-(void)loveAction{
    if ([_voiceData.is_zan isEqualToString:@"1"]) {
        [UILabel showStats:@"你已点赞" atView:self];
    }else{
        [self dianZan];
        
    }
}



-(void)dianZan{
    
    NSString *channel=@"channel=APP";
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_voiceData.cid];
    
    
    NSString *typeData=[voiceDianZan stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number=[responseObject objectForKey:@"status"];
        
        NSString *status=[NSString stringWithFormat:@"%@",number];
        
        if ([status isEqualToString:@"1"]) {
            _loveButton.selected=YES;
            
            _voiceData.zan++;
            
            _loveNumber.text=[NSString stringWithFormat:@"%ld",(long)_voiceData.zan];
            [UILabel showStats:@"点赞成功" atView:self];
            
            
        }
        if ([status isEqualToString:@"0"]) {
            
        }
        if ([status isEqualToString:@"-1"]) {
            
            [UILabel showStats:@"你已点赞" atView:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - 懒加载


- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}




@end
