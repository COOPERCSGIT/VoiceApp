//
//  ReMenCollectionViewCell.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/5.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "ReMenCollectionViewCell.h"
#import "ReMenCell.h"
#import "ReMenModel.h"
#import "ReMenViewController.h"
#import "AppDelegate.h"
#import "ZTHeaderRefresh.h"
#import "lame.h"
#import "ReMenUser.h"
#import "MyPicturesViewController.h"
#import "MyGuanZhuViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation ReMenCollectionViewCell{
    NSString *allData;
    CGFloat cellHeight;
    UIButton *addButton;
    NSInteger page;
    NSInteger totalPage;
    NSInteger num;
    UIButton *voiceButton;
    CGFloat duration;
    UIView *voiceView;
    UIView *commentCoverView;
    UIView *disappearView;
    UIView * disappearView2;
    UIView *sendVoiceView;
    UIImageView *startRecord;
    UIButton *listenRecord;
    UIButton *stopRecord;
    UIButton *playVoice;
    UIButton *cancelVoice;
    UIButton *sendVoice;
    UILabel *timeLabel;
    UILabel *detailsLabel;
    NSInteger minutes;
    NSInteger seconds;
    NSString *messageTypes;
    NSString *messageContent;
    NSString *messageClength;
    NSString *voiceURL;
    NSString *userUID;
    NSString *myUID;
    NSString *shouCangType;
    NSString *shouCangType2;
    UIView *fenXiangView;
    NSString *shouCangURL;
}

static NSString *const ReMenCellIdentifier = @"ReMenCellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        [self setupMJRefreshHeader];
        [self addCommentsView];
        num=7;
    }
    
    return self;
}


