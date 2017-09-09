//
//  MyPicturesViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/3/3.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MyPicturesViewController.h"

@interface MyPicturesViewController (){
    UIImageView *images;
}

@end

@implementation MyPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"背景图片";
   self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"WechatIMG59" target:self action:@selector(getBack)];
    
}



-(void)setPictureUrl:(NSString *)pictureUrl{
    
    _pictureUrl=pictureUrl;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_pictureUrl]];
    UIImage *image = [UIImage imageWithData:data];
    CGFloat width = image.size.width;
    CGFloat height= image.size.height ;
    CGFloat count=width/KScreenWidth;
    height=height/count;
    images=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,height)];
//    images.contentMode = UIViewContentModeScaleAspectFill;
//    [images setClipsToBounds:YES];
    images.center = CGPointMake(KScreenWidth/2, KScreenHeight/2-64/2);
    [images setImageWithURL:[NSURL URLWithString:_pictureUrl]];
    [self.view addSubview:images];
}
    
    


-(void)getBack{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
