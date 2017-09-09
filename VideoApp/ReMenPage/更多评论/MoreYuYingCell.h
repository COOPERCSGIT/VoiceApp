//
//  MoreYuYingCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReMenVoice;
@interface MoreYuYingCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>

/** 详细属性 */


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;

@property(nonatomic,copy)NSString *voiceVid;

@property(nonatomic,copy)NSMutableArray *voiceArray;


@property (nonatomic, copy) void (^callBackVoice)(ReMenVoice *); // 返回评论点击事件


@end
