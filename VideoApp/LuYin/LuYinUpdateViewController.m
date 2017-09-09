//
//  LuYinUpdateViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/7.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "LuYinUpdateViewController.h"
#import "LuYinViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "AliImageReshapeController.h"

@interface LuYinUpdateViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ALiImageReshapeDelegate>{
    
    NSString *fileURL;
    NSString *voiceURL;
    NSString *origialUrl;
    
}
@property(nonatomic,copy)UIButton *addPictures;
@property(nonatomic,copy)UITextField *textField;
@property(nonatomic,copy)UIButton *listenTest;
@property(nonatomic,copy)UIButton *update;
@property(nonatomic,copy)UIImage *image;
@property(nonatomic,copy)UIImageView *imagePicture;
@property(nonatomic,copy)NSString *imagePath;
@property(nonatomic,copy)NSString *OriginImagePath;
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic, strong) AFHTTPSessionManager *mananger;
@end

@implementation LuYinUpdateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addFootView];
    
    [self addNavBut];
    
}
-(void)addNavBut{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight*0.46)];
    [self.view addSubview:headView];
    
    UIButton *close=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50, 25, 30, 30)];
    [headView addSubview:close];
    [close setImage:[UIImage imageNamed:@"Re_btn_close_24x24@2x"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];

    
    _addPictures=[[UIButton alloc]init];
    [headView addSubview:_addPictures];
//    _addPictures.backgroundColor=[UIColor redColor];
    [_addPictures setImage:[UIImage imageNamed:@"Re_btn_add_66x60@2x"] forState:UIControlStateNormal];
    _addPictures.frame=CGRectMake(0, 60, KScreenWidth, KScreenHeight*0.3448);
    [_addPictures addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];

    
    
    _imagePicture=[[UIImageView alloc]init];
    [headView addSubview:_imagePicture];
    _imagePicture.frame=CGRectMake(0, 60, KScreenWidth, KScreenHeight*0.3448);

    _imagePicture.hidden=YES;
    
}
-(void)addFootView{
    
    UIView *middle=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.46, KScreenWidth, 40)];
    middle.backgroundColor=yuYingBackViewhead;
    [self.view addSubview:middle];
    
    UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight*0.46+40, KScreenWidth, KScreenHeight*0.54-40)];
    foot.backgroundColor=VideoRecordView;
    [self.view addSubview:foot];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(18, 10, KScreenWidth-40, 20)];
    _textField.placeholder=@"在此为音频输入一个名称吧";
    _textField.textColor=VideoUpdateText;
    [_textField setValue:VideoUpdateText forKeyPath:@"_placeholderLabel.textColor"];
    [middle addSubview:_textField];
    
    _listenTest=[[UIButton alloc]init];
    [foot addSubview:_listenTest];
    [_listenTest setImage:[UIImage imageNamed:@"Re_btn_audition_170x70@3x"] forState:UIControlStateNormal];
    [_listenTest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(foot.mas_centerX);
        make.top.equalTo(foot.mas_top).offset(KScreenWidth*0.2);
        make.size.mas_equalTo(CGSizeMake(170, 70));
    }];
    [_listenTest addTarget:self action:@selector(listenAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _update=[[UIButton alloc]init];
    [foot addSubview:_update];
    [_update setImage:[UIImage imageNamed:@"Re_btn_upload_126x36@2x"] forState:UIControlStateNormal];
    [_update mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(foot.mas_centerX);
        make.top.equalTo(_listenTest.mas_bottom).offset(KScreenWidth*0.19);
        make.size.mas_equalTo(CGSizeMake(126, 36));
    }];
    [_update addTarget:self action:@selector(uploadAllData) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *layer1 = _update.layer;
    [layer1 setMasksToBounds:YES];
    [layer1 setCornerRadius:7];
    
}
#pragma mark - 隐藏顶部导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)closeAction{
    [self dismissViewControllerAnimated:NO completion:NULL];
}
#pragma mark - add pictures
-(void)addPicture{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
         //根据info 获取照片信息
        //获取image
        self.imagePicture.hidden=NO;
    
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    [self.imagePicture setImage:image];
       UIImage *imageNew=[UILabel fixOrientation:image];
       NSString *path_document = NSHomeDirectory();
         _OriginImagePath = [path_document stringByAppendingString:@"/Documents/originImage.jpeg"];
       //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(imageNew) writeToFile:_OriginImagePath atomically:YES];
        AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
        vc.sourceImage = image;
        vc.reshapeScale = 375./230.;
        vc.delegate = self;
        [picker pushViewController:vc animated:YES];
}

