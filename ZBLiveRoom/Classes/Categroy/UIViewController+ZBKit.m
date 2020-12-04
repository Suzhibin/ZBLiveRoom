//
//  UIViewController+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/18.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIViewController+ZBKit.h"

@implementation UIViewController (ZBKit)

- (void)itemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft{
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain  target:self action:selector];
    if (isLeft == YES) {
        
        self.navigationItem.leftBarButtonItem = item;
    }else{
        
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)titleViewWithImage:(NSString *)imageName{
    
    UIImageView *titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    self.navigationItem.titleView=titleImage;
}

- (void)alertTitle:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil)
    {
        return self;
    }
    else if ([self.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    return [presentedViewController topMostViewController];
}


- (UINavigationController *)zb_navigationController
{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = [((UITabBarController*)self).selectedViewController zb_navigationController];
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}

- (void)backPopAppointViewController:(NSString *)viewController {
    NSMutableArray *arrVCs = [NSMutableArray arrayWithArray: [self.navigationController.viewControllers copy]];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(viewController)]) {
            [arrVCs removeObject:vc];
        }
    }
    self.navigationController.viewControllers = arrVCs;
    
}
@end
