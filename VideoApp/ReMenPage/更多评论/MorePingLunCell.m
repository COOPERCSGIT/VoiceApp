//
//  MorePingLunCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MorePingLunCell.h"
#import "MorePingLunTableViewCell.h"
#import "ReMenText.h"

@implementation MorePingLunCell

static NSString *const ReMenCellIdentifier = @"ReMenCell";


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        self.contentView.backgroundColor = HRViewBackgroundColor;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
       
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.showsVerticalScrollIndicator = NO;

        [self.contentView addSubview:_tableView];
      
        
    }
    return self;
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MorePingLunTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ReMenCellIdentifier];
    
    if (!cell ) {
        
        cell = [[MorePingLunTableViewCell alloc ]
                
                initWithStyle : UITableViewCellStyleDefault
                
                reuseIdentifier :ReMenCellIdentifier];
    }
    
    if (self.textArray.count>0) {
        cell.textData=self.textArray[indexPath.row];
        
      
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}




-(void)getAllComments{
    
    NSString *channel=@"channel=APP";
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_textVid];
    
    NSString *type=@"&type=0";
    NSString *page=@"&page=1";
    
    NSString *num=@"&num=20";
    
    NSString *typeData=[voiceTotalComments stringByAppendingFormat:@"%@%@%@%@%@%@",channel,uid,vid,type,page,num];
    
 
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);

        
        self.textArray=[ReMenText mj_objectArrayWithKeyValuesArray:responseObject];
      
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}




#pragma mark - 懒加载


- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}

- (NSMutableArray *)textArray {
    if (!_textArray) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}



-(void)setTextVid:(NSString *)textVid{
    
    _textVid=textVid;
    
      [self getAllComments];
}



@end