#pragma mark - ALiImageReshapeDelegate
- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    [self.imagePicture setImage:image];
    
    // 把头像图片存到本地
    _image=image;
    
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    _imagePath = [path_document stringByAppendingString:@"/Documents/myImage.jpeg"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(_image) writeToFile:_imagePath atomically:YES];
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}
- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadAllData{
    [self stopMusic];
    if (_image && _textField.text.length) {
        _update.enabled=NO;
        [self updateData];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请完善信息后再上传" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)updateData{
    NSURL *mp3Url =  [NSURL fileURLWithPath:self.VoiceURL];
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
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
        UIImage *getimage2 = [UIImage imageWithContentsOfFile:_imagePath];
        NSData *data = UIImageJPEGRepresentation(getimage2, 0.1);
        UIImage *getimage3 = [UIImage imageWithContentsOfFile:_OriginImagePath];
        NSData *data2 = UIImageJPEGRepresentation(getimage3, 0.1);
        [formData appendPartWithFileData:data
                                name:@"background"
                                fileName:@"myImage.jpeg"
                                mimeType:@"image/jpeg" ];
        [formData appendPartWithFileData:data2
                                    name:@"allbackground"
                                fileName:@"originImage.jpeg"
                                mimeType:@"image/jpeg"];
       [formData appendPartWithFileURL:mp3Url
                                  name:@"reurl"
                                  fileName:@"myRecord.mp3"
                                  mimeType:@"application/octet-stream"
                                 error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"正在上传" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:NULL];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissViewControllerAnimated:NO completion:NULL];
            NSLog(@"%@",responseObject);
//        NSLog([NSURL URLWithString:mp3Url].absoluteString,@"111113333333");
        NSLog(@"%@", responseObject);
        
        
        fileURL=[[responseObject objectForKey:@"data"]objectForKey:@"file"];
        voiceURL=[[responseObject objectForKey:@"data"]objectForKey:@"video"];
        origialUrl=[[responseObject objectForKey:@"data"]objectForKey:@"OrginalFile"];
        
        [self updataTotalData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@",error);
    }];
}


-(void)updataTotalData{
    NSString *channel=@"channel=APP";
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *title=[NSString stringWithFormat:@"&title=%@",_textField.text];
    NSString *text=[title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *reurl=[NSString stringWithFormat:@"&reurl=%@",voiceURL];
    NSString *length=[NSString stringWithFormat:@"&length=%ld",(long)_voicetime];
    NSString *backgrund=[NSString stringWithFormat:@"&backgrund=%@",fileURL];
    NSString *allbackgrund=[NSString stringWithFormat:@"&allbackgrund=%@",origialUrl];
    NSString *allData=[voiceAddVoice stringByAppendingFormat:@"%@%@%@%@%@%@%@",channel,uid,text,reurl,length,backgrund,allbackgrund];
    [self.mananger GET:allData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"update"];
        [self dismissViewControllerAnimated:NO completion:NULL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 播放
- (void)listenAction
{
    [self stopMusic];
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [self playMusicWithUrl:[NSURL URLWithString:self.VoiceURL]];
}
- (void)stopMusic{
    
    //2.停止
    if ([_player isPlaying]) {
        [_player stop];
    }
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
    
//    _player.delegate = self;
    
    if (![_player prepareToPlay]){
        NSLog(@"缓冲失败--");
        return NO;
    }
    
    [_player play];
    
    return YES;//正在播放，那么就返回YES
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
   [_textField resignFirstResponder];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     [self stopMusic];
    
    [_textField resignFirstResponder];
    
}
-(void)setVoiceURL:(NSString *)VoiceURL{
    
    _VoiceURL=VoiceURL;
}
-(void)setVoicetime:(NSInteger)voicetime{
    _voicetime=voicetime;
}
#pragma mark - 懒加载
- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}


@end
