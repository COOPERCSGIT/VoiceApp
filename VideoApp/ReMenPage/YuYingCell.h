//
//  YuYingCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ReMenVoice;

@interface YuYingCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>

/** 详细属性 */


@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,copy)NSArray *voiceArray;

@property(nonatomic,assign)NSInteger cellCount;

@property (nonatomic, copy) void (^callBackVoiceCommentPlay)(ReMenVoice *); // 返回评论点击事件


@property (nonatomic, copy) void (^callBackVoiceIcon)(NSString *);


@end
