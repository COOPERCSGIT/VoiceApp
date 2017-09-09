//
//  ReMenCell.m
//  VideoApp
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//
#import "ReMenCell.h"
#import "ReMenPingLunView.h"
#import "ReMenModel.h"
#import "ReMenUser.h"
#import "ReMenVoice.h"
#import "UIImageView+ASGif.h"
#import "AppDelegate.h"
#import "MyGuanZhuViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ReMenCell()<UINavigationControllerDelegate>
{
    int pause;
    int end;
    int play;
}

@end
@implementation ReMenCell


- (void)awakeFromNib {
    [super awakeFromNib];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    _newReMenData = [[NewReMenModel alloc] init];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight*0.075+4)];
        _headView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_headView];
        _lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        _lineLabel.backgroundColor=VideoMainPageBack;
        [_headView addSubview:_lineLabel];
        _iconButton=[[UIButton alloc]initWithFrame:CGRectMake(23, 8, KScreenHeight*0.075-10-2, KScreenHeight*0.075-10-2)];
        [_iconButton setImage:[UIImage imageNamed:@"icon2.jpeg"] forState:UIControlStateNormal];
        CALayer *layer = _iconButton.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:KScreenHeight*0.0375-6];
        [_headView addSubview:_iconButton];
        [_iconButton addTarget:self action:@selector(iconAction) forControlEvents:UIControlEventTouchUpInside];
        _nameLabel=[UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColor.blackColor numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        [_headView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconButton.mas_right).offset(9);
            make.centerY.equalTo(_iconButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(150, 14));
        }];
        
//        _nameLabel.text=@"米凡国际";
        _guanZhuButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 75, KScreenHeight * 0.0375 - 12, 43*1.44, 16*1.8)];
        [_guanZhuButton addTarget:self action:@selector(guanZhuAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_guanZhuButton];
        _pictures=[[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.075+4, KScreenWidth, KScreenHeight*0.3448)];
        _pictures.contentMode = UIViewContentModeScaleAspectFill;
        [_pictures setClipsToBounds:YES];
        _pictures.userInteractionEnabled = YES;//打开用户交互
        [self addSubview:_pictures];
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        //为图片添加手势
        [_pictures addGestureRecognizer:singleTap];
        _voiceName=[UILabel labelWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentCenter];
        [_pictures addSubview:_voiceName];
        [_voiceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pictures.mas_centerY).offset(-18);
            make.centerX.equalTo(_pictures.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, 15));
        }];
//        _voiceName.text=@"我的声音";
        _voiceTime=[UILabel labelWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentCenter];
        [_pictures addSubview:_voiceTime];
        [_voiceTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pictures.mas_centerY).offset(7);
            make.centerX.equalTo(_pictures.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, 12));
        }];
        _playBtn=[[UIImageView alloc]init];
        [_pictures addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pictures.mas_centerY).offset(6);
            make.centerX.equalTo(_pictures.mas_centerX).offset(-30);
            make.size.mas_equalTo(CGSizeMake(12,12));
        }];
        [_playBtn showGifImageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"i_disc2" ofType:@"gif"]]];
        _playBtn.hidden=YES;
        pause = 0;
        end = 0;
        play = 0;
        _middleView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.4198+4, KScreenWidth,KScreenHeight*0.0525)];
        [self addSubview:_middleView];
        _middleView.backgroundColor=[UIColor whiteColor];
        _seePicture=[[UIImageView alloc]initWithFrame:CGRectMake(20, KScreenHeight*0.0525/2-5, 15, 10)];
