//
//  BanMaAiViewController.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/10/7.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "BanMaAiViewController.h"
#import <Masonry/Masonry.h>
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <YYModel/YYModel.h>
#import "ZBGameQueue.h"
#import "GameViewController.h"
#import "UIView+ZBExtension.h"
#import "Macro.h"
@interface BanMaAiViewController ()<ZBGameQueueDelegate,GameViewControllerDelegate>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong)ZFAVPlayerManager *playerManager;
@property (nonatomic, assign)NSInteger currentTime;//记录
@property (nonatomic, strong)ZBGameQueue *gameQueue;
@end
@implementation BanMaAiViewController

- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.timeArray=[[NSMutableArray alloc]init];
    [self createTimeData];//创造游戏节点数据

    [self createaPlayerView];
    [self startPlay];
    
    self.gameQueue=[[ZBGameQueue alloc]init];
    self.gameQueue.delegate=self;
    [self.gameQueue loadGameList:self.timeArray];
}
#pragma mark - ZBGameQueueDelegate
- (void)gameQueueGetGameModel:(ZBGameModel *)gameModel{
    if (gameModel.gameType==1) { //1为游戏
        [self.playerManager pause];//暂停视频
         NSLog(@"进入游戏");
        GameViewController *gameVC=[[GameViewController alloc]init];
        gameVC.delegate=self;
        UIViewController *vc=[self.controlView.landScapeControlView findeCurrentViewController];
        [vc presentViewController:gameVC animated:YES completion:nil];
    }else{
        //其他不跳转 比如儿歌时间
    }
}
#pragma mark - GameViewControllerDelegate
- (void)gameComplete{
    [self.playerManager play];
}
#pragma mark - 创建播放器
- (void)createaPlayerView{
    [self.view addSubview:self.containerView];
    self.playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:self.playerManager containerView:self.containerView];/// 播放器相关
    self.player.controlView = self.controlView;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    [self.player rotateToOrientation:UIInterfaceOrientationLandscapeRight animated:NO completion:nil];
    @weakify(self)
    ///当播放器准备开始播放时候调用
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
         @strongify(self)
        [self.timeArray enumerateObjectsUsingBlock:^(ZBGameModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *icon=[[UIImageView alloc]init];
            if (model.gameType==1) {
                icon.image=[UIImage imageNamed:@"gift_icon_0"];
            }else{
                icon.image=[UIImage imageNamed:@"douyin"];
            }
            icon.backgroundColor=[UIColor whiteColor];
            [self.controlView.landScapeControlView.slider addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(0));
                make.width.equalTo(@(14));
                make.height.equalTo(@(14));
                //7为宽的一半
                make.left.equalTo(@(model.seconds*(self.controlView.landScapeControlView.slider.frame.size.width/self.playerManager.totalTime)-7));
            }];
        }];
    };
    self.controlView.backBtnClickCallback = ^{
        @strongify(self)
        [self.player rotateToOrientation:UIInterfaceOrientationPortrait animated:NO completion:nil];
        [self.player stop];
        [self dismissViewControllerAnimated:NO completion:nil];
    };
   __block NSInteger tempTime;
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        //因为此回调是0.1秒一次，所以做了此判断，
        tempTime=currentTime;
        if (self.currentTime!=tempTime) {
            NSLog(@"tempTime:%ld",tempTime);
            // 游戏时间 和 视频时间进行匹配
            [self.gameQueue startQueueWithCurrentTime:tempTime];
        }
        self.currentTime=tempTime;
    };
    /// 播放完成
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        //返回上一页或重播
    };
}
#pragma mark - 播放视频
- (void)startPlay{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"S2U0W2D4_720_course_c4b0c16f3746ee2fb29eeae486cf36ad" ofType:@"mp4" ];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    self.player.assetURL = videoURL;
}
#pragma mark - 横屏设置
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
#pragma  mark - 游戏节点数据
- (void)createTimeData{
    ZBGameModel *model1=[[ZBGameModel alloc]init];
    model1.gameId=1001;
    model1.gameType=1;
    model1.seconds=100;
    ZBGameModel *model2=[[ZBGameModel alloc]init];
    model2.gameId=1002;
    model2.gameType=1;
    model2.seconds=221;
    ZBGameModel *model3=[[ZBGameModel alloc]init];
    model3.gameId=1003;
    model3.gameType=1;
    model3.seconds=303;
    ZBGameModel *model4=[[ZBGameModel alloc]init];
    model4.gameId=1004;
    model4.gameType=2;
    model4.seconds=318;
    [self.timeArray addObject:model1];
    [self.timeArray addObject:model2];
    [self.timeArray addObject:model3];
    [self.timeArray addObject:model4];
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = NO;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}
- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
    }
    return _containerView;
}
@end
