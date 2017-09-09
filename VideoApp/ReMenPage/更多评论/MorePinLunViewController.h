//
//  MorePinLunViewController.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorePinLunViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>


@property(nonatomic,copy)UIView *headView;


@property(nonatomic,copy)UIButton *wenZi;

@property(nonatomic,copy)UIButton *yuYin;


@property(nonatomic,copy)UILabel *lineLable;

@property (nonatomic, strong) UICollectionView  *collectionView;    // 主体
@property (nonatomic, assign) NSInteger index;              // 当前下标
@property (nonatomic, strong) FSAudioStream *audioStream;

@property(nonatomic,copy)NSString *myVid;

@end
