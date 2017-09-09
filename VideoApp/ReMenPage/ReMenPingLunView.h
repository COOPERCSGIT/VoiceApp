//
//  ReMenPingLunView.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewReMenModel,ReMenModel,ReMenVoice;
@interface ReMenPingLunView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>


@property(nonatomic,copy)UIView *headView;


@property(nonatomic,copy)UIButton *wenZi;

@property(nonatomic,copy)UIButton *yuYin;

@property(nonatomic,copy)UIButton *morePingLunButton;
@property (nonatomic, strong) UICollectionView  *collectionView;    // 主体
@property (nonatomic, assign) NSInteger index;              // 当前下标

@property(nonatomic,copy)UIView *footView;

@property (nonatomic, copy) void (^callBackVoiceCommentPlay2)(ReMenVoice *);

@property (nonatomic, copy) void (^callBackPinLunMore1)(); // 返回评论点击事件

@property (nonatomic, copy) void (^callBackIconTouch)(NSString *);

@property(nonatomic,strong)ReMenModel *detailPinLun;

@property(nonatomic,assign)NSInteger cellNumber;

@property(nonatomic,assign)NSInteger morePinLunIs;

@property (nonatomic,strong)NSArray *txtDataArray;

@property (nonatomic,strong)NSArray *voiceDataArray;

@end
