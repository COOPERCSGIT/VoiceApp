//
//  PingLunCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PingLunCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>

/** 详细属性 */


@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,assign)NSInteger cellCount;

@property(nonatomic,copy)NSArray *textArray;

@property (nonatomic, copy) void (^callBackTextIcon)(NSString *);
@end
