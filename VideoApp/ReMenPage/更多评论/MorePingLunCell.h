//
//  MorePingLunCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorePingLunCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>

/** 详细属性 */


@property (nonatomic, strong) UITableView *tableView;


@property(nonatomic,copy)NSString *textVid;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;

@property(nonatomic,copy)NSMutableArray *textArray;

@end
