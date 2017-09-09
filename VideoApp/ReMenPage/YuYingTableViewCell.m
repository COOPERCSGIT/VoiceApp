//
//  YuYingTableViewCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "YuYingTableViewCell.h"
#import "ReMenVoice.h"
#import "AppDelegate.h"
#import "MyGuanZhuViewController.h"
@implementation YuYingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(8, KScreenHeight*0.003+5, KScreenHeight*0.045, KScreenHeight*0.045)];
        
       CALayer *layer = _iconImage.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:KScreenHeight*0.020];
        
        [self addSubview:_iconImage];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        //为图片添加手势
         _iconImage.userInteractionEnabled = YES;//打开用户交互
        
        
        _userLable=[UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColor.blackColor numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        
        _userLable.frame=CGRectMake(KScreenHeight*0.04+15, KScreenHeight*0.010+4, 100, 10);
        [self addSubview:_userLable];
        
         _userLable.userInteractionEnabled = YES;//打开用户交互
        
        [_userLable addGestureRecognizer:singleTap];
        [_iconImage addGestureRecognizer:singleTap];

        _pingLunWords=[UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:mainPagePingLun numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        _pingLunWords.backgroundColor=yuYingBackView;
        CALayer *layer1 = _pingLunWords.layer;
       
        [layer1 setMasksToBounds:YES];
        [layer1 setCornerRadius:4];
        
        [self addSubview:_pingLunWords];
        
        _voiceTime=[UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
//        _voiceTime.text=@"15'";
        //        _loveNumber.backgroundColor=[UIColor redColor];
       
        [self addSubview:_voiceTime];
        
        
        
        _loveButton=[[UIButton alloc]init];
       
        
        [_loveButton setImage:[UIImage imageNamed:@"Hot__Normal_like_14x12@2x"] forState:UIControlStateNormal];
        [_loveButton setImage:[UIImage imageNamed:@"Hot_Down_like_14x12@2x"] forState:UIControlStateSelected];
        [_loveButton addTarget:self action:@selector(loveAction) forControlEvents:UIControlEventTouchUpInside];
        
        _loveNumber=[UILabel labelWithFont:[UIFont systemFontOfSize:10] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        [self addSubview:_loveNumber];
        
        
        
    }
    return self;
}





-(void)setReMen:(ReMenVoice *)reMen{
    
    
    _reMen=reMen;
    
    _userLable.text=_reMen.user;
    
    NSInteger length=_reMen.clength;
   
    _voiceTime.text=[NSString stringWithFormat:@"%ld‘",(long)length];
    
    [_iconImage setImageWithURL:[NSURL URLWithString:_reMen.headpic]];
    
    CGFloat singleLength=(KScreenWidth-KScreenHeight*0.02-KScreenWidth*0.267-5)/60;
    if (length<10) {
        length=10;
    }
    NSInteger totalLength=singleLength*length;

    _pingLunWords.frame=CGRectMake(KScreenHeight*0.04+15, KScreenHeight*0.04, totalLength, 12);
    _voiceTime.frame=CGRectMake(KScreenHeight*0.04+15+totalLength+18, KScreenHeight*0.04, 30, 10);
    
    _loveNumber.text=[NSString stringWithFormat:@"%ld",(long)_reMen.zan];
    
    [self addSubview:_loveButton];
    
    [_loveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(KScreenHeight*0.03);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_loveNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loveButton.mas_right).offset(2);
        make.top.equalTo(self.mas_top).offset(KScreenHeight*0.03+1);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    if ([_reMen.is_zan isEqualToString:@"1"]) {
        _loveButton.selected=YES;
    }
    
}


-(void)loveAction{
    
    if ([_reMen.is_zan isEqualToString:@"1"]) {
        
        [UILabel showStats:@"你已点赞" atView:self];
    }else{
        
        [self dianZan];
    }
}



-(void)dianZan{
    
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_reMen.cid];
 
   
    NSString *typeData=[voiceDianZan stringByAppendingFormat:@"%@%@%@",channel,uid,cid];

    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSNumber *number=[responseObject objectForKey:@"status"];
        
        NSString *status=[NSString stringWithFormat:@"%@",number];
        
        if ([status isEqualToString:@"1"]) {
            _loveButton.selected=YES;
            
            _reMen.zan++;
            
            _loveNumber.text=[NSString stringWithFormat:@"%ld",(long)_reMen.zan];
            
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

-(void)singleTapAction{
    
    
    
     !self.callBackVoiceIconTap ? : self.callBackVoiceIconTap(_reMen.uid);
  
//    MyGuanZhuViewController *guanzhu=[[MyGuanZhuViewController alloc]init];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:guanzhu];
//    
//    guanzhu.userUID=_reMen.uid;
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [tempAppDelegate.mainNavigationController presentViewController:nav animated:YES completion:nil];

    
}




@end
