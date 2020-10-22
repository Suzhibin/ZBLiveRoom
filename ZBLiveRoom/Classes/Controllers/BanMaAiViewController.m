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
@interface BanMaAiViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, assign)NSInteger currentTime;//记录
@end

@implementation BanMaAiViewController

- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"palyisFullScreen" object:self userInfo:@{@"isFullScreen":@(NO)}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"palyisFullScreen" object:self userInfo:@{@"isFullScreen":@(YES)}];
    [self createaPlayerView];
    //[self startPlay];
    
}

#pragma mark - 创建播放器
- (void)createaPlayerView{
    [self.view addSubview:self.containerView];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.containerView];/// 播放器相关
    self.player.controlView = self.controlView;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    [self.player rotateToOrientation:UIInterfaceOrientationLandscapeRight animated:NO completion:nil];


    @weakify(self) 
    self.controlView.backBtnClickCallback = ^{
        @strongify(self)
        [self.player rotateToOrientation:UIInterfaceOrientationPortrait animated:NO completion:nil];
        [self.player stop];
        [self dismissViewControllerAnimated:NO completion:nil];
    };

   __block NSInteger tempTime;
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        tempTime=currentTime;
        if (self.currentTime!=tempTime) {
            if (tempTime==100) {
               [playerManager pause];
                NSLog(@"进入游戏");
            }
        }
        self.currentTime=tempTime;
        
    };
    /// 播放完成
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        //[self.player stop];
    };
 
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
/// 键盘支持横屏，这里必须设置支持多个方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
   
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
