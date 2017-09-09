
//
//  MySettingViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/3/3.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MySettingViewController.h"

@interface MySettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
}

@end



@implementation MySettingViewController

static NSString *const mysetCellIdentifier = @"mysetCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
   

    [self setUpTableView];

    self.title=@"设置";

}


-(void)setUpTableView{
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"WechatIMG59" target:self action:@selector(getBack)];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    if (section == 1) return 1;
  
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mysetCellIdentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0){
        cell.textLabel.text=@"清除缓存";
    }
    if (indexPath.section==1 && indexPath.row==0) {
        
        cell.textLabel.text=@"关于我们";
    }
   
 
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }else{
        return 0.1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KScreenHeight*0.072;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
   
        [alert addAction:okAction];
     
        [self presentViewController:alert animated:YES completion:NULL];
        
    }else{
        
        
        
}}













-(void)getBack{
    [self dismissViewControllerAnimated:YES completion:NULL];
}







@end
