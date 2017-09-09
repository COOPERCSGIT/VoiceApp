//
//  MyMessageViewController.m
//  VideoApp
//
//  Created by 叶健东 on 17/3/2.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "MyMessageViewController.h"
#import "ZTHeaderRefresh.h"
#import "MyMessageModel.h"
#import "MessageModel.h"
#import "MorePingLunTableViewCell.h"
#import "MorePinLunViewController.h"
@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *uid;
    
    NSInteger num;
    NSInteger page;
    
    NSString *vid;
}

@end

@implementation MyMessageViewController

static NSString *const ReMenCellIdentifier = @"myMessageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
  
    uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"myUid"];
    
    self.title=@"我的消息";
    
    NSString *number=[[NSUserDefaults standardUserDefaults]objectForKey:@"pingLunNumber"];
    
    [[NSUserDefaults standardUserDefaults]setObject:number forKey:@"pingLunCount"];
    
    [self setUpTableView];
    
    [self setupMJRefreshHeader];
    
    num=20;
}

-(void)setUpTableView{
    
    
   self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"WechatIMG59" target:self action:@selector(getBack)];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
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
    NSString *uid1=[NSString stringWithFormat:@"&uid=%@",uid];
    NSString *pageNow=[NSString stringWithFormat:@"&page=%ld",(long)page];
    NSString *number=[NSString stringWithFormat:@"&num=%ld",(long)num];
    
    NSString *typeData=[voicemyVoiceToComments stringByAppendingFormat:@"%@%@%@%@",channel,uid1,pageNow,number];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *reArray=responseObject;
        
        self.moreDataArray=[MyMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (self.voiceArray.count>0) {
            [self.voiceArray removeAllObjects];
        }
        
        for (MyMessageModel *model in self.moreDataArray) {
            [self.voiceArray addObject:model];
        }
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

-(void)LoadMoreData{
    [self.tableView.mj_header endRefreshing];
    page++;
    NSString *channel=@"channel=APP";
    NSString *uid1=[NSString stringWithFormat:@"&uid=%@",uid];
    NSString *pageNow=[NSString stringWithFormat:@"&page=%ld",(long)page];
    NSString *number=[NSString stringWithFormat:@"&num=%ld",(long)num];
    NSString *typeData=[voicemyVoiceToComments stringByAppendingFormat:@"%@%@%@%@",channel,uid1,pageNow,number];
    [self.mananger GET:typeData parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *reArray=responseObject;
        if (reArray.count>0) {
            
            self.moreDataArray=[MyMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            for (MyMessageModel *model in self.moreDataArray) {
                [self.voiceArray addObject:model];
            }
            
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSUInteger number=0;
    
    if (self.voiceArray.count>0) {
        
        for (int i =0 ; i<self.voiceArray.count; i++) {
            
            if (section==i) {
                MyMessageModel *model=self.voiceArray[i];
                number=model.comments.count;
                if (number>6) {
                    number=6;
                }
            }
        }
    }else{
        number=0;
}
    return number;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return self.voiceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MorePingLunTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ReMenCellIdentifier];
    
    if (!cell ) {
        
        cell = [[MorePingLunTableViewCell alloc ]
                
                initWithStyle : UITableViewCellStyleDefault
                
                reuseIdentifier :ReMenCellIdentifier];
    }
    
    if (self.voiceArray.count>0) {
        
       MyMessageModel *mesModel=self.voiceArray[indexPath.section];
        
        
        cell.model=mesModel.comments[indexPath.row];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    
    headview.backgroundColor=yuYingBackView;
    
//    UILabel *title=[UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:VideoRecordView numberOfLines:0 textAlignment:NSTextAlignmentCenter];
    _megModel=self.voiceArray[section];

    
    UIButton *title=[UIButton buttonWithBackgroundColor:yuYingBackViewhead title:_megModel.title titleLabelFont:[UIFont systemFontOfSize:14] titleColor:VideoRecordView target:self action:@selector(singleTapAction:)];
    
    title.frame=CGRectMake(0, 0, KScreenWidth, 40);
    
    title.tag=100+section;
    
    [headview addSubview:title];

    return headview;
    
}


-(void)singleTapAction:(UIButton *)btn
{
    
    btn.selected=!btn.selected;
    
    NSInteger index= btn.tag-100;
    
    _megModel=self.voiceArray[index];

    MorePinLunViewController *more=[[MorePinLunViewController alloc]init];

    more.myVid=_megModel.vid;
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:more];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];

    
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}









-(void)getBack{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
