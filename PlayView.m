//
//  PlayView.m
//  VideoApp
//
//  Created by cheng on 2017/9/3.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//
///先不写布局 先写功能 之后再考虑 所以我们先把页面的功能搭建好 然后
///计划时先问一下甲方的想法 然后我现在还没有布局情况

#import "PlayView.h"
#import "Masonry.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ReMenModel.h"
@interface PlayView ()<MJPhotoBrowserDelegate>

@end

@implementation PlayView


-(id) initWithModel:(ReMenModel*)model{
    if(self == [super init]){
        self.picURLArray = model.backgrunds;
        self.mp3URLArray = model.reurls;
        
    }
    return  self;
}



//布局方式
//但是在这里确实还没有给出确定的样式啊 甲方是在干嘛哦
- (void)viewDidLoad {
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50,30, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"Re_btn_close_24x24@2x"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(tapCloseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [self loadHeadView];
    [self loadMiddleView];
    [self loadBottomView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void) loadHeadView{
    if(_picURLArray.count != 0){
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for(NSString* url in _picURLArray){
            MJPhoto *photo = [MJPhoto new];
            NSURL* newURL = [NSURL URLWithString:url];
            photo.url = newURL;
            [photoArray addObject:photo];
            NSLog(@"continue");
        }
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        browser.reurls = _mp3URLArray;
        NSLog(@"%@", browser.reurls);
        [browser show];
    }
    
}

-(void)loadMiddleView{
    
    
    
    
}



-(void)loadBottomView{
    
    
    
}

-(void)tapCloseAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}



@end
