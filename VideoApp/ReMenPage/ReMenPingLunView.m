//
//  ReMenPingLunView.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "ReMenPingLunView.h"
#import "PingLunCell.h"
#import "YuYingCell.h"
#import "ReMenModel.h"
#import "ReMenVoice.h"
@implementation ReMenPingLunView

static NSString * const detailCellIdentifier = @"wenZi";
static NSString * const attrsCellIdentifier = @"yuYing";


- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        // 导航
        _headView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth-30, KScreenHeight*0.045)];
        _headView.backgroundColor=VideoMainPageBack;
        [self addSubview:_headView];
        // 文字 65, 9,80,13
        _wenZi = [[UIButton alloc] initWithFrame:CGRectMake(65, 9,80,13)];
        _wenZi.backgroundColor=[UIColor clearColor];
        _wenZi.titleLabel.font = [UIFont systemFontOfSize:13];
        [_wenZi setTitle:@"语音评论" forState:UIControlStateNormal];
        [_wenZi setTitleColor:mainPageTitle forState:UIControlStateNormal];
        [_wenZi setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
        [_headView addSubview:_wenZi];
        _wenZi.selected = YES;
        [_wenZi addTarget:self
                   action:@selector(scrollToAttrsView)
         forControlEvents:UIControlEventTouchUpInside];
        // 语音
        _yuYin = [[UIButton alloc] initWithFrame:CGRectMake(5, 9, 60, 13)];
        _yuYin.backgroundColor=[UIColor clearColor];
        _yuYin.titleLabel.font = [UIFont systemFontOfSize:13];
        [_yuYin setTitle:@"文字评论" forState:UIControlStateNormal];
        [_yuYin setTitleColor:mainPageTitle forState:UIControlStateNormal];
        [_yuYin setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
        [_headView addSubview:_yuYin];
        _yuYin.selected = NO;
        [_yuYin addTarget:self
                         action:@selector(scrollToDetailView)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self refreshNavViewByIndex:0];
    }
    return self;
}
    
        
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.item==0) {
        
        PingLunCell *pingLunscell = [collectionView dequeueReusableCellWithReuseIdentifier:attrsCellIdentifier forIndexPath:indexPath];
        
        pingLunscell.cellCount=_cellNumber;
        
        pingLunscell.textArray=self.txtDataArray;
        
        pingLunscell.callBackTextIcon=^(NSString *text){
            
            !self.callBackIconTouch ? : self.callBackIconTouch(text);
        };
        
        cell=pingLunscell;
        
    }else if (indexPath.item ==1) {
        YuYingCell *attrscell = [collectionView dequeueReusableCellWithReuseIdentifier:detailCellIdentifier forIndexPath:indexPath];
        
        attrscell.cellCount=_cellNumber;
        attrscell.voiceArray=self.voiceDataArray;
        
        
        attrscell.callBackVoiceCommentPlay=^(ReMenVoice *voice){
            
            !self.callBackVoiceCommentPlay2 ? : self.callBackVoiceCommentPlay2(voice);
  
        };
        
        attrscell.callBackVoiceIcon=^(NSString *text){
            
            !self.callBackIconTouch ? : self.callBackIconTouch(text);
        };
        
        cell=attrscell;
        
    }
    return cell;
}

#pragma mark - 事件处理


- (void)scrollToDetailView{
    // collectionview 向左滑动
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self refreshNavViewByIndex:1];
}

- (void)scrollToAttrsView {
    // collectionview 向右滑动
    [self.collectionView setContentOffset:CGPointMake(KScreenWidth-30, 0) animated:YES];
    [self refreshNavViewByIndex:0];

}

// collectionview 左右滑动，调用这个方法，使得上面indexView对应起来

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = self.collectionView.frame.size.width;
    NSInteger index = scrollView.contentOffset.x / width;
    [self refreshNavViewByIndex:index];
}


- (void)refreshNavViewByIndex:(NSInteger)index {
    if (index == 0) {
        _wenZi.selected=NO;
        _yuYin.selected=YES;
    } else if (index == 1) {
        _wenZi.selected=YES;
        _yuYin.selected=NO;
    }
}


-(void)moreAction{
    !self.callBackPinLunMore1 ? : self.callBackPinLunMore1();
}

-(void)setDetailPinLun:(ReMenModel *)detailPinLun{
    
    _detailPinLun=detailPinLun;
    
    self.txtDataArray=_detailPinLun.comment_t;
    
    self.voiceDataArray=_detailPinLun.comment_c;
    
}

- (NSArray *)txtDataArray {
    if (!_txtDataArray) {
        _txtDataArray = [[NSArray alloc]init];
    }
    return _txtDataArray;
}

- (NSArray *)voiceDataArray {
    if (!_voiceDataArray) {
        _voiceDataArray = [[NSArray alloc]init];
    }
    return _voiceDataArray;
}

-(void)setCellNumber:(NSInteger)cellNumber{
    
    _cellNumber=cellNumber;
    
    
    // 加collectionView
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if (_cellNumber==1) {
        
        flowLayout.itemSize = CGSizeMake(KScreenWidth-30,KScreenHeight*0.06);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,
                                                                             KScreenHeight*0.045,
                                                                             KScreenWidth-30,
                                                                             KScreenHeight*0.06)
                                             collectionViewLayout:flowLayout];
        
    
        
        
    }else if(_cellNumber==2){
        
    flowLayout.itemSize = CGSizeMake(KScreenWidth-30,KScreenHeight*0.12);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,
                                                                             KScreenHeight*0.045,
                                                                             KScreenWidth-30,
                                                                             KScreenHeight*0.12)
                                             collectionViewLayout:flowLayout];
    
        
    }
    
    
    flowLayout.minimumLineSpacing = 0;
    
       // 注册2个单元格
    
    [_collectionView registerClass:[YuYingCell class]
        forCellWithReuseIdentifier:detailCellIdentifier];
    
    [_collectionView registerClass:[PingLunCell class]
        forCellWithReuseIdentifier:attrsCellIdentifier];
    
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor =[UIColor whiteColor] ;
    
    //        _collectionView.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addSubview:_collectionView];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    
}

-(void)setMorePinLunIs:(NSInteger)morePinLunIs{
    
    _morePinLunIs=morePinLunIs;
    
    if (_morePinLunIs==1) {
        // 导航
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight*0.165, KScreenWidth-30, KScreenHeight*0.066)];
        _footView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_footView];
        
        _morePingLunButton=[[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight*0.013, 50, KScreenHeight*0.044)];
        [_footView addSubview:_morePingLunButton];
        
        
        [_morePingLunButton setTitle:@"更多评论" forState:UIControlStateNormal];
        
        [_morePingLunButton setTitleColor:mainPageTitle forState:UIControlStateNormal];
        _morePingLunButton.titleLabel.font=[UIFont systemFontOfSize:11];
        _morePingLunButton.backgroundColor=[UIColor clearColor];
        [_morePingLunButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];

    }
    
}
        
@end
