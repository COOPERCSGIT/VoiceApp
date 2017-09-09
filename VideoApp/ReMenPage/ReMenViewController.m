#import "ReMenViewController.h"
#import "AppDelegate.h"
#import "ReMenCollectionViewCell.h"
#import "MorePinLunViewController.h"
#import "MyGuanZhuViewController.h"
#import "ReMenModel.h"
#import "ReMenCell.h"
#import "ReMenUser.h"
#import "LeftSortsViewController.h"
#import "MyPicturesViewController.h"
#import "MyMessageModel.h"
#import "NewLuYinViewController.h"
#import "NewLuYinActionView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PlayView.h"


//对一个page整体页面的判断
@interface ReMenViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,MJPhotoBrowserDelegate>
{
    UIView *rightView;
    UIButton *reMen;
    UIButton *guanZhu;
    UIButton *shouCang;
    UIButton *menuBtn;
    UIButton *recordBtn;
    NSInteger number;
    NSString *code;
    UIView *loginView;
    NSString *myUID;
    NSString *pingLunCount;
    UIImageView *images;
}

@property (nonatomic, strong) UIView    *navView;
@property (nonatomic, strong) UIButton   *detailButton;
@property (nonatomic, strong) UIButton  *attrsButton;
@property (nonatomic, strong) UIButton  *outButton;
@property (nonatomic, strong) UIButton  *addJobButton;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) NSInteger index;              // 当前下标
@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, strong) ReMenModel *model;
@end

