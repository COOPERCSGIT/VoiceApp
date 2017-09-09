//
//  PingLunCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "PingLunCell.h"
#import "PingLunTableViewCell.h"
@implementation PingLunCell

static NSString *const ReMenCellIdentifier = @"ReMenCell";


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        self.contentView.backgroundColor = HRViewBackgroundColor;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled=NO;
        [self.contentView addSubview:_tableView];
        
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PingLunTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ReMenCellIdentifier];
    
    if (!cell ) {
        
        cell = [[PingLunTableViewCell alloc ]
                
                initWithStyle : UITableViewCellStyleDefault
                
                reuseIdentifier :ReMenCellIdentifier];
    }

    if (self.textArray.count>0) {
        
        cell.reMen=self.textArray[indexPath.row];

    }
    cell.callBackTextIconTap=^(NSString *text){
        
        !self.callBackTextIcon ? : self.callBackTextIcon(text);
        
        
    };

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KScreenHeight*0.06;
}

-(void)setCellCount:(NSInteger)cellCount{
    _cellCount=cellCount;
}

-(void)setTextArray:(NSArray *)textArray{
    
    _textArray=textArray;
    
    
    
}

@end
