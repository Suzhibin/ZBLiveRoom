//
//  UIViewController+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/18.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZBKit)

/**
 navigationItem 左右 添加按钮
 
 @param title 按钮名字
 @param selector 方法
 @param isLeft 所占位置
 */
- (void)itemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft;

/**
 提示框

 @param title 标题
 @param message 内容
 */
- (void)alertTitle:(NSString *)title andMessage:(NSString *)message;

/**
 ViewController navigationItem 添加图片

 @param imageName 图片名字
 */
- (void)titleViewWithImage:(NSString *)imageName;

/**
 获取 最上层的ViewController
 
 @return ViewController
 */
- (UIViewController *)topMostViewController;

/**
 获取任意ViewController的navigationController
 
 @return navigationController
 */
- (UINavigationController *)zb_navigationController;

/**
 去掉navigationController.viewControllers 栈内的controller对象
 */
- (void)backPopAppointViewController:(NSString *)viewController;
@end