//        [_middleView addSubview:_seePicture];
        _seePicture.image=[UIImage imageNamed:@"Hot_icon_Browse_17x17@2x"];
        _seeNumber=[UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:mainPageTitle numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        _seeNumber.frame=CGRectMake(40, KScreenHeight*0.0525/2-6, 100, 11);
//        _seeNumber.text=@"11390";
//        [_middleView addSubview:_seeNumber];
        _pingLuButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-KScreenHeight*0.0525-15, 0, KScreenHeight*0.0525, KScreenHeight*0.0525)];
        [_pingLuButton setImage:[UIImage imageNamed:@"Hot_btn_more_30x30@2x"] forState:UIControlStateNormal];
        [_middleView addSubview:_pingLuButton];
        [_pingLuButton addTarget:self action:@selector(pingLunAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setReMenData:(ReMenModel *)reMenData{
    _reMenData=reMenData;
    _voiceName.text=_reMenData.title;
    _nameLabel.text=_reMenData.user.nickname;
    [_iconButton setImageWithURL:[NSURL URLWithString:_reMenData.user.headpic] forState:UIControlStateNormal];
    if(reMenData.backgrunds.count > 0)
    {
        [_pictures setImageWithURL:[NSURL URLWithString:[_reMenData.backgrunds objectAtIndex:0]]];
    }
    else{
        [_pictures setImageWithURL:[NSURL URLWithString:nil]];
    }
    
        _seeNumber.text =_reMenData.play_num;
    //    NSInteger minutes = _reMenData.length / 60;
    //    NSInteger seconds =_reMenData.length % 60;
        _voiceTime.text = [NSString stringWithFormat:@"共有%lu段声音",(unsigned long)_reMenData.backgrunds.count];
        NSInteger txt_comment=_reMenData.comment_t.count;
        NSInteger voice_comment=_reMenData.comment_c.count;
        
        if (txt_comment == 0 && voice_comment < 0) {
        }
        if (txt_comment ==1 && voice_comment < 2) {
            _pinLunView=[[ReMenPingLunView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.4723+4, KScreenWidth, KScreenHeight*0.14)];
            _pinLunView.detailPinLun=_reMenData;
            _pinLunView.cellNumber=1;
            _pinLunView.morePinLunIs=0;
            [self addSubview:_pinLunView];
        }
        if (txt_comment<2 && voice_comment==1) {
            _pinLunView=[[ReMenPingLunView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.4723+4, KScreenWidth, KScreenHeight*0.14)];
            _pinLunView.detailPinLun=_reMenData;
            _pinLunView.cellNumber=1;
            _pinLunView.morePinLunIs=0;
            [self addSubview:_pinLunView];
        }
        // 两个评论
        if (txt_comment==2 && voice_comment<3) {
            _pinLunView=[[ReMenPingLunView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.4723+4, KScreenWidth, KScreenHeight*0.21)];
            _pinLunView.detailPinLun=_reMenData;
            _pinLunView.cellNumber=2;
             _pinLunView.morePinLunIs=0;
            [self addSubview:_pinLunView];
        }
        if (txt_comment<3 && voice_comment==2) {
            _pinLunView=[[ReMenPingLunView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.4723+4, KScreenWidth, KScreenHeight*0.21)];
            _pinLunView.detailPinLun=_reMenData;
             _pinLunView.cellNumber=2;
             _pinLunView.morePinLunIs=0;
            [self addSubview:_pinLunView];
        }
        // 3个及以上评论
        if (txt_comment>2 || voice_comment>2) {
            _pinLunView=[[ReMenPingLunView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.4723+4, KScreenWidth, KScreenHeight*0.28)];
            _pinLunView.detailPinLun=_reMenData;
            _pinLunView.cellNumber=2;
            _pinLunView.morePinLunIs=1;
            [self addSubview:_pinLunView];
        }
       WeakSelf;
       _pinLunView.callBackPinLunMore1=^(NSInteger index){
           [weakSelf stopMusic];
            !weakSelf.callBackPinLunMore ? : weakSelf.callBackPinLunMore(weakSelf.cellIndex);
        };
      _pinLunView.callBackIconTouch=^(NSString *text){
          [weakSelf stopMusic];
          NSMutableArray *data=[[NSMutableArray alloc]init];
          NSString *index=[NSString stringWithFormat:@"%ld",(long)weakSelf.cellIndex];
          [data addObject:index];
          [data addObject:text];
        !weakSelf.callBackUserCenterIcon ? : weakSelf.callBackUserCenterIcon(data);
    };
        _pinLunView.callBackVoiceCommentPlay2=^(ReMenVoice *voice){
            NSLog(@"%@",voice.content);
            NSLog(@"点击了收听评论");
            NSString *music=[[NSUserDefaults standardUserDefaults]objectForKey:@"nowCommentMusic"];
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (music.length){
                if ([music isEqualToString:voice.content]) {
                    if (tempAppDelegate.audioStream) {
                        if([tempAppDelegate.audioStream isPlaying]){
                            [weakSelf stopMusic];
                        }else{
                            [weakSelf playNetworkMusic:[NSURL URLWithString:voice.content]];
                        }}
                }else{
                    [weakSelf stopMusic];
                    [weakSelf playNetworkMusic:[NSURL URLWithString:voice.content]];
                }}else{
                    [weakSelf stopMusic];
                    [weakSelf playNetworkMusic:[NSURL URLWithString:voice.content]];
                }
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",voice.content] forKey:@"nowCommentMusic"];
    };
    NSInteger is_focus=_reMenData.is_focus;
    if (is_focus==0) {
        [_guanZhuButton setImage:[UIImage imageNamed:@"guanzhuuu"] forState:UIControlStateNormal];
        _guanZhuButton.enabled=YES;
    }else if (is_focus==1){
        [_guanZhuButton setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
        _guanZhuButton.enabled=YES;
    }
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    if ([_reMenData.user.uid isEqualToString:myUID]) {
        _guanZhuButton.hidden=YES;
    }
}
// 播放网络音频
- (void)playNetworkMusic:(NSURL *)url
{
    // 创建FSAudioStream对象
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.audioStream playFromURL:url];
    tempAppDelegate.audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
        NSLog(@"播放过程中发生错误，错误信息：%@",description);
    };
    // 设置声音
    [tempAppDelegate.audioStream setVolume:1];
    [tempAppDelegate.audioStream play];
    
}
#pragma mark - 点击事件
-(void)pingLunAction{
    
    [self stopMusic];
     !self.callBackPinLun ? : self.callBackPinLun(_cellIndex);
}
-(void)iconAction{
    [self stopMusic];
    !self.callBackUserCenter ? : self.callBackUserCenter(_cellIndex);

}
#pragma mark - 懒加载
- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}


