//
//  YuYingCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
#import "YuYingCell.h"
#import "YuYingTableViewCell.h"
#import "ReMenVoice.h"
@implementation YuYingCell

static NSString *const ReMenCellIdentifier = @"yuYingCell";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        self.contentView.backgroundColor = HRViewBackgroundColor;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled=NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _voiceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YuYingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ReMenCellIdentifier];
    
    if (!cell ) {
        
        cell = [[YuYingTableViewCell alloc ]
                
                initWithStyle : UITableViewCellStyleDefault
                
                reuseIdentifier :ReMenCellIdentifier];
    }
    if (self.voiceArray.count>0) {
        
        cell.reMen=_voiceArray[indexPath.row];
   
    }
    
    cell.callBackVoiceIconTap=^(NSString *text){
        
        !self.callBackVoiceIcon ? : self.callBackVoiceIcon(text);

        
    };
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KScreenHeight*0.062;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReMenVoice *voice=[[ReMenVoice alloc]init];
    
    voice=_voiceArray[indexPath.row];
    
    !self.callBackVoiceCommentPlay ? : self.callBackVoiceCommentPlay(voice);

    
}
-(void)setVoiceArray:(NSArray *)voiceArray{
    
    _voiceArray=voiceArray;

}
-(void)setCellCount:(NSInteger)cellCount{
    _cellCount=cellCount;
}
@end
