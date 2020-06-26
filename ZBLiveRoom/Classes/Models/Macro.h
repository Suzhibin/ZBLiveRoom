//
//  Macro.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define k_safeAreaBottomHeight (CGFloat)(IS_IPhoneX_All?(34.0):(0.0))
#define k_safeAreaTopHeight (CGFloat)(IS_IPhoneX_All?(44.0):(22.0))
#define k_NAVBAR_HEIGHT       self.navigationController.navigationBar.frame.size.height
#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define k_SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)

#define k_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

#define COLOR_UI(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define COLOR_CG(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)].CGColor

#define COLOR_UI_RED COLOR_UI(255, 68, 0, 1)
#endif /* Macro_h */
