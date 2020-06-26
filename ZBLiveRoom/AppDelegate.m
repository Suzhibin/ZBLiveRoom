//
//  AppDelegate.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/14.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YYFPSLabel.h"
#import <Masonry/Masonry.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
           
        ViewController *vc = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(palyVCcisFullScreen:) name:@"palyisFullScreen" object:nil];//星探视频详情旋转
//        YYFPSLabel *fps = [[YYFPSLabel alloc]init];//fps监测
//        [self.window addSubview:fps];
//    [fps mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(44));
//        make.centerX.equalTo(self.window);
//        make.height.equalTo(@(20));
//    }];
    return YES;
}
- (void)palyVCcisFullScreen:(NSNotification *)notify{
    NSNumber *isFullScreen= notify.userInfo[@"isFullScreen"];
    self.allowOrentitaionRotation=[isFullScreen boolValue];
}
/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}
/*
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
*/

@end
