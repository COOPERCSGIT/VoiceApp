//
//  MyGuanZhuViewController.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/20.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuanZhuModel;

@interface MyGuanZhuViewController : UIViewController

@property(nonatomic,copy)NSString *userUID;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;

@property(nonatomic,strong)GuanZhuModel *guanzhu;

@property(nonatomic,assign)NSInteger guanzhuNum;

@property (nonatomic, copy) void (^callBackRefresh)();

@end
