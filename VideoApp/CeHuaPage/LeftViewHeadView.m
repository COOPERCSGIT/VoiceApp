//
//  LeftViewHeadView.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/28.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "LeftViewHeadView.h"
#import "GuanZhuModel.h"
@implementation LeftViewHeadView{
    
    UIImageView *IconImageView;
    UILabel *userNameLable;
    UILabel *guanZhuLabel;
    UILabel *guanZhuNumber;
    UILabel *fenSiLabel;
    UILabel *fenSiNumber;
    
    
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        [self addIconImage];
        [self addDetailsLabel];
        
        
    }
    
    return self;
}






-(void)addIconImage{
    
    IconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-KScreenWidth*0.513-75,45, KScreenWidth*0.227, KScreenWidth*0.227)];
   
    
    CALayer *layer = IconImageView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:KScreenWidth*0.113];
    
    [self addSubview:IconImageView];
    
    userNameLable=[[UILabel alloc]init];
    [self addSubview:userNameLable];
    userNameLable.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    userNameLable.textColor=VideoUserName;
    userNameLable.textAlignment=NSTextAlignmentCenter;

    
    [userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(IconImageView.mas_centerX);
        make.top.equalTo(IconImageView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
}

-(void)addDetailsLabel{
    
    guanZhuNumber=[[UILabel alloc]init];
    [self addSubview:guanZhuNumber];
    //    guanZhuNumber.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    guanZhuNumber.font=[UIFont systemFontOfSize:20];
    guanZhuNumber.textColor=VideoUserName;
    guanZhuNumber.textAlignment=NSTextAlignmentCenter;
  
    [guanZhuNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameLable.mas_bottom).offset(30);
        make.centerX.equalTo(userNameLable.mas_centerX).offset(-70);
        make.size.mas_equalTo(CGSizeMake(140, 20));
        
    }];
    
    guanZhuLabel=[[UILabel alloc]init];
    [self addSubview:guanZhuLabel];
    guanZhuLabel.font=[UIFont systemFontOfSize:12];
    guanZhuLabel.textColor=mainPageTitle;
    guanZhuLabel.textAlignment=NSTextAlignmentCenter;
    guanZhuLabel.text=@"关注";
    [guanZhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameLable.mas_bottom).offset(50);
        make.centerX.equalTo(userNameLable.mas_centerX).offset(-70);
        make.size.mas_equalTo(CGSizeMake(140, 20));
        
    }];
    
    fenSiNumber=[[UILabel alloc]init];
    [self addSubview:fenSiNumber];
    
    fenSiNumber.font=[UIFont systemFontOfSize:20];
    fenSiNumber.textColor=VideoUserName;
    fenSiNumber.textAlignment=NSTextAlignmentCenter;

    [fenSiNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameLable.mas_bottom).offset(30);
        make.centerX.equalTo(userNameLable.mas_centerX).offset(70);
        make.size.mas_equalTo(CGSizeMake(140, 20));
        
    }];
    
    fenSiLabel=[[UILabel alloc]init];
    [self addSubview:fenSiLabel];
    fenSiLabel.font=[UIFont systemFontOfSize:12];
    fenSiLabel.textColor=mainPageTitle;
    fenSiLabel.textAlignment=NSTextAlignmentCenter;
    fenSiLabel.text=@"粉丝";
    
    [fenSiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameLable.mas_bottom).offset(50);
        make.centerX.equalTo(userNameLable.mas_centerX).offset(70);
        make.size.mas_equalTo(CGSizeMake(140, 20));
        
    }];
    
}


-(void)setGuanzhuModel:(GuanZhuModel *)guanzhuModel{
    
    _guanzhuModel=guanzhuModel;
    
    [IconImageView setImageWithURL:[NSURL URLWithString:_guanzhuModel.headpic]];
    userNameLable.text=_guanzhuModel.nickname;

    fenSiNumber.text=_guanzhuModel.fensi;

  guanZhuNumber.text=_guanzhuModel.guanzhu;



}






@end