//语音评论和文字评论
-(void)addCommentsView{
    // 阴影部分视图
    _TotalCommentView=[[UIView alloc]initWithFrame:CGRectMake(0,KScreenHeight*0.345, KScreenWidth, KScreenHeight)];
//    _TotalCommentView.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];
    [self.contentView addSubview:_TotalCommentView];
    _TotalCommentView.hidden=YES;
    
    disappearView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bounds.size.height-50)];
    disappearView.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];

    [_TotalCommentView addSubview:disappearView];
    
    disappearView2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenHeight*0.345)];
    disappearView2.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];
    [self.contentView addSubview:disappearView2];
    disappearView2.hidden=YES;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    [disappearView addGestureRecognizer:singleTap];
    disappearView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    [disappearView2 addGestureRecognizer:singleTap2];
    disappearView2.userInteractionEnabled=YES;
    
    
    _addCommentView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-114-KScreenHeight*0.345, KScreenWidth, 50)];
    _addCommentView.backgroundColor=CommentsViewColor;
    [_TotalCommentView addSubview:_addCommentView];
    
    
    // 录音部分视图
    // ????
    
    voiceView=[[UIView alloc]init];
    [_TotalCommentView addSubview:voiceView];
    voiceView.backgroundColor=VideoMainPageBack;
    [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addCommentView.mas_left);
        make.top.equalTo(_addCommentView.mas_bottom);
        make.right.equalTo(_addCommentView.mas_right);
        make.height.mas_equalTo(KScreenHeight*0.345);
    }];
    
    timeLabel=[UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:VideoUserName numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    [voiceView addSubview:timeLabel];
    timeLabel.text=@"00:00";
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voiceView.mas_centerX);
        make.top.equalTo(voiceView.mas_top).offset(KScreenHeight*0.05-5);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 12));
    }];
    
    playVoice=[[UIButton alloc]init];
    [voiceView addSubview:playVoice];
    [playVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voiceView.mas_centerX);
        make.top.equalTo(timeLabel.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [playVoice setImage:[UIImage imageNamed:@"1501"] forState:UIControlStateNormal];
    [playVoice setImage:[UIImage imageNamed:@"1502"] forState:UIControlStateSelected];
    [playVoice addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    
    startRecord=[[UIImageView alloc]init];
    [voiceView addSubview:startRecord];
    [startRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voiceView.mas_centerX);
        make.top.equalTo(timeLabel.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    startRecord.image=[UIImage imageNamed:@"Re_btn_re_70x70@2x"];
    startRecord.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(TableviewCellLongPressed:)];
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    [startRecord addGestureRecognizer:longPress];
    
    
    _rotateImgView = [[UIImageView alloc]init];
    _rotateImgView.image = [UIImage imageNamed:@"rcirle_norm"];
    [voiceView addSubview:self.rotateImgView];
    [_rotateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voiceView.mas_centerX);
        make.top.equalTo(timeLabel.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];

    
    detailsLabel=[UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColor.blackColor numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    [voiceView addSubview:detailsLabel];
    detailsLabel.text=@"按住说话 最短5s";
    [detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voiceView.mas_centerX);
        make.top.equalTo(startRecord.mas_bottom).offset(13);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 12));
    }];
    
    
    sendVoiceView=[[UIView alloc]initWithFrame:CGRectMake(0,  KScreenHeight*0.345-40, KScreenWidth,40)];
    sendVoiceView.backgroundColor=[UIColor whiteColor];
    [voiceView addSubview:sendVoiceView];
    sendVoiceView.hidden=YES;
    
    
    sendVoice=[UIButton buttonWithBackgroundColor:[UIColor whiteColor] title:@"发送" titleLabelFont:[UIFont systemFontOfSize:13] titleColor:addCommentsText target:self action:@selector(addCommentAction)];
    [sendVoiceView addSubview:sendVoice];
    sendVoice.frame=CGRectMake(KScreenWidth/2, 0, KScreenWidth/2, 40);
    
    cancelVoice=[UIButton buttonWithBackgroundColor:[UIColor whiteColor] title:@"取消" titleLabelFont:[UIFont systemFontOfSize:13] titleColor:addCommentsText target:self action:@selector(cancelMyVoice)];
    [sendVoiceView addSubview:cancelVoice];
    cancelVoice.frame=CGRectMake(0, 0, KScreenWidth/2, 40);
    
    // 文字部分视图
    
    addButton=[UIButton buttonWithBackgroundColor:[UIColor whiteColor] title:@"发送" titleLabelFont:[UIFont systemFontOfSize:12] titleColor:addCommentsText target:self action:@selector(addCommentAction)];
    addButton.frame=CGRectMake(KScreenWidth-72, 7.5, 60, 35);
    CALayer *layer = addButton.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:6];
    [_addCommentView addSubview:addButton];
    
    
    voiceButton=[UIButton buttonWithBackgroundColor:nil title:nil titleLabelFont:nil titleColor:nil target:self action:@selector(voiceAction)];
    voiceButton.frame=CGRectMake(15,11, 20, 28);
    [voiceButton setImage:[UIImage imageNamed:@"100"] forState:UIControlStateNormal];
    [_addCommentView addSubview:voiceButton];
    
    
    
    _textfield=[[UITextView alloc]init];
    _textfield.backgroundColor=[UIColor whiteColor];
    _textfield.textColor = UIColor.blackColor;
    _textfield.font=[UIFont systemFontOfSize:15];
    [_addCommentView addSubview:_textfield];
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(voiceButton.mas_right).offset(20);
        make.top.equalTo(_addCommentView.mas_top).offset(7.5);
        make.bottom.equalTo(_addCommentView.mas_bottom).offset(-7.5);
        make.right.equalTo(addButton.mas_left).offset(-12);
    }];
    CALayer *layer1 = _textfield.layer;
    [layer1 setMasksToBounds:YES];
    [layer1 setCornerRadius:6];
    
    //设置返回键的样式
    _textfield.returnKeyType = UIReturnKeySend;
    _textfield.delegate=self;
   
    
    
    
    commentCoverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    commentCoverView.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];
    [_addCommentView addSubview:commentCoverView];
    commentCoverView.hidden=YES;
    
    
    self.cafPathStr = [kSandboxPathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",kCafFileName]];
    self.mp3PathStr =  [kSandboxPathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",kCafFileName]];
    
    
    
}
-(void)cancelMyVoice{
    //2.停止
    if ([_player isPlaying]) {
        [_player stop];
    }
    startRecord.hidden=NO;
    playVoice.selected=NO;
    timeLabel.text=@"00:00";
    seconds=0;
    minutes=0;
    _countNum=0;
    sendVoiceView.hidden=YES;
    [_timer invalidate];
    self.rotateImgView.hidden=NO;
    detailsLabel.text=@"按住说话 最短5s";
}
-(void)voiceAction{
    commentCoverView.hidden=NO;
    self.textfield.text = nil;
    [_textfield resignFirstResponder];
   _TotalCommentView.frame=self.bounds;
    disappearView2.hidden=YES;
}
-(void)playOrPause:(UIButton *)btn{
    btn.selected=!btn.selected;
    if  ([self.player isPlaying]){
        [self pauseMusic];
    }         else{
        [self playRecord];
    }
//    if(![self.player isPlaying] &&playFlag){
//        [self continueMusic];
//        [self playRecord];}

}
#pragma mark - 播放
- (void)playRecord
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [self playMusicWithUrl:[NSURL URLWithString:self.cafPathStr]];
//    playFlag = true;
   
}

