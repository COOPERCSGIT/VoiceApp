//
//  NewLuYinViewController.h
//  VideoApp
//
//  Created by cheng on 2017/5/30.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewLuYinViewController : UIViewController
@property (nonatomic, copy) void (^callBackVoiceTime)(NSInteger);
@property (nonatomic, copy) void (^callBackVoiceUrl)(NSString *);
@property(nonatomic,strong)NSString* isRecording;
@end
