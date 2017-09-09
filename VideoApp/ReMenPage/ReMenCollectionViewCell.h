//
//  ReMenCollectionViewCell.h
//  VideoApp
//
//  Created by 叶健东 on 17/2/5.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReMenModel,ReMenCell;
#import <AVFoundation/AVFoundation.h>


@interface ReMenCollectionViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate>

/** 详细属性 */
//@property (nonatomic,strong) NSArray *picturesArray;//新添加图片数组属性
@property (nonatomic, strong) NSArray *attrsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void (^callBackPinLun1)(); // 返回评论点击事件
@property (nonatomic, copy) void (^callBackPinLunFinish)(); // 返回评论点击事件
@property (nonatomic, copy) void (^callBackLookPictures)(NSString *); // 返回评论点击事件
@property (nonatomic, copy) void (^callBackPinLun2)(NSString *); // 返回评论点击事件
@property (nonatomic, copy) void (^callBackUserCenter2)(ReMenModel *); // 返回评论点击事件
@property (nonatomic, copy) void (^callBackNewView)(ReMenModel *); // 返回newView事件
@property (nonatomic, copy) void (^callBackGuanZhu1)(); // 返回评论点击事件
@property (nonatomic, copy) void (^callBackRefresh)();
@property (nonatomic, copy) void (^callBackGuanZhuYes)(); // 返回关注事
@property (nonatomic, strong) ReMenCell *cell;
@property (nonatomic, strong) AFHTTPSessionManager *mananger;

@property (nonatomic,copy)NSMutableArray *voiceArray;
@property (nonatomic,copy)NSMutableArray *moreDataArray;
@property(nonatomic,copy)NSMutableArray* afterMergeDataArray;
@property(nonatomic,strong)ReMenModel *reMen;
@property(nonatomic,assign)NSInteger pingLunYes;

@property(nonatomic,strong)UIView *addCommentView;
@property(nonatomic,strong)UIView *TotalCommentView;
@property (nonatomic,copy) UITextView *textfield;
@property(nonatomic,copy)NSString *DataType;
@property (nonatomic,assign)NSInteger is_u;
@property(nonatomic,copy)NSString *myCid;
@property (nonatomic,strong) UIImageView *rotateImgView;
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@property (nonatomic,assign) NSInteger countNum;//录音计时（秒）
@property (nonatomic,copy) NSString *cafPathStr;
@property (nonatomic,copy) NSString *mp3PathStr;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,copy)NSString *pageUID;

@end
