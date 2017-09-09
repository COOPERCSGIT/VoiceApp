//
//  LeftSlideViewController.m
//  LeftSlideViewController
//
//  Created by huangzhenyu on 15/06/18.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.

#import "LeftSlideViewController.h"
#import "GuanZhuModel.h"
#import "LeftViewHeadView.h"
#import "MyMessageModel.h"
#import "MessageModel.h"


@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>
{
    CGFloat _scalef;  //实时横向位移
    UIView *blackView;
    
    LeftViewHeadView *headView;
    
    NSString *pingLunCount;
    
    UIImageView *images;
}

@property (nonatomic,strong) UITableView *leftTableview;
@property (nonatomic,assign) CGFloat leftTableviewW;
@property (nonatomic,strong) UIView *contentView;
@end


@implementation LeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 @brief 初始化侧滑控制器
 @param leftVC 左视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC
{
    if(self = [super init]){
        self.speedf = vSpeedFloat;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        [self addChildViewController:self.leftVC];
        [self addChildViewController:self.mainVC];
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        
        [self.view addSubview:self.leftVC.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        [self.leftVC.view addSubview:view];
        
        //获取左侧tableview
        for (UIView *obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableview = (UITableView *)obj;
            }
        }
        self.leftTableview.backgroundColor = [UIColor clearColor];
        self.leftTableview.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableview.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        
        
        headView=[[LeftViewHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight*0.4)];
        [self.leftVC.view addSubview:headView];
        
        
        images=[[UIImageView alloc]initWithFrame:CGRectMake(57, KScreenHeight*0.45+96, 7, 7)];
        images.backgroundColor=[UIColor redColor];
        CALayer *layer = images.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3.5];
        [self.leftVC.view addSubview:images];
        images.hidden=YES;

        
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}

#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];
    _scalef = (point.x * self.speedf + _scalef);

    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance )) && (_scalef >= 0)))
    {
        //边界值管控
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)))
    {
        CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
        if (recCenterX < kScreenWidth * 0.5 - 2) {
            recCenterX = kScreenWidth * 0.5;
        }
        
        CGFloat recCenterY = rec.view.center.y;
        
        rec.view.center = CGPointMake(recCenterX,recCenterY);

        //scale 1.0~kMainPageScale
        CGFloat scale = 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
    
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));

        
        
        
        //leftScale kLeftScale~1.0
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        self.leftTableview.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        self.contentView.alpha = tempAlpha;

    }
    else
    {
        //超出范围，
        if (self.mainVC.view.x < 0)
        {
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.x > (kScreenWidth - kMainPageDistance))
        {
            [self openLeftView];
            _scalef = 0;
        }
    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _scalef = 0;
    }
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        
        self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.contentView.alpha = kLeftAlpha;
        blackView.hidden=YES;
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
    
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView
{
 
    BOOL hiddens=images.hidden;
    if(!hiddens){
        
        [[NSUserDefaults standardUserDefaults]setObject:@"-2" forKey:@"pingLunCount"];
    
    };
    
    [UIView beginAnimations:nil context:nil];
    blackView.hidden=YES;
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.closed = YES;
    
    self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}

/**
 @brief 打开左视图
 */
- (void)openLeftView;
{
    [self getBaseData1];
    [self LoadNewData];
    
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
    if (!blackView) {
        blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        blackView.backgroundColor=[UIColor colorWithWhite:0 alpha:.5];
        [self.mainVC.view addSubview:blackView];
    }else{
        blackView.hidden=NO;
    }
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    

   
    
    self.leftTableview.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVC.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.sideslipTapGes)
    {
        //单击手势
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [self.mainVC.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */

- (void)setPanEnabled: (BOOL) enabled
{
    [self.pan setEnabled:enabled];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == vDeckCanNotPanViewTag)
    {
//        NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
//        NSLog(@"响应侧滑");
        return YES;
    }
}


-(void)getBaseData1{
    
    NSString *channel=@"channel=APP";
    NSString *uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    
    NSString *myuid=[NSString stringWithFormat:@"&uid=%@",uid];
    NSString *cid=[NSString stringWithFormat:@"&cid=%@",uid];
    
    NSString *typeData=[voiceGetUser stringByAppendingFormat:@"%@%@%@",channel,myuid,cid];
    
    self.mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    
    
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        ULog(@"微信分享到朋友圈成功：\n%@",responseObject);
        _guanzhu=[GuanZhuModel mj_objectWithKeyValues:responseObject];
        
     
        
        headView.guanzhuModel=_guanzhu;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];
}


-(void)LoadNewData{
    
    pingLunCount=[[NSUserDefaults standardUserDefaults]objectForKey:@"pingLunCount"];
    
    if (!pingLunCount) {
        pingLunCount=@"-1";
    }
    
    NSInteger page=1;
    NSInteger num=10000;
    NSString *channel=@"channel=APP";
    NSString *uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    NSString *uid1=[NSString stringWithFormat:@"&uid=%@",uid];
    NSString *pageNow=[NSString stringWithFormat:@"&page=%ld",(long)page];
    NSString *number=[NSString stringWithFormat:@"&num=%ld",(long)num];
    
    NSString *typeData=[voicemyVoiceToComments stringByAppendingFormat:@"%@%@%@%@",channel,uid1,pageNow,number];
    
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.moreDataArray=[MyMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
     
        
        for (MyMessageModel *model in self.moreDataArray) {
            
            for (MessageModel *mesModel in model.comments) {
                
                [self.voiceArray addObject:mesModel];
            }
        }
        
        NSString *pinglunNumber=[NSString stringWithFormat:@"%ld",(unsigned long)self.voiceArray.count];
        if ([pinglunNumber isEqualToString:pingLunCount]) {
            images.hidden=YES;
            [self.voiceArray removeAllObjects];
        }else{
            images.hidden=NO;
            [[NSUserDefaults standardUserDefaults]setObject:pinglunNumber forKey:@"pingLunNumber"];
            [self.voiceArray removeAllObjects];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}




#pragma mark - 懒加载


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

- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
}


@end
