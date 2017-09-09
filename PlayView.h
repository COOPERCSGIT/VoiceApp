//
//  PlayView.h
//  VideoApp
//
//  Created by cheng on 2017/9/3.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIViewController

@property (nonatomic,copy)NSMutableArray *picURLArray;
@property (nonatomic,copy)NSMutableArray * mp3URLArray;
@property (nonatomic,copy)NSMutableArray *moreDataArray;


@property   (nonatomic,strong) UILabel* title;
@property   (nonatomic,strong) UIButton* pageButton;







@end
