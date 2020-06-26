//
//  UITextView+ZBPlaceHolder.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ZBPlaceHolder)
/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *BJX_placeHolder;
/**
 *  IQKeyboardManager等第三方框架会读取placeholder属性并创建UIToolbar展示
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  placeHolderFont
 */
@property (nonatomic, assign) CGFloat placeHolderFontSize;

/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *BJX_placeHolderColor;
@end

NS_ASSUME_NONNULL_END
