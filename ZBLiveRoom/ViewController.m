//
//  ViewController.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/14.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "LiveRoomViewController.h"
#import "DouYinViewController.h"
#import "AdViewController.h"
#import "Macro.h"
#import <SuperPlayer/SuperPlayer.h>//报错 需要 pod install
#import "BarrageViewController.h"
#import "ZBBarrageQueue.h"
#import "BanMaAiViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *conmentAry;
@property (nonatomic,strong)NSArray *nameAry;

@property (nonatomic,strong)NSMutableArray *dataArray;//正式数据
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    

    [self.view addSubview:self.tableView];
    self.dataArray=[NSMutableArray arrayWithObjects:@"直播间",@"抖音",@"广告+正片",@"播放视频（弹幕绑定视频播放时间）",@"斑马AI课",nil];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *str=self.dataArray[indexPath.row];
    static NSString *menuID=@"menuIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
           //设置点击cell不变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=str;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        LiveRoomViewController *liveVC=[[LiveRoomViewController alloc]init];
        liveVC.mesType=0;
        liveVC.nameAry=self.nameAry;
        liveVC.conmentAry=self.conmentAry;
        [self.navigationController pushViewController:liveVC animated:YES];
    }else if (indexPath.row==1) {
        DouYinViewController*douyinVC=[[DouYinViewController alloc]init];
        [self.navigationController pushViewController:douyinVC animated:YES];
    }else if (indexPath.row==2) {
        AdViewController*adVC=[[AdViewController alloc]init];
        [self.navigationController pushViewController:adVC animated:YES];
    }else if(indexPath.row==3){
        BarrageViewController *bVC=[[BarrageViewController alloc]init];
        [self.navigationController pushViewController:bVC animated:YES];
    }else if(indexPath.row==4){
        BanMaAiViewController*aiVC=[[BanMaAiViewController alloc]init];
//        UINavigationController *pushNav = [[UINavigationController alloc] initWithRootViewController:aiVC];
//        pushNav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:aiVC animated:YES completion:nil];
    }
 
}
- (UITableView *)tableView{
    if (!_tableView) {

        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, k_safeAreaTopHeight+k_NAVBAR_HEIGHT, k_SCREEN_WIDTH, k_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor colorWithRed:(240)/255.0 green:(242)/255.0 blue:(245)/255.0 alpha:(1)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView=[UIView new];
        if (@available(iOS 11.0,*))  {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
    }
    return _tableView;
}

- (NSArray *)nameAry{
    if (!_nameAry) {
        _nameAry = @[@"安迪", @"韩梅梅", @"艾米莉", @"苏菲娅公主", @"笑😁脸",@"用户1999",@"我是李铁锤",@"anan",@"谁能给我一块钱",@"⌛️",@"纲", @"我爱韩梅梅",@"哦婆婆",@"撒村",@"工程学人才",@"模拟4",@"挤公交",@"多多",@"红app"];
    }
    return _nameAry;
}
- (NSArray *)conmentAry{
    if (!_conmentAry) {
        _conmentAry = @[
        @{@"content":@"主播好棒🏷💋❤️💘💇",@"mesType":@(1),@"user":@{@"name":@"安迪",@"userId":@"10001"}},
        @{@"content":@"主播是代打",@"mesType":@(1),@"user":@{@"name":@"本吧啦蹦",@"userId":@"10002"}},
        @{@"content":@"主播好棒🏷💋❤️💘💇",@"mesType":@(1),@"user":@{@"name":@"安迪",@"userId":@"10001"}},
        @{@"content":@"送了一杯鲜奶",@"mesType":@(4),@"user":@{@"name":@"韩梅梅",@"userId":@"10017"},@"gift":@{@"giftName":@"鲜奶",@"giftId":@"10001",@"giftImageName":@"gift_icon_1"}},
        @{@"content":@"One more time再一次One more time再一次One more time再一次We gonna celebrate我们来庆贺Oh yeah all right没错，就这样Don't stop dancing不要停止舞动One more time再一次We gonna celebrate我们来庆贺",@"mesType":@(1),@"user":@{@"name":@"我爱韩梅梅",@"userId":@"10007"}},
        @{@"content":@"我是榜一，什么时候面基😻✊❤️🙇",@"mesType":@(1),@"user":@{@"name":@"企鹅",@"userId":@"10003"}},
        @{@"content":@"我还是从前那个少年，没有一丝丝改变，时间只不过是考验，种在心中信念丝毫未减，眼前这个少年，还是最初那张脸，面前再多艰险不退却，Say never never give up Like a fighter",@"mesType":@(1),@"user":@{@"name":@"v把同情",@"userId":@"10004"}},
        @{@"content":@"就应该这么打，玩个游戏都不会😏😏😏😏😏😏，不服来辩~~",@"mesType":@(1),@"user":@{@"name":@"来这边",@"userId":@"11112"}},
        @{@"content":@"666",@"mesType":@(1),@"user":@{@"name":@"刚",@"userId":@"10005"}},
        @{@"content":@"好喜欢主播，主播唱歌太好听了🎤🎤🎤🎤",@"mesType":@(1),@"user":@{@"name":@"抹茶",@"userId":@"10006"}},
        @{@"content":@"One more time再一次One more time再一次One more time再一次We gonna celebrate我们来庆贺Oh yeah all right没错，就这样Don't stop dancing不要停止舞动One more time再一次We gonna celebrate我们来庆贺",@"mesType":@(1),@"user":@{@"name":@"我爱韩梅梅",@"userId":@"10007"}},
        @{@"content":@"对面好菜",@"mesType":@(1),@"user":@{@"name":@"皮袄日",@"userId":@"10008"}},
        @{@"content":@"主播，可以看下天赋 出装吗",@"mesType":@(1),@"user":@{@"name":@"⌛️",@"userId":@"10009"}},
        @{@"content":@"什么游戏？",@"mesType":@(1),@"user":@{@"name":@"谁能给我一块钱",@"userId":@"10010"}},
        @{@"content":@"主播不要搞笑",@"mesType":@(1),@"user":@{@"name":@"anan",@"userId":@"10011"}},
        @{@"content":@"One more time再一次One more time再一次One more time再一次We gonna celebrate我们来庆贺Oh yeah all right没错，就这样Don't stop dancing不要停止舞动One more time再一次We gonna celebrate我们来庆贺",@"mesType":@(1),@"user":@{@"name":@"我爱韩梅梅",@"userId":@"10007"}},
        @{@"content":@"暗示 送礼物",@"mesType":@"1",@"user":@{@"name":@"我是李铁锤",@"userId":@"10012"}},
        @{@"content":@"给主播点赞",@"mesType":@(1),@"user":@{@"name":@"用户1999",@"userId":@"10013"}},
        @{@"content":@"点击关注，不迷路",@"mesType":@(2),@"user":@{@"name":@"笑😁脸",@"userId":@"10014"}},
        @{@"content":@"进入直播间",@"mesType":@(3),@"user":@{@"name":@"苏菲娅公主",@"userId":@"10015"}},
        @{@"content":@"什么游戏？",@"mesType":@(1),@"user":@{@"name":@"谁能给我一块钱",@"userId":@"10010"}},
        @{@"content":@"送了一把大宝剑",@"mesType":@(4),@"user":@{@"name":@"艾米莉",@"userId":@"10016"},@"gift":@{@"giftName":@"大宝剑",@"giftId":@"10000",@"giftImageName":@"gift_icon_0"}},
        @{@"content":@"我还是从前那个少年，没有一丝丝改变，时间只不过是考验，种在心中信念丝毫未减，眼前这个少年，还是最初那张脸，面前再多艰险不退却，Say never never give up Like a fighter",@"mesType":@(1),@"user":@{@"name":@"v把同情",@"userId":@"10004"}},
        @{@"content":@"什么游戏？",@"mesType":@(1),@"user":@{@"name":@"谁能给我一块钱",@"userId":@"10010"}},
        @{@"content":@"送了一个吻",@"mesType":@(4),@"user":@{@"name":@"红app",@"userId":@"10017"},@"gift":@{@"giftName":@"吻",@"giftId":@"10003",@"giftImageName":@"gift_icon_3"}}
        ];
    }
    return _conmentAry;
}

@end
