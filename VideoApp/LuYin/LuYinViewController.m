//
//  LuYinViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/3.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "LuYinViewController.h"
#import "LuYinUpdateViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface LuYinViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>{
    UIImageView *startRecord;
    UIButton *shiTing;
    
    UILabel *shortestTime;
    UILabel *timeNow;
    
    UILabel *chongLu;
    UILabel *baoCun;
    
    NSInteger persent;
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    UIButton *recordAgain;
    UIButton *save;
    UILabel *slider;
    UILabel *voiceSliderTime;
    NSInteger tag;
    BOOL pause;
    
}
@property (nonatomic,assign) NSInteger countNum;//录音计时（秒）
@property (nonatomic,copy) NSString *cafPathStr;
@property (nonatomic,copy) NSString *mp3PathStr;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSTimer *sliderTimer;
@property (nonatomic,strong) UIImageView *rotateImgView;
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;
@end

@implementation LuYinViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    pause = false;
    [self addHeadView];
    [self addFooterView];
    self.cafPathStr = [kSandboxPathStr stringByAppendingPathComponent:kCafFileName];
    self.mp3PathStr =  [kSandboxPathStr stringByAppendingPathComponent:kMp3FileName];
    [self startSliderTimer];
    [_sliderTimer setFireDate:[NSDate distantFuture]];
    
}
//加了
-(void)startTimersAction{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];

}


//加了
-(void)startSliderTimer{
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startSlider) userInfo:nil repeats:YES];
   
}


//加了

-(void)addHeadView{
    UIButton *close=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50, 30, 30, 30)];
    [self.view addSubview:close];
    [close setImage:[UIImage imageNamed:@"Re_btn_close_24x24@2x"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    timeNow=[UILabel labelWithFont:[UIFont systemFontOfSize:36] textColor:VideoRecordTime numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:timeNow];
    timeNow.text=@"00:00:00";
    [timeNow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-KScreenHeight*0.48-146);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 36));
    }];
    
    shiTing=[[UIButton alloc]init];
    [self.view addSubview:shiTing];
    [shiTing setImage:[UIImage imageNamed:@"Re2_btn_audition_57x24@2x"] forState:UIControlStateNormal];
    [shiTing setImage:[UIImage imageNamed:@"Re_btn_pause_80x18@2x"] forState:UIControlStateSelected];
    [shiTing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeNow.mas_bottom).offset(30);
        make.centerX.equalTo(timeNow.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 24));
    }];
    [shiTing addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    shiTing.hidden=YES;
    
}

