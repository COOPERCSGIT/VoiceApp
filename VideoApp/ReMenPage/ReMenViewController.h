//
//  ReMenViewController.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/2.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  LeftSlideViewController;
@interface ReMenViewController : UIViewController
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic, strong) AFHTTPSessionManager *mananger;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (nonatomic,copy)NSMutableArray *moreDataArray;
@property (nonatomic,copy)NSMutableArray *voiceArray;
@end
