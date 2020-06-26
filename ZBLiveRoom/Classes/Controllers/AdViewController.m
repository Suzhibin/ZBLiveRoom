//
//  AdViewController.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/19.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "AdViewController.h"
#import <Masonry/Masonry.h>
#import <SuperPlayer/SuperPlayer.h>
#import "UIImageView+WebCache.h"
#import "YYWeakProxy.h"
@interface AdViewController ()<SuperPlayerDelegate>
@property (nonatomic) UIView *playerFatherView;//播放器父view
@property (nonatomic,strong) SuperPlayerView *playerView;//播放器
@property (nonatomic,assign)BOOL isAd;
@property (nonatomic,assign)NSInteger seconds;
@property (nonatomic,strong) UIButton *skipBtn;//播放器
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AdViewController
- (void)dealloc{
    NSLog(@"释放%s",__func__);
    [self.playerView resetPlayer];
    [self resetTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createaPlayerView];
    [self startPlayWithIsAd:YES];
    UIButton *skipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.layer.cornerRadius=10;
    skipBtn.layer.masksToBounds=YES;
    skipBtn.backgroundColor=[UIColor grayColor];
    skipBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [skipBtn addTarget:self action:@selector(skipBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [_playerView addSubview:skipBtn];
    self.skipBtn=skipBtn;
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playerView.mas_top).offset(16);
        make.right.equalTo(_playerView.mas_right).offset(-16);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    self.seconds=11;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过:%ld",self.seconds]  forState:UIControlStateNormal];
   
}
- (void)skipBtn_Action:(UIButton *)sender{
    [self startPlayWithIsAd:NO];
}
#pragma mark - 播放视频
- (void)startPlayWithIsAd:(BOOL)isAd{
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    if (isAd==YES) {
        self.isAd=YES;
        playerModel.videoURL=@"https://fcvideo.cdn.bcebos.com/smart/f103c4fc97d2b2e63b15d2d5999d6477.mp4";
    }else{
        self.isAd=NO;
        self.skipBtn.hidden=YES;
        [self.skipBtn removeFromSuperview];
    playerModel.videoURL=@"http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/28742df34564972819219071568/master_playlist.m3u8";
    }
    [self controlViewShowWithHidden];
    [_playerView.coverImageView sd_setImageWithURL:[NSURL URLWithString:@"http://1252463788.vod2.myqcloud.com/e12fcc4dvodgzp1252463788/28742df34564972819219071568/4564972819209692959.jpeg"]];
    [_playerView playWithModel:playerModel];
}
- (void)startCountdown{
    if (self.seconds==0) {
        return;
    }
    self.seconds--;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过:%ld",self.seconds]  forState:UIControlStateNormal];
}
- (void)createTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(startCountdown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)resetTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer=nil;
    }
}
#pragma mark - 播放器代理 SuperPlayerDelegate
- (void)superPlayerDidStart:(SuperPlayerView *)player{/// 播放开始通知
    if ( self.isAd==YES) {
        [self createTimer];
    }
}

- (void)superPlayerDidEnd:(SuperPlayerView *)player{/// 播放结束通知
    if(self.isAd==YES){
        [self resetTimer];
        [self startPlayWithIsAd:NO];
    }
}
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why{/// 播放错误通知
}
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player{/// 全屏改变通知  刷新状态栏
    if(player.isFullScreen){
        [self controlViewShowWithHidden];
        SPDefaultControlView *controlView = (SPDefaultControlView *)player.controlView;
        controlView.moreBtn.hidden = YES;
        controlView.captureBtn.hidden = YES;
        controlView.danmakuBtn.hidden = YES;
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }else{
        [self controlViewShowWithHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (void)superPlayerBackAction:(SuperPlayerView *)player{///返回
    [self exitViewController];
}
- (void)controlViewShowWithHidden{
    SPDefaultControlView *controlView = (SPDefaultControlView *)_playerView.controlView;
    if (self.isAd==YES) {
        controlView.lockBtn.hidden = YES;
        controlView.startBtn.hidden = YES;
        controlView.currentTimeLabel.hidden = YES;
        controlView.totalTimeLabel.hidden = YES;
        controlView.videoSlider.hidden = YES;
    }else{
        controlView.lockBtn.hidden = NO;
        controlView.startBtn.hidden = NO;
        controlView.currentTimeLabel.hidden = NO;
        controlView.totalTimeLabel.hidden = NO;
        controlView.videoSlider.hidden = NO;
    }
}
- (void)exitViewController{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 创建播放器
- (void)createaPlayerView{
    _playerView = [[SuperPlayerView alloc] init];
    _playerView.delegate = self;
    _playerView.playerConfig.enableLog=NO;
    self.playerFatherView = [[UIView alloc] init];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20+self.navigationController.navigationBar.bounds.size.height);
        }
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);// 这里宽高比16：9,可自定义宽高比
    }];
    _playerView.fatherView =_playerFatherView;// 设置父 View，_playerView 会被自动添加到 holderView 下面
}
#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {// 返回值要必须为NO
    return NO;
}
- (BOOL)prefersStatusBarHidden {
    return self.playerView.isFullScreen;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