//加了
-(void)addFooterView{
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.52, KScreenWidth, KScreenHeight*0.48)];
    footView.backgroundColor=VideoRecordView;
    [self.view addSubview:footView];
    
    startRecord=[[UIImageView alloc]init];
    [footView addSubview:startRecord];
    [startRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX);
        make.top.equalTo(footView.mas_top).offset(KScreenHeight*0.1);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    
    
    _rotateImgView = [[UIImageView alloc]init];
    _rotateImgView.image = [UIImage imageNamed:@"rcirle_norm"];
    [footView addSubview:self.rotateImgView];
    [_rotateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX);
        make.top.equalTo(footView.mas_top).offset(KScreenHeight*0.1);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
  
    
    startRecord.image=[UIImage imageNamed:@"Re_btn_re_70x70@2x"];
    startRecord.userInteractionEnabled = YES;//方便添加长按
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    //为图片添加手势
    [startRecord addGestureRecognizer:singleTap];

    
    
    shortestTime=[UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    [footView addSubview:shortestTime];
    shortestTime.text=@"录制时间最短10s";
    [shortestTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX);
        make.top.equalTo(startRecord.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    
    
    
    recordAgain=[[UIButton alloc]init];
    [footView addSubview:recordAgain];
    [recordAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(startRecord.mas_bottom);
        make.left.equalTo(footView.mas_left).offset(52);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [recordAgain setBackgroundImage:[UIImage imageNamed:@"Re_btn_again_30x30@2x"] forState:UIControlStateNormal];
    [recordAgain addTarget:self action:@selector(recordAgainAction) forControlEvents:UIControlEventTouchUpInside];
    recordAgain.hidden=YES;
    
    
    chongLu=[UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    [footView addSubview:chongLu];
    chongLu.text=@"重录";
    [chongLu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(recordAgain.mas_centerX);
        make.top.equalTo(recordAgain.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    chongLu.hidden=YES;
    
    
    
    
    
    save=[[UIButton alloc]init];
    [footView addSubview:save];
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(startRecord.mas_bottom);
        make.right.equalTo(footView.mas_right).offset(-52);
        make.size.mas_equalTo(CGSizeMake(30, 23));
    }];
    [save setBackgroundImage:[UIImage imageNamed:@"Re_btn_save_30x22@2x"] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    save.hidden=YES;
    
    baoCun=[UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    [footView addSubview:baoCun];
    baoCun.text=@"保存";
    [baoCun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(save.mas_centerX);
        make.top.equalTo(recordAgain.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    baoCun.hidden=YES;
    
    
    slider=[[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.52-2, 1, 2)];
    slider.backgroundColor=sliderBackView;
    [self.view addSubview:slider];
    
    voiceSliderTime=[[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.52-17, 44, 10)];
    voiceSliderTime.textColor=mainPageTitle;
    voiceSliderTime.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:voiceSliderTime];
}


#pragma mark - 长按事件的实现方法

- (void)singleTapAction {
    
    if (tag==0) {
        
        [self startRecordNotice];
        tag = 1;
        
    }else{
        
//        [self stopRecordNotice];
        [self pauseRecondNotice];
        tag=0;
        
    }
   
}


#pragma mark - 录音方法

- (void)startRecordNotice{

    [self stopMusic];
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    
    
    NSLog(@"----------开始录音----------");
    if(!pause){
    [self deleteOldRecordFile];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
    }
    pause = false;
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    NSError *sessionError;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(audioSession == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [audioSession setActive:YES error:nil];
    
    
    if (![self.audioRecorder isRecording]) {//0--停止，1-录制中，暂停
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        
        [self startTimersAction];
        [_timer setFireDate:[NSDate date]];
    }
    [self starAnimalWithTime:2.0];
    
    
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



#pragma mark - 删除当前录音
- (void)deleteCurrentRecord
{
    [self deleteOldRecordFile];
    [self stopPlayRecord];
   
}





#pragma mark - 暂停录音
- (void)pauseRecondNotice
{
    NSLog(@"----------暂停录音----------");
    [self.audioRecorder pause];
    //停止旋转动画
    [self.rotateImgView.layer removeAllAnimations];
    self.rotateImgView.image = [UIImage imageNamed:@"rcirle_norm"];
    self.rotateImgView.hidden=YES;
    shortestTime.text=@"暂停";
    pause = true;
    [_timer invalidate];
    shiTing.hidden=NO;
    recordAgain.hidden=NO;
    chongLu.hidden=NO;
    save.hidden=NO;
    baoCun.hidden=NO;
    
}






#pragma mark - 结束录音

- (void)stopRecordNotice
{
    NSLog(@"----------结束录音----------");
    pause = false;
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    
    [self.audioRecorder stop];
    
    [self audio_PCMtoMP3];
    
    
    //停止旋转动画
    [self.rotateImgView.layer removeAllAnimations];
    
    self.rotateImgView.image = [UIImage imageNamed:@"rcirle_norm"];
    
    //计算文件大小
//    long long fileSize = [self fileSizeAtPath:self.mp3PathStr]/1024.0;
//    NSString *fileSizeStr = [NSString stringWithFormat:@"%lld",fileSize];
 
    NSLog(@" fileSizeStr : %@ kb",self.mp3PathStr);
        if (_countNum < 10) {
          [self alertWithMessage:@"录音时间太短"];
            timeNow.text = @"00:00:00";
            seconds = 0;
            minutes = 0;
            hours=0;
            _countNum=0;
            [_timer invalidate];
     
        } else {
            startRecord.image=[UIImage imageNamed:@"Re_btn_Pause_70x70@2x"];
            startRecord.userInteractionEnabled=NO;
            [_timer invalidate];
            seconds = 0;
            minutes = 0;
            hours=0;
            
            self.rotateImgView.hidden=YES;
            
            shortestTime.text=@"停止";
            shiTing.hidden=NO;
            recordAgain.hidden=NO;
            chongLu.hidden=NO;
            save.hidden=NO;
            baoCun.hidden=NO;
}}



#pragma mark - 播放
- (void)playRecord
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [self playMusicWithUrl:[NSURL URLWithString:self.mp3PathStr]];
    [_sliderTimer setFireDate:[NSDate date]];
}

- (void)stopPlayRecord
{
    [self stopMusic];
}

- (void)pausePlayRecord
{
    [_sliderTimer setFireDate:[NSDate distantFuture]];
    [self pauseMusic];
    
}


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
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"delegate--播放完毕----------------------");
    
    [_sliderTimer setFireDate:[NSDate distantFuture]];
    
    shiTing.selected=NO;
    
    persent=0;
    
    slider.frame=CGRectMake(0, KScreenHeight*0.52-2,1, 2);
    
    voiceSliderTime.frame=CGRectMake(0, KScreenHeight*0.52-17, 44, 10);
    
    voiceSliderTime.text=@"";
    
    minutes=0;
    seconds = 0;
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



#pragma mark - AudioPlayer方法


-(void)playOrPause:(UIButton *)btn{
    
    btn.selected=!btn.selected;
    
    if  ([self.player isPlaying]){
        [self pausePlayRecord];
 
    } else  {
        [self playRecord];
    }
    
}

#pragma mark - AudioPlayer重录方法

-(void)recordAgainAction{
    [self stopRecordNotice];
    [self stopMusic];
    NSLog(@"重录按钮已经按下");
    _player=nil;
 
    [_sliderTimer setFireDate:[NSDate distantFuture]];
    
    shiTing.selected=NO;
    
    persent=0;
    
    slider.frame=CGRectMake(0, KScreenHeight*0.52-2,1, 2);
    
    voiceSliderTime.frame=CGRectMake(0, KScreenHeight*0.52-17, 44, 10);
    
    voiceSliderTime.text=@"";
    
    _countNum=0;
    minutes=0;
    hours=0;
    seconds=0;
    
    recordAgain.hidden=YES;
    chongLu.hidden=YES;
    save.hidden=YES;
    baoCun.hidden=YES;
    shiTing.hidden=YES;
    
    timeNow.text=@"00:00:00";
    
    self.rotateImgView.hidden=NO;
    startRecord.image=[UIImage imageNamed:@"Re_btn_re_70x70@2x"];
    startRecord.userInteractionEnabled=YES;
    
    shortestTime.text=@"录制时间最短10s";
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


/**
 *停止播放音乐文件
 */
- (void)stopMusic{
    
    //2.停止
    if ([_player isPlaying]) {
        [_player stop];
    }
}

/**
 *暂停播放音乐文件
 */


- (void)pauseMusic{
    

    //2.停止
    if ([_player isPlaying]) {
        [_player pause];
        
    }
}


/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
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
    if (minutes == 60) {
        hours++;
        minutes = 0;
    }
    
//    让不断变量的时间数据进行显示到label上面。
    timeNow.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
  
}


-(void)startSlider{
    
    double length =KScreenWidth/_countNum;
    
    persent++;
    
    seconds++;
    
    if (seconds == 60) {
        minutes++;
        seconds = 0;
    }
    if (minutes == 60) {
        hours++;
        minutes = 0;
    }

    
    slider.frame=CGRectMake(0, KScreenHeight*0.52-2,length*persent, 2);
    
    if(length*persent>KScreenWidth-44){
    voiceSliderTime.frame=CGRectMake(KScreenWidth-44, KScreenHeight*0.52-17, 44, 10);
    }else{
    voiceSliderTime.frame=CGRectMake(0+length*persent, KScreenHeight*0.52-17, 44, 10);
    }
    voiceSliderTime.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
    

    
}


#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}


-(void)saveAction{
    [self stopRecordNotice];
    LuYinUpdateViewController *update=[[LuYinUpdateViewController alloc]init];
    
    update.voicetime=_countNum;
    
    update.VoiceURL=self.mp3PathStr;
    
     [self stopPlayRecord];
    
    [_sliderTimer setFireDate:[NSDate distantFuture]];
    
    shiTing.selected=NO;
    
    persent=0;
    
    slider.frame=CGRectMake(0, KScreenHeight*0.52-2,1, 2);
    
    voiceSliderTime.frame=CGRectMake(0, KScreenHeight*0.52-17, 44, 10);
    
    voiceSliderTime.text=@"";
    
    minutes=0;
    seconds = 0;
    
    [self.navigationController pushViewController:update animated:NO];
    
}


#pragma mark - 隐藏顶部导航栏

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self stopRecordNotice];
    [self stopPlayRecord];
    [_sliderTimer setFireDate:[NSDate distantFuture]];
}



-(void)closeAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    
}



@end
