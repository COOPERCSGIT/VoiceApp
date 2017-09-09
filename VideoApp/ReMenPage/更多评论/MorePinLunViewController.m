//
//  MorePinLunViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/6.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MorePinLunViewController.h"
#import "MoreYuYingCell.h"
#import "MorePingLunCell.h"
#import "ReMenVoice.h"

@interface MorePinLunViewController ()

@property (nonatomic, strong) UIView    *navView;           // 导航view
@property (nonatomic, strong) UIButton   *detailButton;      // 请假btn
@property (nonatomic, strong) UIButton  *attrsButton;       // 补卡btn

@end

@implementation MorePinLunViewController

static NSString * const detailCellIdentifier = @"wenZi";
static NSString * const attrsCellIdentifier = @"yuYing";



- (void)viewDidLoad {
    [super viewDidLoad];
    
      [self addCollectionView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"WechatIMG59" target:self action:@selector(getBack)];
   
}


-(void)addCollectionView{
    
    // 导航
    _navView = [[UIView alloc] initWithFrame:CGRectMake(70, 10, KScreenWidth-140, 30)];
    _navView.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:_navView];
    
    
    // 文字
    _wenZi = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-140)/2, 30)];
    _wenZi.backgroundColor=[UIColor clearColor];
    _wenZi.titleLabel.font = [UIFont systemFontOfSize:16];
    [_wenZi setTitle:@"语音评论" forState:UIControlStateNormal];
    [_wenZi setTitleColor:mainPageTitle forState:UIControlStateNormal];
    [_wenZi setTitleColor:VideoUserName forState:UIControlStateSelected];
    [_navView addSubview:_wenZi];
    _wenZi.selected = YES;
    [_wenZi addTarget:self
               action:@selector(scrollToDetailView)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    // 语音
    _yuYin = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-140)/2, 0, (KScreenWidth-140)/2, 30)];
    _yuYin.backgroundColor=[UIColor clearColor];
    _yuYin.titleLabel.font = [UIFont systemFontOfSize:16];
    [_yuYin setTitle:@"文字评论" forState:UIControlStateNormal];
    [_yuYin setTitleColor:mainPageTitle forState:UIControlStateNormal];
    [_yuYin setTitleColor:VideoUserName forState:UIControlStateSelected];
    [_navView addSubview:_yuYin];
    [_yuYin addTarget:self
               action:@selector(scrollToAttrsView)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self scrollToDetailView];
    _lineLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 2)];
    [self.view addSubview:_lineLable];
    _lineLable.backgroundColor=VideoMainPageBack;
    
    // 加collectionView
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(KScreenWidth,KScreenHeight-66);
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                         66,
                                                                         KScreenWidth,
                                                                         KScreenHeight-66)
                                         collectionViewLayout:flowLayout];
    // 注册2个单元格
    
    [_collectionView registerClass:[MoreYuYingCell class]
        forCellWithReuseIdentifier:detailCellIdentifier];
    
    [_collectionView registerClass:[MorePingLunCell class]
        forCellWithReuseIdentifier:attrsCellIdentifier];
    
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor =[UIColor blackColor] ;
    
    //        _collectionView.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_collectionView];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    _collectionView.backgroundColor =[UIColor whiteColor] ;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.item==0) {
        
        MorePingLunCell *pingLunscell = [collectionView dequeueReusableCellWithReuseIdentifier:attrsCellIdentifier forIndexPath:indexPath];
        
        
        pingLunscell.textVid=_myVid;
        
      
        
        cell=pingLunscell;
        
    }else if (indexPath.item==1) {
        MoreYuYingCell *attrscell = [collectionView dequeueReusableCellWithReuseIdentifier:detailCellIdentifier forIndexPath:indexPath];
        
        
        attrscell.voiceVid=_myVid;
        attrscell.callBackVoice=^(ReMenVoice *voicePlay){
          
            if (_audioStream) {
                
                if([_audioStream isPlaying]){
                    
                    [_audioStream stop];
                    
                }}
            
            [self playNetworkMusic:[NSURL URLWithString:voicePlay.content]];
            
            [_audioStream play];
            
        };
        
        
        cell=attrscell;
        
    }
    return cell;
}







// 播放网络音频
- (void)playNetworkMusic:(NSURL *)url
{
    
    // 创建FSAudioStream对象
    _audioStream=[[FSAudioStream alloc]initWithUrl:url];
    _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
        NSLog(@"播放过程中发生错误，错误信息：%@",description);
    };
    
    
    // 设置声音
    [_audioStream setVolume:1];
    
}














#pragma mark - 事件处理
- (void)scrollToDetailView{
    // collectionview 向左滑动
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self refreshNavViewByIndex:1];
    _wenZi.selected=YES;
    _yuYin.selected=NO;
}

- (void)scrollToAttrsView {
    // collectionview 向右滑动
    
    [self.collectionView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
    [self refreshNavViewByIndex:0];
    _wenZi.selected=NO;
    _yuYin.selected=YES;
    
    
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
        _wenZi.selected=YES;
        _yuYin.selected=NO;
    } else if (index == 1) {
        _wenZi.selected=NO;
        _yuYin.selected=YES;
    }}





-(void)getBack{
    
    if (_audioStream) {
        
        if([_audioStream isPlaying]){
            
            [_audioStream stop];
            
        }}
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


-(void)setMyVid:(NSString *)myVid{
    _myVid=myVid;
}



@end
