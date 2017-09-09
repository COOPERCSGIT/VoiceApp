//
//  NewLuYinViewController.m
//  VideoApp
//

//上传和作为主视图包含pictureView 
//  Created by cheng on 2017/5/30.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//
#import "NewLuYinViewController.h"
#import "NewLunYinUpdateViewController.h"
#import "NewLuYinActionView.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "PictureViewController.h"
@interface NewLuYinViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>{
    NSString* imageURL;
    NSString* oImageURL ;
    NSString* mp3URL ;
    NSString* mp3Time;
}

@property (nonatomic, strong) PictureViewController *vc;
@property(nonatomic,copy)UITextField *textField;
@property(nonatomic,strong)NSMutableArray *PictureArray;
@property(nonatomic,strong)NSMutableArray *Mp3Array;
@property(nonatomic,assign)NSMutableArray *voicetime;

@property (nonatomic, strong) AFHTTPSessionManager *mananger;
@end
@implementation NewLuYinViewController

#pragma 添加视图
-(void)viewDidLoad{
    [super viewDidLoad];
    //KScreenWidth-50, 30
    imageURL = [[NSString alloc] init];
    oImageURL = [[NSString alloc] init];
    mp3URL = [[NSString alloc] init];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50,22, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"Re_btn_close_24x24@2x"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(tapCloseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.view.backgroundColor=[UIColor whiteColor];
    [self addHeadView];
    _vc = [[PictureViewController alloc] init];
    _vc.view.frame = CGRectMake(5, 100, KScreenWidth-10, KScreenHeight*0.65);
    [self addChildViewController:_vc];
//    _vc.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_vc.pictureCollectonView];
    [self.view addSubview:_vc.RecordButtonView];
//    [self.view addSubview:_vc];
    __weak typeof(self) weakSelf = self;
    _vc.updateData = ^(NSMutableArray* imgs,NSMutableArray* mp3s,NSMutableArray* mp3Times){
        weakSelf.PictureArray = imgs;
        weakSelf.Mp3Array = mp3s;
        weakSelf.voicetime = mp3Times;
        [weakSelf uploadAllData];
    };
}

#pragma TextField输入名称
-(void)addHeadView{
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, KScreenWidth-20, 20)];
    _textField.placeholder=@"在此为音频输入一个名称吧";
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.textColor=VideoUpdateText;
    [_textField setValue:VideoUpdateText forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_textField];
}
#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 关闭视窗
-(void)tapCloseAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma 隐藏Nav
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma 关闭键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
}
-(void)uploadAllData{
    
    if (_PictureArray.count > 0 && _textField.text.length) {
        [self updateData];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请完善信息后再上传" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma 上传内容 桥接链接 上传时仍然不变 发布时进行一连串发布 接收时进行符号分割
-(void)updateData{
    
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
        
        UIImage * image        = [[UIImage  alloc] init];
        NSURL* VoiceURL     = [[NSURL alloc] init];
        NSData *data            = [[NSData alloc] init];
        for(int i =0;i<self.PictureArray.count;i++){
            image          = [self.PictureArray objectAtIndex:i];
            data            = UIImageJPEGRepresentation(image, 0.7);
            VoiceURL    =  [NSURL fileURLWithPath:[self.Mp3Array objectAtIndex:i]];
            
            [formData appendPartWithFileData:data
                                        name:[NSString stringWithFormat:@"%@%d",@"background" , i]
                                    fileName: [NSString stringWithFormat:@"myImage%d.jpeg",i]
                                    mimeType:@"image/jpeg" ];
            [formData appendPartWithFileURL:VoiceURL name:[NSString stringWithFormat:@"%@%d",@"reurl" , i] fileName:@"myRecord.mp3" mimeType:@"application/octet-stream" error:nil];
            
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"正在上传" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:NULL];
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissViewControllerAnimated:NO completion:NULL];
        NSLog(@"%@", responseObject);
        if([[responseObject objectForKey:@"data"]  isEqual: @"File is not exit"]){
            ULog(@"上传失败");
        }
        
        imageURL = [[[responseObject objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%@%d",@"background" , 0]] componentsSeparatedByString:@"/image/"][0];
        mp3URL   = [[[responseObject objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%@%d",@"reurl" , 0]] componentsSeparatedByString:@"/file/"][0];
        
        mp3Time = NULL;
        
            for(int i = 0;i < self.PictureArray.count;i++){
                
                NSArray *iarray = [[[responseObject objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%@%d",@"background" , i]] componentsSeparatedByString:@"/image/"];
                NSArray *marray = [[[responseObject objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%@%d",@"reurl" , i]] componentsSeparatedByString:@"/file/"];
                imageURL = [NSString stringWithFormat:@"%@/image/%@", imageURL,iarray[1]];
                mp3URL=[NSString stringWithFormat:@"%@/file/%@", mp3URL ,marray[1]];
                mp3Time = [NSString stringWithFormat:@"%@/%@",mp3Time,[_voicetime objectAtIndex:i]];
            }
            NSLog(@"image:%@  mp3:%@ , time:%@",imageURL,mp3URL,mp3Time);
            [self updataTotalData];
}
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@",error);
    }];
}
-(void)updataTotalData{
    NSString *channel=@"channel=APP";
    NSString *myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *uid=[NSString stringWithFormat:@"&uid=%@",myUID];
    NSString *title=[NSString stringWithFormat:@"&title=%@",_textField.text];
    NSString *text=[title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *reurl=[NSString stringWithFormat:@"&reurl=%@",mp3URL];
    NSString *length=[NSString stringWithFormat:@"&length=%@",mp3Time];
    NSString *backgrund=[NSString stringWithFormat:@"&backgrund=%@",imageURL];
    NSString *allbackgrund=[NSString stringWithFormat:@"&allbackgrund=%@",oImageURL];
    NSString *allData=[voiceAddVoice stringByAppendingFormat:@"%@%@%@%@%@%@%@",channel,uid,text,reurl,length,backgrund,allbackgrund];
    [self.mananger GET:allData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"update"];
        NSLog(@"responseObject: %@", responseObject);
        NSLog(@"allData: %@", allData);
        [self dismissViewControllerAnimated:NO completion:NULL];
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
@end
