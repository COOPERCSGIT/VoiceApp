//
//  MorePingLunTableViewCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MorePingLunTableViewCell.h"
#import "ReMenText.h"
#import "MessageModel.h"


@implementation MorePingLunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 26, 26)];
        CALayer *layer = _iconImage.layer;
      
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:13];
        [self addSubview:_iconImage];
        
        _userLable=[UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
//        _userLable.text=@"刘德华";
        _userLable.frame=CGRectMake(56, 18, 100, 13);
        [self addSubview:_userLable];
        
        _pingLunWords=[UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:mainPagePingLun numberOfLines:0 textAlignment:NSTextAlignmentLeft];
//        _pingLunWords.text=@"6666666666666,不错的呢";
        _pingLunWords.frame=CGRectMake(56, 46, self.frame.size.width-72, 15);
        [self addSubview:_pingLunWords];
        
    

        
        
        _lineLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 68, KScreenWidth-20, 2)];
        [self addSubview:_lineLable];
        _lineLable.backgroundColor=VideoMainPageBack;
        
        
    }
    return self;
}


-(void)setTextData:(ReMenText *)textData{
    
    _textData=textData;
    
    
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
    //        _loveNumber.text=@"134";
    [self addSubview:_loveNumber];
    [_loveNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loveButton.mas_right).offset(4);
        make.top.equalTo(self.mas_top).offset(21);
        make.size.mas_equalTo(CGSizeMake(30, 12));
    }];
    
    
    
    _loveNumber.text=[NSString stringWithFormat:@"%ld",(long)_textData.zan];
    
    _pingLunWords.text=_textData.content;
    
    _userLable.text=_textData.user;
    
    [_iconImage setImageWithURL:[NSURL URLWithString:_textData.headpic]];
    
    if ([_textData.is_zan isEqualToString:@"1"]) {
        _loveButton.selected=YES;
    }
    
}



-(void)setModel:(MessageModel *)model{
    
    _model=model;
    
    
    _pingLunWords.text=_model.content;
    
    _userLable.text=_model.user;
    
    [_iconImage setImageWithURL:[NSURL URLWithString:_model.headpic]];
    
    
}






#pragma mark - 懒加载


- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}

-(void)loveAction{
    
    if ([_textData.is_zan isEqualToString:@"1"]) {
          [UILabel showStats:@"你已点赞" atView:self];
    }else{
        [self dianZan];
        
    }
    
}



-(void)dianZan{
    
    NSString *channel=@"channel=APP";
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_textData.cid];
    
    
    NSString *typeData=[voiceDianZan stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number=[responseObject objectForKey:@"status"];
        
        NSString *status=[NSString stringWithFormat:@"%@",number];
        
        if ([status isEqualToString:@"1"]) {
            _loveButton.selected=YES;
            
            _textData.zan++;
            
            _loveNumber.text=[NSString stringWithFormat:@"%ld",(long)_textData.zan];
 
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








@end
