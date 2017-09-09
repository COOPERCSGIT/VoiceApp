//
//  LuYinViewController.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/3.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuYinViewController : UIViewController

@property (nonatomic, copy) void (^callBackVoiceTime)(NSInteger);
@property (nonatomic, copy) void (^callBackVoiceUrl)(NSString *);


@end
