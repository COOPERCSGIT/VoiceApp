//
//  NewLuYinActionView.h
//  VideoApp
//
//  Created by cheng on 2017/6/1.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewLuYinActionView : UIViewController
/**
 设置PictureControllerView内URL
 */
@property (nonatomic, copy) void (^callBackVoiceTime)(NSString *);
@property (nonatomic, copy) void (^callBackVoiceUrl)(NSString *);
//@property (nonatomic,copy) void (^callBackVoiceIndex)(NSString*);

@property(nonatomic,strong) UIImageView* background;
//@property(nonatomic,strong) UIBlurEffect *blur;
@property(nonatomic,strong) UIImage * pic;
@property(nonatomic,copy)NSString *index;
- (instancetype)initWithBackground:(UIImage*)Image;

@end