//
//2017.5.11 21:50    修改关注状态信息
//
-(void)guanZhuAction{
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_reMenData.user.uid];
    NSString *typeData=[voiceguanzhu stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
        [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)   {
            NSString *str=[responseObject objectForKey:@"res"];
            if ([str isEqualToString:@"0"])
            {
                [_guanZhuButton setImage:[UIImage imageNamed:@"guanzhuuu"] forState:UIControlStateNormal];
                !self.callBackRefresh ? : self.callBackRefresh();
            }
            else
            {
                [_guanZhuButton setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
                //self.guanZhuButton.enabled = NO;
                !self.callBackGuanZhu ? : self.callBackGuanZhu(_reMenData.user.uid);
                !self.callBackRefresh ? : self.callBackRefresh();
            }
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}
-(void)stopMusic{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.audioStream) {
        if([tempAppDelegate.audioStream isPlaying]){
            [tempAppDelegate.audioStream stop];
            _playBtn.hidden=YES;
        }}
}
-(void)pauseMusic{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.audioStream) {
        if([tempAppDelegate.audioStream isPlaying]){
            [tempAppDelegate.audioStream pause];
            _playBtn.hidden=YES;
        }}
}
-(void)continueMusic{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(tempAppDelegate.audioStream){
        [tempAppDelegate.audioStream play];
        NSLog(@"play");
    }
}

//
//change2 2017 修改播放操作
//
//success
-(void)singleTapAction{
    
    
    if (self.callBackTapToShowDetail) {
        NSLog(@"点了一下 在cell里");
        self.callBackTapToShowDetail(_cellIndex);
        
//        self.updateData(_itemsSectionPictureArray,_Mp3Array,_Mp3TimeArray);
    }    
}

-(void)bofang{
//    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *channel=@"channel=APP";
//    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_reMenData.vid];
    NSString *typeData=[voicePlayNum stringByAppendingFormat:@"%@%@",channel,vid];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

-(void)setCallBackTapToShowDetail:(void (^)(NSInteger))callBackTapToShowDetail{
    _callBackTapToShowDetail = callBackTapToShowDetail;
}

-(void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex=cellIndex;
}
@end
