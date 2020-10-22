//
//  BarrageViewController.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/6/5.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "BarrageViewController.h"
#import <Masonry/Masonry.h>
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "OCBarrage.h"
#import "ZBBarrageQueue.h"
#import <YYModel/YYModel.h>
@interface BarrageViewController ()<ZBBarrageQueueDelegate>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong)OCBarrageManager *barrageManager;
@property (nonatomic, strong)ZBBarrageQueue *barrageQueue;
@property (nonatomic, assign)NSInteger currentTime;//记录 当前播放时间
@end

@implementation BarrageViewController
- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.player.viewControllerDisappear = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createaPlayerView];
    [self startPlay];
    [self createBarrageBtn];
    [self loadBarrageData];
    
}
#pragma mark - 加载弹幕数据
- (void)loadBarrageData{
    NSMutableArray *listArray=[[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray * barbrageArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [barbrageArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZBBarrageModel *model=[[ZBBarrageModel alloc]init];
        model.text=obj[@"barrage"];
        model.seconds=[obj[@"seconds"]integerValue];
        [listArray addObject:model];
    }];
    [self.barrageQueue loadBarrageList:listArray];
}
- (void)barrageBtn_Action:(UIButton *)sender{
    NSString *text=[NSString stringWithFormat:@"铁锤👬 第%ld秒",self.currentTime];
    [self sendbarrage:text isMe:YES];
}
#pragma mark - 创建播放器
- (void)createaPlayerView{
    [self.view addSubview:self.containerView];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.containerView];/// 播放器相关

    self.player.controlView = self.controlView;
    @weakify(self) /// 屏幕改变
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"palyisFullScreen" object:self userInfo:@{@"isFullScreen":@(isFullScreen)}];
        [self setNeedsStatusBarAppearanceUpdate];
    };

    //播放状态
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
             @strongify(self)
        if (playState==ZFPlayerPlayStatePlayStopped||playState==ZFPlayerPlayStatePlayFailed) {
            [self.barrageManager stop];//停止弹幕
        }else{
            if (playState==ZFPlayerPlayStatePaused) {
                [self.barrageManager pause];//暂停
            }else if (playState==ZFPlayerPlayStatePlaying){
                [self.barrageManager start];//开启弹幕
            }
        }
    };
    __block NSInteger tempTime;
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        //因为此回调是0.1秒一次，所以做了此判断，
        tempTime=currentTime;
        if (self.currentTime!=tempTime) {
            //弹幕列队 和 视频时间绑定
            [self.barrageQueue startQueueWithCurrentTime:tempTime];
        }
        self.currentTime=tempTime;
    };
    /// 播放完成
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        //[self.player stop];
    };
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self)
        NSLog(@"视频错误：%@",error);
    };
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
             make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
             make.top.mas_equalTo(20+self.navigationController.navigationBar.bounds.size.height);
        }
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(self.containerView.mas_width).multipliedBy(9.0f/16.0f);// 这里宽高比16：9,可自定义宽高比
    }];
    [self.controlView addSubview:self.barrageManager.renderView];
    [self.controlView sendSubviewToBack:self.barrageManager.renderView];//防止挡住控制层
    [self.barrageManager.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.controlView);
        make.top.equalTo(@(20));
        make.bottom.equalTo(self.controlView.mas_bottom).offset(-20);
    }];
    
    self.barrageQueue=[[ZBBarrageQueue alloc]init];
    self.barrageQueue.delegate=self;
}
#pragma mark - 弹幕队列代理
- (void)barrageQueueGetTextArray:(NSArray *)textArray{
    [textArray enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"第%ld元素 发送的弹幕 %@",idx,text);
          [self sendbarrage:text isMe:NO];
    }];
}
#pragma mark - 配置弹幕
- (void)sendbarrage:(NSString *)str isMe:(BOOL)isMe{
     OCBarrageTextDescriptor *textDescriptor = [[OCBarrageTextDescriptor alloc] init];
     textDescriptor.text = str;
     
//    CGFloat bannerHeight = 185.0/2.0;
     textDescriptor.renderRange = NSMakeRange(0,100);
    if (isMe==YES) {
        textDescriptor.textColor = [UIColor redColor];
        textDescriptor.positionPriority = OCBarragePositionMiddle;
        textDescriptor.textFont = [UIFont systemFontOfSize:20];
    }else{
        textDescriptor.textColor = [UIColor greenColor];
        textDescriptor.positionPriority = OCBarragePositionLow;
        textDescriptor.textFont = [UIFont systemFontOfSize:14];
    }
    
     textDescriptor.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
     textDescriptor.strokeWidth = -1;
     textDescriptor.animationDuration = arc4random()%5 + 10;
     textDescriptor.barrageCellClass = [OCBarrageTextCell class];
    self.barrageManager.renderView.renderPositionStyle=OCBarrageRenderPositionIncrease;
     [self.barrageManager renderBarrageDescriptor:textDescriptor];

}
#pragma mark - 播放视频
- (void)startPlay{
    self.player.assetURL = [NSURL URLWithString:@"http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/28742df34564972819219071568/master_playlist.m3u8"];
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
    return self.player.shouldAutorotate;
}
/// 键盘支持横屏，这里必须设置支持多个方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (void)exitViewController{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (OCBarrageManager *)barrageManager{
    if (!_barrageManager) {
         _barrageManager = [[OCBarrageManager alloc] init];
        _barrageManager.renderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _barrageManager;
}

- (void)createBarrageBtn{
    UIButton *barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [barrageBtn setFrame:CGRectMake(0, 0, 60, 44)];
    barrageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [barrageBtn setTitle:@"发弹幕" forState:UIControlStateNormal];
    [barrageBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    barrageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [barrageBtn addTarget:self action:@selector(barrageBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtnItem =[[UIBarButtonItem alloc] initWithCustomView: barrageBtn];
    self.navigationItem.rightBarButtonItem=rightBtnItem;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
