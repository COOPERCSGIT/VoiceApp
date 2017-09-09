//
//  AppDelegate.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/2.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;

@property (strong, nonatomic) UINavigationController *mainNavigationController;

@property(strong,nonatomic)FSAudioStream *audioStream;

@end