/**
 *播放音乐文件
 */
- (BOOL)playMusicWithUrl:(NSURL *)fileUrl
{
    //其他播放器停止播放
    if (!fileUrl) return NO;
    
    //    AVAudioSession *session=[AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    //    [session setActive:YES error:nil];
    if (!_player) {
        //2.2创建播放器
        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
    }
    _player.delegate = self;
    
    if (![_player prepareToPlay]){
        NSLog(@"缓冲失败--");
        return NO;
    }
    [_player play];
    return YES;//正在播放，那么就返回YES
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"delegate--播放完毕----------------------");
    playVoice.selected=NO;
}

- (void)pauseMusic{
    //2.暂停
    if ([_player isPlaying]) {
        [_player pause];
    }
}
#pragma mark - 长按事件的实现方法
-(void)TableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state ==  UIGestureRecognizerStateBegan) {
        NSLog(@"开始录音");
        [self startRecordNotice];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {

    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self stopRecordNotice];
    }
}

-(void)recordBtnDidTouchDown{
    [self startRecordNotice];
}
// 执行动画
- (void)starAnimalWithTime:(CFTimeInterval)time
{
    self.rotateImgView.image = [UIImage imageNamed:@"rcirle_high"];
    
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    self.rotationAnimation.duration = time;
    self.rotationAnimation.cumulative = YES;
    self.rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.rotateImgView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}
-(void)startTimersAction{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    
}

#pragma mark - 录音方法
- (void)startRecordNotice{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    NSLog(@"----------开始录音----------");
    [self deleteOldRecordFile];
    //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    NSError *sessionError;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(audioSession == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else{
        [audioSession setActive:YES error:nil];
    }
    if (![self.audioRecorder isRecording]) {//0--停止、暂停，1-录制中
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        [self startTimersAction];
        [_timer setFireDate:[NSDate date]];
    }
    [self starAnimalWithTime:2.0];
}
#pragma mark - 结束录音
- (void)stopRecordNotice{
    NSLog(@"----------结束录音----------");
    //计算文件大小

    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [self.audioRecorder stop];

    [self audio_PCMtoMP3];
    long long fileSize = [self fileSizeAtPath:self.cafPathStr]/1024.0;
    NSString *fileSizeStr = [NSString stringWithFormat:@"%lld",fileSize];
    NSLog(@" fileSizeStr : %@ kb",fileSizeStr);
    
    
    //停止旋转动画
    [self.rotateImgView.layer removeAllAnimations];
    
    self.rotateImgView.image = [UIImage imageNamed:@"rcirle_norm"];
    
    
    if (_countNum < 5 || _countNum>60) {
        

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录音时间不符合要求" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.mainNavigationController presentViewController:alert animated:YES completion:nil];

        timeLabel.text = @"00:00";
        seconds = 0;
        minutes = 0;
        _countNum=0;
        [_timer invalidate];
        
    } else {
        [_timer invalidate];
        seconds = 0;
        minutes = 0;
        
        self.rotateImgView.hidden=YES;
        startRecord.hidden=YES;
        detailsLabel.text=@"试听";
       sendVoiceView.hidden=NO;
    }}




