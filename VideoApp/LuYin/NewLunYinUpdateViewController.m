//
//  NewLunYinUpdateViewController.m
//  VideoApp
//
//  Created by cheng on 2017/5/30.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//
//估计没啥用？？

#import "NewLunYinUpdateViewController.h"
@interface NewLunYinUpdateViewController ()
@end

@implementation NewLunYinUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50, 30, 30, 30)];
    [self.view addSubview:closeBtn];
    
    [closeBtn setImage:[UIImage imageNamed:@"Re_btn_close_24x24@2x"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(tapCloseAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapCloseAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
@end
