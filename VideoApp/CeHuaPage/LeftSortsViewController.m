 //
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "MyMessageViewController.h"
#import "MySettingViewController.h"
#import "MyGuanZhuViewController.h"
#import "GuanZhuModel.h"
#import "ReMenViewController.h"
#import "LeftViewHeadView.h"


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height


@interface LeftSortsViewController () {
    
    UIImageView *IconImageView;
    UILabel *userNameLable;
    UILabel *guanZhuLabel;
    UILabel *guanZhuNumber;
    UILabel *fenSiLabel;
    UILabel *fenSiNumber;
    
    
    
    UIButton *faBu;
    UIButton *caoGao;
    UIButton *xiaoXi;
    UIButton *sheZhi;
    
    NSString *uid;
    
    LeftViewHeadView *headView;
}


@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self addSettingButton];
   
    

}







-(void)addSettingButton{
    faBu=[[UIButton alloc]initWithFrame:CGRectMake(33, KScreenHeight*0.45, (KScreenWidth-115), 24)];
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 95, 24)];
    [faBu addSubview:image1];
    image1.image=[UIImage imageNamed:@"Set_btntext_1_98x24@3x"];
    image1.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FaBuAction)];
    [image1 addGestureRecognizer:singleTap1];
    [faBu addTarget:self action:@selector(FaBuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faBu];
//    caoGao=[[UIButton alloc]initWithFrame:CGRectMake(33, KScreenHeight*0.45+50, (KScreenWidth-115), 24)];
//    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 81, 20)];
//    [caoGao addSubview:image2];
//    image2.image=[UIImage imageNamed:@"Set_btntext_2_84x24@3x"];
//    image2.userInteractionEnabled=YES;
//    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FaBuAction1)];
//    [image2 addGestureRecognizer:singleTap2];
//    [caoGao addTarget:self action:@selector(FaBuAction1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:caoGao];
    xiaoXi=[[UIButton alloc]initWithFrame:CGRectMake(33, KScreenHeight*0.45+50, (KScreenWidth-115), 24)];
    UIImageView *image3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 96, 19)];
    [xiaoXi addSubview:image3];
    image3.image=[UIImage imageNamed:@"Set_btntext_3_98x24@3x"];
    image3.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FaBuAction2)];
    [image3 addGestureRecognizer:singleTap3];
    [xiaoXi addTarget:self action:@selector(FaBuAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xiaoXi];
    sheZhi=[[UIButton alloc]initWithFrame:CGRectMake(33, KScreenHeight*0.45+100, (KScreenWidth-115), 24)];
    UIImageView *image4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 68, 20)];
    [sheZhi addSubview:image4];
    image4.image=[UIImage imageNamed:@"Set_btntext_4_68x20@3x"];
    image4.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FaBuAction3)];
    [image4 addGestureRecognizer:singleTap4];
    [sheZhi addTarget:self action:@selector(FaBuAction3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sheZhi];
}

//
//-(void)getBaseData1{
//    
//    NSString *channel=@"channel=APP";
//    uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
// 
//    NSString *myuid=[NSString stringWithFormat:@"&uid=%@",uid];
//    NSString *cid=[NSString stringWithFormat:@"&cid=%@",uid];
//    
//    NSString *typeData=[voiceGetUser stringByAppendingFormat:@"%@%@%@",channel,myuid,cid];
//    
//    self.mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
//    
//  
//    
//    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        _guanzhu=[GuanZhuModel mj_objectWithKeyValues:responseObject];
//    
//        headView.guanzhuModel=_guanzhu;
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//      
//        
//    }];
//}
//
//



-(void)FaBuAction{
//        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        otherViewController *vc = [[otherViewController alloc] init];
//        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//    
//        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
//    
//        [tempAppDelegate.mainNavigationController  presentViewController:nav animated:NO completion:NULL];
    
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    MyGuanZhuViewController *my=[[MyGuanZhuViewController alloc]init];
    my.userUID=myUID;
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:my];
    [tempAppDelegate.mainNavigationController  presentViewController:nav animated:NO completion:NULL];
    
}

-(void)FaBuAction1{
}

-(void)FaBuAction2{
    
  
    MyMessageViewController *my=[[MyMessageViewController alloc]init];
 
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:my];
    [tempAppDelegate.mainNavigationController  presentViewController:nav animated:NO completion:NULL];
    
    
    
    
}

-(void)FaBuAction3{
    
    MySettingViewController *my=[[MySettingViewController alloc]init];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:my];
    [tempAppDelegate.mainNavigationController  presentViewController:nav animated:NO completion:NULL];
   
}




-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
    
}



@end