#pragma mark - 删除旧文件 上次录音剩的
-(void)deleteOldRecordFile{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:self.cafPathStr];
    if (!blHave) {
        NSLog(@"不存在");
        return ;
    }else {
        NSLog(@"存在");
        BOOL blDele= [fileManager removeItemAtPath:self.cafPathStr error:nil];
        NSLog(@"%@",self.cafPathStr);
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
-(void)deleteOldRecordFileAtPath:(NSString *)pathStr{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:pathStr];
    if (!blHave) {
        NSLog(@"不存在");
        return ;
    }else {
        NSLog(@"存在");
        BOOL blDele= [fileManager removeItemAtPath:self.cafPathStr error:nil];
        [fileManager removeItemAtPath:[kSandboxPathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",kCafFileName]] error:nil];

        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}



#pragma mark - caf转mp3
- (void)audio_PCMtoMP3
{
    @try {
        int read, write;
        FILE *pcm = fopen([self.cafPathStr cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([self.mp3PathStr cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",self.mp3PathStr);
    }
}

#pragma mark -  Getter
/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSLog(@"初始化Rcorder");
        //创建录音文件保存路径
        NSURL *url=[NSURL URLWithString:self.cafPathStr];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting
{
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return recordSettings;
}
#pragma mark - 文件转换
// 二进制文件转为base64的字符串
- (NSString *)Base64StrWithMp3Data:(NSData *)data{
    if (!data) {
        NSLog(@"Mp3Data 不能为空");
        return nil;
    }
    //    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return str;
}
// base64的字符串转化为二进制文件
- (NSData *)Mp3DataWithBase64Str:(NSString *)str{
    if (str.length ==0) {
        NSLog(@"Mp3DataWithBase64Str:Base64Str 不能为空");
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSLog(@"Mp3DataWithBase64Str:转换成功");
    return data;
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }else{
        NSLog(@"计算文件大小：文件不存在");
    }
    
    return 0;
}
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
#pragma mark - 录音时间显示
-(void)startTimer{
    _countNum++;
    seconds++;
    if (seconds == 60) {
        minutes++;
        seconds = 0;
    }
    //    让不断变量的时间数据进行显示到label上面。
    timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
}
#pragma mark - popKeyBoard Will Show
-(void)popKeyBoard:(NSNotification *)noti{
    disappearView2.hidden=YES;
    NSDictionary *info = [noti userInfo];
    duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    CGRect inputFieldRect = self.TotalCommentView.frame;
    CGRect moreBtnRect = self.tableView.frame;
    
    inputFieldRect.origin.y += yOffset;
    moreBtnRect.origin.y += yOffset;
    //做动画，让键盘出现时，表视图和工具视图一起飞
    [UIView animateWithDuration:duration animations:^{
        self.TotalCommentView.frame = inputFieldRect;
        self.tableView.frame = moreBtnRect;
    }];
    
  
}







#pragma mark 初始化刷新控件
- (void)setupMJRefreshHeader {
    self.tableView.mj_header=[ZTHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector (LoadMoreData)];
}

-(void)LoadNewData{
    [self.tableView.mj_footer endRefreshing];
    page=1;
    NSString *channel=@"channel=APP";
//    NSString *uid=@"&uid=5LIs5OWEdaz4";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",_pageUID];
    NSString *is_uDetail=[NSString stringWithFormat:@"&is_u=%ld",(long)_is_u];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_myCid];
    NSString *pageNow=[NSString stringWithFormat:@"&page=%ld",(long)page];
    NSString *number=[NSString stringWithFormat:@"&num=%ld",(long)num];
    allData=[voiceAllData stringByAppendingFormat:@"%@%@%@%@%@%@%@",_DataType,channel,uid,is_uDetail,cid,pageNow,number];
    NSLog(@"%@", allData);
    [self.mananger GET:allData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *reArray=responseObject;
            self.moreDataArray=[ReMenModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (self.voiceArray.count>0) {
                [self.voiceArray removeAllObjects];
            }
            for (ReMenModel *model in self.moreDataArray) {
                [self.voiceArray addObject:model];
            }
           [self Filter];
           [self.tableView reloadData];
           [self.tableView.mj_header endRefreshing];
        if (reArray.count>0) {
            self.tableView.mj_footer.hidden = NO;
        }else{
            self.tableView.mj_footer.hidden=YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
//加载新内容
-(void)LoadMoreData{
    [self.tableView.mj_header endRefreshing];
    page++;
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",_pageUID];
    NSString *is_uDetail=[NSString stringWithFormat:@"&is_u=%ld",(long)_is_u];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",_myCid];
    NSString *pageNow=[NSString stringWithFormat:@"&page=%ld",(long)page];
    NSString *number=[NSString stringWithFormat:@"&num=%ld",(long)num];
    allData=[voiceAllData stringByAppendingFormat:@"%@%@%@%@%@%@%@",_DataType,channel,uid,is_uDetail,cid,pageNow,number];
    [self.mananger GET:allData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *reArray=responseObject;
//        NSLog(@"%@",responseObject);
        if (reArray.count>0) {
            self.moreDataArray=[ReMenModel mj_objectArrayWithKeyValuesArray:responseObject];
            for (ReMenModel *model in self.moreDataArray) {
                [self.voiceArray addObject:model];
            }
            
            [self Filter];
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else{
       [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = YES;
        page--;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)Filter{
    for(int i = 0;i<_voiceArray.count;i++){
        NSArray * a = [((ReMenModel*)[_voiceArray objectAtIndex:i]).backgrund componentsSeparatedByString:@"/image/"];
        NSArray * b = [((ReMenModel*)[_voiceArray objectAtIndex:i]).reurl componentsSeparatedByString:@"/file/"];
        NSMutableArray* aa = [[NSMutableArray alloc] init];
        NSMutableArray* bb = [[NSMutableArray alloc] init];
        for(int i = 1; i < a.count;i++){
            [aa setObject:[NSString stringWithFormat:@"%@/image/%@",a[0],a[i]] atIndexedSubscript:i-1];
            [bb setObject:[NSString stringWithFormat:@"%@/file/%@",b[0],b[i]]     atIndexedSubscript:i-1];
        }
        ((ReMenModel*)[_voiceArray objectAtIndex:i]).backgrunds = aa ;
        ((ReMenModel*)[_voiceArray objectAtIndex:i]).reurls = bb;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voiceArray.count;
}
//-(void)setCallBackNewView:(void (^)(NSMutableArray *, NSMutableArray *))callBackNewView{
//    _callBackNewView = callBackNewView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!_cell ) {
        _cell = [[ReMenCell alloc ]
                initWithStyle : UITableViewCellStyleDefault
                reuseIdentifier :ReMenCellIdentifier];
    }
    _cell.reMenData=self.voiceArray[indexPath.row];
    _cell.cellIndex=indexPath.row;
    
    WeakSelf;
    
    _cell.callBackPinLun=^(NSInteger index){
    _reMen=self.voiceArray[index];
    [weakSelf pingLun];
    };
    
    _cell.callBackPinLunMore=^(NSInteger index2){
        _reMen=self.voiceArray[index2];
        !weakSelf.callBackPinLun2 ? : weakSelf.callBackPinLun2(weakSelf.reMen.vid);
    };
    
    
    _cell.callBackUserCenter=^(NSInteger index1){
        _reMen=self.voiceArray[index1];
        NSLog(@"%@",weakSelf.callBackUserCenter2);
        !weakSelf.callBackUserCenter2 ? : weakSelf.callBackUserCenter2(weakSelf.reMen);
    };
    
    _cell.callBackTapToShowDetail=^(NSInteger index){
        NSLog(@"点了一下 在%ld",(long)index);
        _reMen=self.voiceArray[index];
        !weakSelf.callBackNewView ? : weakSelf.callBackNewView(weakSelf.reMen);
    };
    
    
    _cell.callBackUserCenterIcon=^(NSMutableArray *array ){
        MyGuanZhuViewController *guanzhu=[[MyGuanZhuViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:guanzhu];
        int intString = [array[0] intValue];
        guanzhu.userUID=array[1];
        _reMen=self.voiceArray[intString];
        guanzhu.guanzhuNum=weakSelf.reMen.is_focus;
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController presentViewController:nav animated:YES completion:nil];
    };
    
    _cell.callBackGuanZhu=^(NSString *userUid){
        userUID=userUid;
        [weakSelf guanzhuAction];
    };
    
 
    
    
    _cell.callBackPlay=^(NSInteger index4){

        
        if (index4==0 && self.voiceArray.count==1) {
        }else
           if(index4==0 && self.voiceArray.count>1){
            NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:index4+1 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else if (index4==self.voiceArray.count-1){
            
            NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:index4-1 inSection:0];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else if (index4>0 && index4 < self.voiceArray.count-1){
            NSIndexPath *indexPath4=[NSIndexPath indexPathForRow:index4+1 inSection:0];
            NSIndexPath *indexPath5=[NSIndexPath indexPathForRow:index4-1 inSection:0];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath4,nil] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath5,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (index4==0 && self.voiceArray.count==1) {
            
        }else{
        dispatch_async(dispatch_get_main_queue(), ^{
             //刷新完成
            weakSelf.cell.playBtn.hidden=YES;
        });
        }
    };
     
   
    return _cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ReMenModel *reMen=self.voiceArray[indexPath.row];
    
    return reMen.cellHeight;
   
    
}
#pragma mark - 评论点击事件
-(void)pingLun{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    //上拉菜单 评论 收藏 分享 查看图片 拉黑举报
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *pingLunAction = [UIAlertAction actionWithTitle:@"评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _TotalCommentView.hidden=NO;
        disappearView2.hidden=NO;
        startRecord.hidden=NO;
        self.textfield.text = nil;
        timeLabel.text=@"00:00";
        seconds=0;
        minutes=0;
        sendVoiceView.hidden=YES;
        detailsLabel.text=@"按住说话 最短5s";
        !self.callBackPinLun1 ? : self.callBackPinLun1();
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
        
    }];
    
    UIAlertAction *shouCangAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !self.callBackPinLun1 ? : self.callBackPinLun1();
        [self addFenXiangView];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
    [tempAppDelegate.mainNavigationController presentViewController:alert animated:YES completion:nil];
      
        
    }];
    
    
    
    
    NSString *deleteShouCang=[[NSUserDefaults standardUserDefaults]objectForKey:@"DeleteShouCang"];
    
    if([deleteShouCang isEqualToString:@"0"]){
        shouCangType=@"收藏";
        shouCangType2=@"收藏成功";
    }else{
        shouCangType=@"取消收藏";
        shouCangType2=@"取消收藏成功";
    }
    
    
    UIAlertAction *fenXiangAction = [UIAlertAction actionWithTitle:shouCangType style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self chouCangVoice];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:pingLunAction];
    [alertController addAction:fenXiangAction];
    [alertController addAction:shouCangAction];
//    [alertController addAction:picturesAction];
    
    
    if([_reMen.user.uid isEqualToString:myUID]){
        [alertController addAction:deleteAction];
    }else{
    }
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.mainNavigationController presentViewController:alertController animated:YES completion:nil];
}
-(void)alertAction:(NSString *)message{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.mainNavigationController presentViewController:alert animated:YES completion:nil];

    
}
#pragma mark - 删除数据
-(void)deleteData{
    
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_reMen.vid];

    NSString *typeData=[voicedelVoice stringByAppendingFormat:@"%@%@%@",channel,uid,vid];
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        num=self.voiceArray.count;
        
        [self LoadNewData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}
-(void)addFenXiangView{
    
    fenXiangView=[[UIView alloc]initWithFrame:self.bounds];
    fenXiangView.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];
    [self addSubview:fenXiangView];
    
    UIView *addView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-KScreenHeight*0.3-64, KScreenWidth,KScreenHeight*0.3)];
    addView.backgroundColor=[UIColor whiteColor];
    [fenXiangView addSubview:addView];
    
    
    UIButton *weixinFri=[[UIButton alloc]init];
    [addView addSubview:weixinFri];
    [weixinFri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addView.mas_left).offset(KScreenWidth/5);
        make.centerY.equalTo(addView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [weixinFri setImage:[UIImage imageNamed:@"pyq"] forState:UIControlStateNormal];
    [weixinFri addTarget:self action:@selector(weixinFriShare) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *weixin=[[UIButton alloc]init];
    [addView addSubview:weixin];
    [weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addView.mas_left).offset(KScreenWidth/5*2);
        make.centerY.equalTo(addView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [weixin setImage:[UIImage imageNamed:@"wechat_60x60@2x"] forState:UIControlStateNormal];
    [weixin addTarget:self action:@selector(weixinShare) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *qq=[[UIButton alloc]init];
    [addView addSubview:qq];
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addView.mas_left).offset(KScreenWidth/5*3);
        make.centerY.equalTo(addView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [qq setImage:[UIImage imageNamed:@"QQ_60x60@2x"] forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(qqShare) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *weibo=[[UIButton alloc]init];
    [addView addSubview:weibo];
    [weibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addView.mas_left).offset(KScreenWidth/5*4);
        make.centerY.equalTo(addView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [weibo setImage:[UIImage imageNamed:@"sina_52x52@2x"] forState:UIControlStateNormal];
    [weibo addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *close=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-55, 15, 35, 35)];
    [addView addSubview:close];
    [close setImage:[UIImage imageNamed:@"Re_btn_close_24x24@2x"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
}
-(void)weixinFriShare{
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title=_reMen.title;
    msg.mediaDataUrl=_reMen.reurl;
    msg.link=@"";
    msg.desc=@"请倾听它的声音";
    UIImage *getimage2 = [UIImage imageNamed:@"tubiao"];
    NSData *data=UIImageJPEGRepresentation(getimage2, 0.1);
    msg.thumbnail=data;
    msg.multimediaType=OSMultimediaTypeAudio;
    [OpenShare shareToWeixinTimeline :msg Success:^(OSMessage *message) {
        
    } Fail:^(OSMessage *message, NSError *error) {
        
    }];
    !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
    [fenXiangView removeFromSuperview];
    
}
-(void)weixinShare{
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:_reMen.backgrund]];
    
        OSMessage *msg=[[OSMessage alloc]init];
        msg.title=_reMen.title;
    
        msg.mediaDataUrl=_reMen.reurl;
        msg.link=@"";
        msg.desc=@"请倾听它的声音";
        UIImage *getimage2 = [UIImage imageNamed:@"tubiao"];
        NSData *data=UIImageJPEGRepresentation(getimage2, 0.1);
  
        msg.thumbnail=data;
        msg.multimediaType=OSMultimediaTypeAudio;
    
        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
            
        } Fail:^(OSMessage *message, NSError *error) {
            
        }];
    !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
    [fenXiangView removeFromSuperview];
    
}
-(void)qqShare{
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:_reMen.backgrund]];
    
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title=_reMen.title;
    
    msg.link=_reMen.reurl;
    UIImage *getimage2 = [UIImage imageNamed:@"tubiao"];
    NSData *data=UIImageJPEGRepresentation(getimage2, 0.1);
    msg.image=data;

    msg.desc=[NSString stringWithFormat:@"请倾听它的声音"];
    msg.multimediaType=OSMultimediaTypeAudio;
    
    [OpenShare shareToQQFriends :msg  Success:^(OSMessage *message) {
        
        
    } Fail:^(OSMessage *message, NSError *error) {
        
    }];
    
    [fenXiangView removeFromSuperview];
     !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
}
-(void)weiboShare{
    
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title=[NSString stringWithFormat:@"请倾听它的声音%@",_reMen.reurl];
    
    [OpenShare shareToWeibo:msg  Success:^(OSMessage *message) {
        
        
    } Fail:^(OSMessage *message, NSError *error) {
        
    }];
     [fenXiangView removeFromSuperview];
     !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
}
-(void)closeAction{
    
    !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
    [fenXiangView removeFromSuperview];
}
#pragma mark - 加评论
-(void)addCommentAction{
    
    if (self.mp3PathStr.length>0 || self.textfield.text.length>0) {
 
    [self updateComment];
        
    [_textfield resignFirstResponder];
    [UIView animateWithDuration:duration animations:^{
            //CGAffineTransformIdentity保存了原先进行的动画的操作
            self.TotalCommentView.frame=CGRectMake(0,KScreenHeight*0.345, KScreenWidth, KScreenHeight);
            self.tableView.frame = self.bounds;
    }];
    self.TotalCommentView.hidden=YES;
    commentCoverView.hidden=YES;
    disappearView2.hidden=YES;
    self.rotateImgView.hidden=NO;
    !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];   
    }else{
        
    }
}
#pragma mark - 评论上传
-(void)updateComment{
    
   if (self.textfield.text.length>0) {
        [self updateMessage];
   }else{
       [self updateData];
   }
}
-(void)updateMessage{
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_reMen.vid];
    messageTypes=@"&type=0";
    NSString *content=[NSString stringWithFormat:@"&content=%@",_textfield.text];
    NSString *content1=[content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *typeData=[voiceAddComments stringByAppendingFormat:@"%@%@%@%@%@",channel,uid,vid,messageTypes,content1];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        num=self.voiceArray.count;
        
        [self LoadNewData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}
#pragma mark - 上传语音
-(void)updateVoice{
    
    if (_player) {
        if ([_player isPlaying]) {
            [_player stop];
        }
    }
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_reMen.vid];
    messageTypes=@"&type=1";
    NSString *content=[NSString stringWithFormat:@"&content=%@",voiceURL];
    NSString *clength=[NSString stringWithFormat:@"&clength=%ld",(long)_countNum];
    NSString *typeData=[voiceAddComments stringByAppendingFormat:@"%@%@%@%@%@%@",channel,uid,vid,messageTypes,content,clength];
    _countNum=0;
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        num=self.voiceArray.count;
        [self LoadNewData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)updateData{
    
    NSURL *mp3Url =  [NSURL fileURLWithPath:self.mp3PathStr];
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *uploadURL=[voiceUpLoadOSS stringByAppendingFormat:@"%@",uid];
    self.mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                               @"text/html",
                                                               @"image/jpeg",
                                                               @"image/png",
                                                               @"application/octet-stream",
                                                               @"text/json",
                                                               nil];
    
    [_mananger POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"正在上传");
        [formData appendPartWithFileURL:mp3Url name:@"video" fileName:@"myRecord.mp3" mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
        voiceURL=[[responseObject objectForKey:@"data"]objectForKey:@"video"];
        [self updateVoice];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@",error);
    }];
}
#pragma mark - 关注点击事件
-(void)guanzhuAction{
    NSLog(@"guanzhuAction");
//    !self.callBackGuanZhuYes ? : self.callBackGuanZhuYes();
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",userUID];
    NSString *typeData=[voiceguanzhu stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str=[responseObject objectForKey:@"res"];
        if ([str isEqualToString:@"1"]) {
            //已关注后不采取任何措施
            NSString *channel=@"channel=APP";
            NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
            NSString *cid=[NSString stringWithFormat:@"&cid=%@",userUID];
            NSString *typeData=[voiceguanzhu stringByAppendingFormat:@"%@%@%@",channel,uid,cid];
            [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
           !self.callBackRefresh ? : self.callBackRefresh();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
            num=self.voiceArray.count;
            [self LoadNewData];
    }else
        {
            [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                {
                    num=self.voiceArray.count;
                    [self LoadNewData];
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                        {
                                NSLog(@"%@",error);
                        }
             ];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)chouCangVoice{
    
    
    NSString *channel=@"channel=APP";
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *vid=[NSString stringWithFormat:@"&vid=%@",_reMen.vid];
    NSString *quxiao=@"&quxiao=3";
    NSString *deleteShouCang=[[NSUserDefaults standardUserDefaults]objectForKey:@"DeleteShouCang"];
    
    
    if([deleteShouCang isEqualToString:@"0"]){
        shouCangURL=[voiceShouCang stringByAppendingFormat:@"%@%@%@",channel,uid,vid];
        
        [self.mananger GET:shouCangURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self alertAction:shouCangType2];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
        }];
        
    }else{
       shouCangURL=[voiceShouCang stringByAppendingFormat:@"%@%@%@%@",channel,uid,vid,quxiao];
       [self.mananger GET:shouCangURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            [self alertAction:shouCangType2];
           
           num=self.voiceArray.count;
           
           [self LoadNewData];
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}
-(void)singleTapAction{
    [_textfield resignFirstResponder];
    [UIView animateWithDuration:duration animations:^{
        self.TotalCommentView.frame=CGRectMake(0,KScreenHeight*0.345, KScreenWidth, KScreenHeight);
        self.tableView.frame = self.bounds;
    }];
    self.TotalCommentView.hidden=YES;
    commentCoverView.hidden=YES;
    disappearView2.hidden=YES;
    
    //2.停止
    if (_player) {
        if ([_player isPlaying]) {
            [_player stop];
    }
    }
    !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        return NO;
    }
   
    [self addCommentAction];
  
    //4.输入框置空
    [_textfield resignFirstResponder];
    [UIView animateWithDuration:duration animations:^{
        //CGAffineTransformIdentity保存了原先进行的动画的操作
        self.TotalCommentView.frame=CGRectMake(0,KScreenHeight*0.345, KScreenWidth, KScreenHeight);
        self.tableView.frame = self.bounds;
    }];
    self.TotalCommentView.hidden=YES;
    commentCoverView.hidden=YES;
    disappearView2.hidden=YES;
    !self.callBackPinLunFinish ? : self.callBackPinLunFinish();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    return YES;
}
-(void)setDataType:(NSString *)DataType{
    
    _DataType=DataType;
}
-(void)setIs_u:(NSInteger)is_u{
    
    _is_u=is_u;
}
-(void)setPageUID:(NSString *)pageUID{
    
    _pageUID=pageUID;
}
-(void)setMyCid:(NSString *)myCid{
    
    _myCid=myCid;
    
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
- (NSMutableArray *)moreDataArray {
    if (!_moreDataArray) {
        
        _moreDataArray = [NSMutableArray array];
    }
    return _moreDataArray;
}
@end