@implementation ReMenViewController
static NSString * const detailCellIdentifier = @"detailCell";
static NSString * const attrsCellIdentifier = @"attrsCell";
static NSString * const thirdCellIdentifier = @"thirdCell";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    [self initNav];
    [self addCollectionView];
    
    if([OpenShare isWeixinInstalled]){
        NSLog(@"CAN OPEN");
        [self addLoginView];
    }else{
        NSLog(@"CANT OPEN");
//        myUID = @"duNVKiJUpk";
//        code =    @"021hnMfg2hYuJD0arIhg2XJ1gg2hnMfi";
        [self login];
    }
}
- (void)initNav
{
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(10, 15, 50, 50);
    [menuBtn setImage:[UIImage imageNamed:@"Home_Nav_sidebar_12x12@3x"] forState:UIControlStateNormal];
    menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 27, 0);
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:menuBtn];
    
    images=[[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 7, 7)];
    images.backgroundColor=[UIColor redColor];

    CALayer *layer = images.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.5];
    [menuBtn addSubview:images];
    images.hidden=YES;
    
    recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(KScreenWidth-63, 15, 50, 50);
    [recordBtn setImage:[UIImage imageNamed:@"Home_btn_record_16x16"] forState:UIControlStateNormal];
    recordBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 0);
    [recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:recordBtn];

}
#pragma mark - collectionview
- (void)addCollectionView{
    
    
    // 导航
    _navView = [[UIView alloc] initWithFrame:CGRectMake(70, 10, KScreenWidth-140, 30)];
    _navView.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:_navView];
    
    // 关注
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-140)/3, 30)];
    _detailButton.backgroundColor=[UIColor whiteColor];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_detailButton setTitle:@"关注" forState:UIControlStateNormal];
    [_detailButton setTitleColor:mainPageTitle forState:UIControlStateNormal];
    [_detailButton setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [self.navView addSubview:_detailButton];
    _detailButton.selected = YES;
    [_detailButton addTarget:self
                      action:@selector(scrollToDetailView)
            forControlEvents:UIControlEventTouchUpInside];
    
    // 热门
    _attrsButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-140)/3, 0, (KScreenWidth-140)/3, 30)];
    _attrsButton.backgroundColor=[UIColor whiteColor];
    _attrsButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_attrsButton setTitle:@"热门" forState:UIControlStateNormal];
    [_attrsButton setTitleColor:mainPageTitle forState:UIControlStateNormal];
    [_attrsButton setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [self.navView addSubview:_attrsButton];
    [_attrsButton addTarget:self
                     action:@selector(scrollToAttrsView)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 收藏
    
    _outButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-140)/3*2, 0, (KScreenWidth-140)/3, 30)];
    _outButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _outButton.backgroundColor=[UIColor whiteColor];
    [_outButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_outButton setTitleColor:mainPageTitle forState:UIControlStateNormal];
    [_outButton setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [self.navView addSubview:_outButton];
    [_outButton addTarget:self
                   action:@selector(scrollToOutButtonView)
         forControlEvents:UIControlEventTouchUpInside];
    
    // 加collectionView
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(KScreenWidth,KScreenHeight-65);
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                         64,
                                                                         KScreenWidth,
                                                                         KScreenHeight-64)
                                         collectionViewLayout:flowLayout];
    // 注册2个单元格

    
    [_collectionView registerClass:[ReMenCollectionViewCell class]
        forCellWithReuseIdentifier:attrsCellIdentifier];
    
    [_collectionView registerClass:[ReMenCollectionViewCell class]
        forCellWithReuseIdentifier:detailCellIdentifier];
    
    [_collectionView registerClass:[ReMenCollectionViewCell class]
        forCellWithReuseIdentifier:thirdCellIdentifier];
    
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor =[UIColor whiteColor] ;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_collectionView];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"DeleteShouCang"];
    
    myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    
    if(myUID){
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }   
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.item==1) {
        ReMenCollectionViewCell *attrscell = [collectionView dequeueReusableCellWithReuseIdentifier:attrsCellIdentifier forIndexPath:indexPath];
        attrscell.callBackPinLun1=^(){
            menuBtn.enabled=NO;
            recordBtn.enabled=NO;
            _detailButton.enabled=NO;
            _attrsButton.enabled=NO;
            _outButton.enabled=NO;
            _collectionView.scrollEnabled = NO;
            if (_audioStream) {
                if([_audioStream isPlaying]){
                    [_audioStream stop];
                }}
        };
        attrscell.callBackPinLunFinish=^(){
            menuBtn.enabled=YES;
            recordBtn.enabled=YES;
            _detailButton.enabled=YES;
            _attrsButton.enabled=YES;
            _outButton.enabled=YES;
            _collectionView.scrollEnabled=YES;
        };
        
        attrscell.callBackPinLun2=^(NSString *vid){
            MorePinLunViewController *more=[[MorePinLunViewController alloc]init];
            more.myVid=vid;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:more];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
            
        };
        
        attrscell.callBackUserCenter2=^(ReMenModel *model){
            ReMenModel *remen=[[ReMenModel alloc]init];
            remen=model;
            MyGuanZhuViewController *my=[[MyGuanZhuViewController alloc]init];
            my.userUID=remen.user.uid;
            my.guanzhuNum=remen.is_focus;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:my];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        };
        
        
        attrscell.callBackNewView=^(ReMenModel *model){
            
            NSMutableArray *photoArray = [[NSMutableArray alloc] init];
            NSMutableArray* pics = model.backgrunds;
            
            for(NSString* url in pics){
                MJPhoto *photo = [MJPhoto new];
                NSURL* newURL = [NSURL URLWithString:url];
                photo.url = newURL;
                [photoArray addObject:photo];
                NSLog(@"continue");
            }
            
//            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//            browser.photoBrowserdelegate = self;
//            browser.currentPhotoIndex = 0;
//            browser.photos = photoArray;
//            browser.reurls = model.reurls;
//            NSLog(@"%@", browser.reurls);
//            [browser show];
            
            PlayView* detailView = [[PlayView alloc] initWithModel:model];
            
            
            
            
            
            
            
        };
        
        
        attrscell.callBackLookPictures=^(NSString *pictures){
            MyPicturesViewController *picture=[[MyPicturesViewController alloc]init];
            picture.pictureUrl=pictures;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:picture];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        };
        
        attrscell.DataType=@"allVoice?";
        attrscell.is_u=0;
        attrscell.pageUID=myUID;
        
        cell=attrscell;
        
    }else if (indexPath.item==0) {
        ReMenCollectionViewCell *attrscell1 = [collectionView dequeueReusableCellWithReuseIdentifier:detailCellIdentifier forIndexPath:indexPath];
        
        attrscell1.DataType=@"myFocus?";
        attrscell1.pageUID=myUID;
        attrscell1.is_u=0;
        
        attrscell1.callBackPinLun1=^(){
            
            menuBtn.enabled=NO;
            recordBtn.enabled=NO;
            _detailButton.enabled=NO;
            _attrsButton.enabled=NO;
            _outButton.enabled=NO;
            _collectionView.scrollEnabled = NO;
            
            if (_audioStream) {
                
                if([_audioStream isPlaying]){
                    
                    [_audioStream stop];
                    
                }}
        };
        attrscell1.callBackNewView=^(ReMenModel *model){
            NSMutableArray *photoArray = [[NSMutableArray alloc] init];
            NSMutableArray* pics = model.backgrunds;
            
            for(NSString* url in pics){
                MJPhoto *photo = [MJPhoto new];
                //    photo.image = [self getImageFromURL:url];
                NSURL* newURL = [NSURL URLWithString:url];
                photo.url = newURL;
                // photo.srcImageView = attrscell.cell.pictures;
                [photoArray addObject:photo];
                NSLog(@"continue");
            }
            
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.photoBrowserdelegate = self;
            browser.currentPhotoIndex = 0;
            browser.photos = photoArray;
            browser.reurls = model.reurls;
            NSLog(@"%@", browser.reurls);
            [browser show];
        };
        
        attrscell1.callBackPinLunFinish=^(){
            menuBtn.enabled=YES;
            recordBtn.enabled=YES;
            _detailButton.enabled=YES;
            _attrsButton.enabled=YES;
            _outButton.enabled=YES;
            _collectionView.scrollEnabled=YES;
        };
        
        attrscell1.callBackPinLun2=^(NSString *vid){
            MorePinLunViewController *more=[[MorePinLunViewController alloc]init];
            more.myVid=vid;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:more];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
            
        };
        
        attrscell1.callBackUserCenter2=^(ReMenModel *model){
            
            ReMenModel *remen=[[ReMenModel alloc]init];
            remen=model;
            MyGuanZhuViewController *my=[[MyGuanZhuViewController alloc]init];
            my.userUID=remen.user.uid;
            my.guanzhuNum=remen.is_focus;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:my];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];};
        
        attrscell1.callBackLookPictures=^(NSString *pictures){
            MyPicturesViewController *picture=[[MyPicturesViewController alloc]init];
            picture.pictureUrl=pictures;
//            NSLog(@"%@", pictures);
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:picture];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        };
        cell=attrscell1;
    }else if (indexPath.item==2){
        ReMenCollectionViewCell *attrscell2 = [collectionView dequeueReusableCellWithReuseIdentifier:thirdCellIdentifier forIndexPath:indexPath];
        attrscell2.DataType=@"myFavorites?";
        attrscell2.is_u=0;
        attrscell2.pageUID=myUID;
        
        attrscell2.callBackPinLun1=^(){
            
            menuBtn.enabled=NO;
            recordBtn.enabled=NO;
            _detailButton.enabled=NO;
            _attrsButton.enabled=NO;
            _outButton.enabled=NO;
            _collectionView.scrollEnabled = NO;
            
            if (_audioStream) {
                
                if([_audioStream isPlaying]){
                    
                    [_audioStream stop];
                    
                }}
            
            
        };
        attrscell2.callBackPinLunFinish=^(){
            menuBtn.enabled=YES;
            recordBtn.enabled=YES;
            _detailButton.enabled=YES;
            _attrsButton.enabled=YES;
            _outButton.enabled=YES;
            _collectionView.scrollEnabled=YES;
        };
        
        attrscell2.callBackPinLun2=^(NSString *vid){
            
            MorePinLunViewController *more=[[MorePinLunViewController alloc]init];
            more.myVid=vid;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:more];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
            
        };
        
        
        attrscell2.callBackNewView=^(ReMenModel *model){
            NSLog(@"点了一下2aaaa");
            NSMutableArray *photoArray = [[NSMutableArray alloc] init];
            NSMutableArray* pics = model.backgrunds;
            NSLog(@"%@", model.backgrunds);
            for(NSString* url in pics){
                MJPhoto *photo = [MJPhoto new];
                // photo.image = [self getImageFromURL:url];
                NSURL* newURL = [NSURL URLWithString:url];
                photo.url = newURL;
                // photo.srcImageView = attrscell.cell.pictures;
                [photoArray addObject:photo];
                NSLog(@"continue");
            }
            
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.photoBrowserdelegate = self;
            browser.currentPhotoIndex = 0;
            browser.photos = photoArray;
            browser.reurls = model.reurls;
            NSLog(@"%@", browser.reurls);
            [browser show];
        };
        
        
        attrscell2.callBackUserCenter2=^(ReMenModel *model){
            ReMenModel *remen=[[ReMenModel alloc]init];
            remen=model;
            MyGuanZhuViewController *my=[[MyGuanZhuViewController alloc]init];
            my.userUID=remen.user.uid;
            my.guanzhuNum=remen.is_focus;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:my];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        };

        attrscell2.callBackLookPictures=^(NSString *pictures){
            
            MyPicturesViewController *picture=[[MyPicturesViewController alloc]init];
            
            picture.pictureUrl=pictures;
            
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:picture];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        };
        cell=attrscell2;
    }
    return cell;
}
#pragma mark - 事件处理
- (void)scrollToDetailView{
    
    
    // collectionview 向左滑动
    
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
     [self refreshNavViewByIndex:0];
    _detailButton.selected=YES;
    _attrsButton.selected=NO;
    _outButton.selected=NO;
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"DeleteShouCang"];
   
}
- (void)scrollToAttrsView {
    
    
    // collectionview 向右滑动
    
    [self.collectionView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
    [self refreshNavViewByIndex:1];
    _detailButton.selected=NO;
    _attrsButton.selected=YES;
    _outButton.selected=NO;
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"DeleteShouCang"];
    
}
-(void)scrollToOutButtonView{
    
    [self.collectionView setContentOffset:CGPointMake(KScreenWidth*2, 0) animated:YES];
    [self refreshNavViewByIndex:2];
    _detailButton.selected=NO;
    _attrsButton.selected=NO;
    _outButton.selected=YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"DeleteShouCang"];
}
// collectionview 左右滑动，调用这个方法，使得上面indexView对应起来
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = self.collectionView.frame.size.width;
    NSInteger index = scrollView.contentOffset.x / width;
    [self refreshNavViewByIndex:index];
}
- (void)refreshNavViewByIndex:(NSInteger)index {
    if (index == 0) {
        _detailButton.selected=YES;
        _attrsButton.selected=NO;
        _outButton.selected=NO;
      [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"DeleteShouCang"];
    } else if (index == 1) {
        _detailButton.selected=NO;
        _attrsButton.selected=YES;
        _outButton.selected=NO;
       [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"DeleteShouCang"];
        
    }else if (index == 2) {
        _detailButton.selected=NO;
        _attrsButton.selected=NO;
        _outButton.selected=YES;
       [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"DeleteShouCang"];
    }}
