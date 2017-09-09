//
//  MoreYuYingCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MoreYuYingCell.h"
#import "MoreYuYingTableViewCell.h"
#import "ReMenVoice.h"

@implementation MoreYuYingCell

static NSString *const ReMenCellIdentifier = @"yuYingCell";


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
    return self.voiceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MoreYuYingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ReMenCellIdentifier];
    
    if (!cell ) {
        
        cell = [[MoreYuYingTableViewCell alloc ]
                
                initWithStyle : UITableViewCellStyleDefault
                
                reuseIdentifier :ReMenCellIdentifier];
    }
    if (self.voiceArray.count>0) {
        cell.voiceData=self.voiceArray[indexPath.row];
        
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
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_voiceVid];
    
    NSString *type=@"&type=1";
    NSString *page=@"&page=1";
    
    NSString *num=@"&num=20";
    
    NSString *typeData=[voiceTotalComments stringByAppendingFormat:@"%@%@%@%@%@%@",channel,uid,vid,type,page,num];
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.voiceArray=[ReMenVoice mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReMenVoice *voice=[[ReMenVoice alloc]init];
    
    voice=_voiceArray[indexPath.row];
    
     !self.callBackVoice ? : self.callBackVoice(voice);
}


#pragma mark - 懒加载


- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}

- (NSMutableArray *)voiceArray {
    if (!_voiceArray) {
        _voiceArray = [NSMutableArray array];
    }
    return _voiceArray;
}



-(void)setVoiceVid:(NSString *)voiceVid{
    _voiceVid=voiceVid;
    
    [self getAllComments];
}

@end
