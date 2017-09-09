//
//  MyMessageViewController.h
//  VideoApp
//
//  Created by 叶健东 on 17/3/2.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyMessageModel;

@interface MyMessageViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;
@property (nonatomic,copy)NSMutableArray *voiceArray;

@property (nonatomic,copy)NSMutableArray *moreDataArray;

@property(nonatomic,strong)MyMessageModel *megModel;

@end