-(void)startRecord{
    
//    LuYinViewController *vc = [[LuYinViewController alloc] init];
    NewLuYinViewController *vc = [[NewLuYinViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}

-(void)addLoginView{
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        myUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
        NSLog(@"OPEN SUCESSES MYUID:%@",myUID);
        if(!myUID){
            [self.navigationController setNavigationBarHidden:YES animated:YES];
                loginView=[[UIView alloc]initWithFrame:self.view.bounds];
            loginView.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:loginView];
            UIButton *login=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2-36, KScreenHeight/2-32, 72, 65)];
            [login setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
            [loginView addSubview:login];
            [login addTarget:self action:@selector(loginWeiXin) forControlEvents:UIControlEventTouchUpInside];
            }
//    }
//    else{
//    }
}

-(void)loginWeiXin{
//    if(code == NULL){
    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
        code=[message objectForKey:@"code"];
        NSLog(@"CODE:%@",code);
        [self login];
    } Fail:^(NSDictionary *message, NSError *error) {
    }];
    
//    }else{
//        [self loginWeiXin];
//    }
    
}


-(void)login
{
        NSString *weixinLoginAppId=@"wxc988255a4b16c8cf";
        NSString *weixinLoginAppSecret=@"16670d3a33f0a7c6b64a8d20a33e2204";
        NSString * codeStr = code;
        //用户允许授权登录
        //第二步通过code获取access_token
        NSString * grantStr =@"grant_type=authorization_code";
        //通过code获取access_token https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
        NSString * tokenUrl =@"https://api.weixin.qq.com/sns/oauth2/access_token?";
        NSString * tokenUrl1 = [tokenUrl stringByAppendingString:[NSString stringWithFormat:@"appid=%@&",weixinLoginAppId]];
        NSString * tokenUrl2 = [tokenUrl1 stringByAppendingString:[NSString stringWithFormat:@"secret=%@&",weixinLoginAppSecret]];
        NSString * tokenUrl3 = [tokenUrl2 stringByAppendingString:[NSString stringWithFormat:@"code=%@&",codeStr]];
        NSString * tokenUrlend = [tokenUrl3 stringByAppendingString:grantStr];
    self.mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [self.mananger GET:tokenUrlend parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * access_token  = [responseObject objectForKey:@"access_token"];
   
        NSString * openid  = [responseObject  objectForKey:@"openid"];

        NSString * userfulStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
        
        [self.mananger GET:userfulStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if(responseObject){
            
            NSString * headimgurl  = [responseObject objectForKey:@"headimgurl"];
            [[NSUserDefaults standardUserDefaults] setObject:headimgurl forKey:@"headpic"];
            
            NSString * nickname  = [responseObject  objectForKey:@"nickname"];
                
             NSString *text=[nickname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
                
            NSString * openid  = [responseObject  objectForKey:@"openid"];
            
            NSString *sex=[responseObject objectForKey:@"sex"];
            
            NSString * userfulUrl = [NSString stringWithFormat:@"https://www.starsound.xyz/yuliao/index.php/api/login?channel=APP&openid=%@&nickname=%@&sex=%@&headpic=%@",openid,text,sex,headimgurl];
         
            [self.mananger GET:userfulUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject) {
                myUID = [[responseObject objectForKey:@"user"]objectForKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setObject:myUID forKey:@"myUid"];
                loginView.hidden=YES;
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                _collectionView.delegate=self;
                _collectionView.dataSource=self;
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma 加载一个页面上的评论数据
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
    NSString *mynumber=[NSString stringWithFormat:@"&num=%ld",(long)num];
    NSString *typeData=[voicemyVoiceToComments stringByAppendingFormat:@"%@%@%@%@",channel,uid1,pageNow,mynumber];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.moreDataArray=[MyMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
//        NSLog(@"%@", responseObject);
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
- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        LeftSortsViewController *left=[[LeftSortsViewController alloc]init];
        left.importantUID=myUID;
        
       
        
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    if (_audioStream) {
        if([_audioStream isPlaying]){
            [_audioStream stop];
        }}
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
    NSString *updateqNow=[[NSUserDefaults standardUserDefaults]objectForKey:@"update"];
    
    if ([updateqNow isEqualToString:@"1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:NULL];
         [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"update"];
    }
    
   [self LoadNewData];
}
#pragma mark - 懒加载
- (AFHTTPSessionManager *)mananger {
    if (!_mananger) {
        _mananger = [AFHTTPSessionManager manager];
    }
    return _mananger;
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
    @end

