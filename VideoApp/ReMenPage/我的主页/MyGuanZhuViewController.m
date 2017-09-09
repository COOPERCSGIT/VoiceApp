//
//  MyGuanZhuViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/20.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MyGuanZhuViewController.h"
#import "ReMenCollectionViewCell.h"
#import "GuanZhuModel.h"

@interface MyGuanZhuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    UIImageView *IconImageView;
    UILabel *userNameLable;
    UILabel *guanZhuLabel;
    UILabel *guanZhuNumber;
    UILabel *fenSiLabel;
    UILabel *fenSiNumber;
    
    UIButton *guanZhuBtn;
    
    NSString *myUID;
}

@property (nonatomic, strong) UICollectionView  *collectionView;    // 主体

@end

@implementation MyGuanZhuViewController

static NSString * const myPageCellIdentifier = @"myPageCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getBaseData];

    
}

-(void)addHeadView{
    
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    
   if ([_userUID isEqualToString:myUID]) {
       headView.frame=CGRectMake(0, 20, KScreenWidth, KScreenHeight*0.33-35);
   }else{
       headView.frame=CGRectMake(0, 20, KScreenWidth, KScreenHeight*0.33);
   }
    
    UIButton *close2=[[UIButton alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
    [headView addSubview:close2 ];
    [close2 setImage:[UIImage imageNamed:@"WechatIMG59"] forState:UIControlStateNormal];
    [close2 addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    IconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-KScreenWidth*0.106,KScreenHeight*0.045, KScreenWidth*0.213, KScreenWidth*0.213)];
    
    [IconImageView setImageWithURL:[NSURL URLWithString:_guanzhu.headpic] placeholderImage:[UIImage imageNamed:@"icon3.jpeg"]];
    
    CALayer *layer = IconImageView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:KScreenWidth*0.106];
    
    [headView addSubview:IconImageView];
    
    userNameLable=[[UILabel alloc]init];
    [headView addSubview:userNameLable];
    userNameLable.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    userNameLable.textColor=VideoUserName;
    userNameLable.textAlignment=NSTextAlignmentCenter;
    userNameLable.text=_guanzhu.nickname;
    [userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(IconImageView.mas_centerX);
        make.top.equalTo(IconImageView.mas_bottom).offset(13);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    guanZhuNumber=[[UILabel alloc]init];
    [headView addSubview:guanZhuNumber];
    //    guanZhuNumber.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    guanZhuNumber.font=[UIFont systemFontOfSize:20];
    guanZhuNumber.textColor=VideoUserName;
    guanZhuNumber.textAlignment=NSTextAlignmentCenter;
    guanZhuNumber.text=_guanzhu.guanzhu;
    [guanZhuNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.centerY.equalTo(userNameLable.mas_top);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth/2-KScreenWidth*0.106, 20));
        
    }];
    
    guanZhuLabel=[[UILabel alloc]init];
    [headView addSubview:guanZhuLabel];
    guanZhuLabel.font=[UIFont systemFontOfSize:12];
    guanZhuLabel.textColor=mainPageTitle;
    guanZhuLabel.textAlignment=NSTextAlignmentCenter;
    guanZhuLabel.text=@"关注";
    [guanZhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guanZhuNumber.mas_bottom).offset(5);
        make.centerX.equalTo(guanZhuNumber.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 12));
        
    }];
    
    fenSiNumber=[[UILabel alloc]init];
    [headView addSubview:fenSiNumber];
    
    fenSiNumber.font=[UIFont systemFontOfSize:20];
    fenSiNumber.textColor=VideoUserName;
    fenSiNumber.textAlignment=NSTextAlignmentCenter;
    fenSiNumber.text=_guanzhu.fensi;
    [fenSiNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right);
        make.centerY.equalTo(userNameLable.mas_top);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth/2-KScreenWidth*0.106, 20));
    }];
    
    fenSiLabel=[[UILabel alloc]init];
    [headView addSubview:fenSiLabel];
    fenSiLabel.font=[UIFont systemFontOfSize:12];
    fenSiLabel.textColor=mainPageTitle;
    fenSiLabel.textAlignment=NSTextAlignmentCenter;
    fenSiLabel.text=@"粉丝";
    [fenSiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fenSiNumber.mas_bottom).offset(5);
        make.centerX.equalTo(fenSiNumber.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 12));
        
    }];
    
    guanZhuBtn=[[UIButton alloc]init];
    [headView addSubview:guanZhuBtn];
    
    [guanZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(guanZhuLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(107, 33));
    }];
    [guanZhuBtn setImage:[UIImage imageNamed:@"Set_btn_follow_108x34@3x"] forState:UIControlStateNormal];
    [guanZhuBtn setImage:[UIImage imageNamed:@"Group@3x"] forState:UIControlStateSelected];
    [guanZhuBtn addTarget:self action:@selector(guanzhuAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (_guanzhuNum) {
        if (_guanzhuNum == 0) {
            guanZhuBtn.selected = NO;
        }else if (_guanzhuNum ==1 ){
            guanZhuBtn.selected = YES;
        }
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReMenCollectionViewCell *attrscell = [collectionView dequeueReusableCellWithReuseIdentifier:myPageCellIdentifier forIndexPath:indexPath];
    attrscell.DataType=@"allVoice?";
    attrscell.is_u=2;
    attrscell.pageUID=_userUID;
    attrscell.myCid=myUID;
    attrscell.callBackGuanZhuYes=^(){
        guanZhuBtn.selected=YES;
    };
    return attrscell;
}


-(void)getBaseData{
    
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_userUID];
    
    
    NSString *typeData=[voiceGetUser stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   
        _guanzhu=[GuanZhuModel mj_objectWithKeyValues:responseObject];
        
        [self addHeadView];
        if ([_userUID isEqualToString:myUID]) {
            guanZhuBtn.hidden=YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}


-(void)guanzhuAction{
    
    [self addGuanzhu];
    
}

-(void)addGuanzhu{
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_userUID];
    NSString *typeData=[voiceguanzhu stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        guanZhuBtn.selected = !guanZhuBtn.selected;
        !self.callBackRefresh ? : self.callBackRefresh();
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








- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)closeAction{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)setUserUID:(NSString *)userUID{
    
    _userUID=userUID;
    
    // 加collectionView
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    
    if ([_userUID isEqualToString:@"5LIs5OWEdaz4"]) {
        flowLayout.itemSize = CGSizeMake(KScreenWidth,KScreenHeight*0.67+15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             KScreenHeight*0.33-15,
                                                                             KScreenWidth,
                                                                             KScreenHeight*0.67+15)
                                             collectionViewLayout:flowLayout];
        
        
    }else{
        
        flowLayout.itemSize = CGSizeMake(KScreenWidth,KScreenHeight*0.67-20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             KScreenHeight*0.33+20,
                                                                             KScreenWidth,
                                                                             KScreenHeight*0.67-20)
                                             collectionViewLayout:flowLayout];
    }
    
    
    // 注册2个单元格
    
    [_collectionView registerClass:[ReMenCollectionViewCell class]
        forCellWithReuseIdentifier:myPageCellIdentifier];
    
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor =[UIColor redColor] ;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_collectionView];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
}

-(void)setGuanzhuNum:(NSInteger)guanzhuNum{
    
    _guanzhuNum=guanzhuNum;
    
   
    
    
    
}


@end
