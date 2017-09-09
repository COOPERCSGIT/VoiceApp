//
//  LeftSortsViewController.h
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuanZhuModel;

@interface LeftSortsViewController : UIViewController

@property(nonatomic,strong)UITableView *table;
@property (nonatomic, strong) AFHTTPSessionManager *mananger;

@property(nonatomic,strong)GuanZhuModel *guanzhu;

@property(nonatomic,copy)NSString *importantUID;

@end
