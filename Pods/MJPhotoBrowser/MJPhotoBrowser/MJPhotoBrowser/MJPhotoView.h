//
//  MJZoomingScrollView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class MJPhotoBrowser, MJPhoto, MJPhotoView;
@protocol MJPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView;
- (void)photoViewSingleTap:(MJPhotoView *)photoView;
- (void)photoViewDidEndZoom:(MJPhotoView *)photoView;
@end
@interface MJPhotoView : UIScrollView <UIScrollViewDelegate,AVAudioPlayerDelegate>{
    NSInteger minutes;
    NSInteger seconds;
    float progress;
//    float total;
//    float current;
}

@property (nonatomic,strong)AVPlayer *aPlayer;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign) NSInteger countNum;//录音计时（秒）
@property (nonatomic, strong) UISlider *processSlider;
//mp3
@property(nonatomic,strong)NSString* reurl;
// 图片
@property (nonatomic, strong) MJPhoto *photo;
// 代理
@property (nonatomic, weak) id<MJPhotoViewDelegate> photoViewDelegate;
@end
