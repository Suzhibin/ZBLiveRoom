//
//  NDGiftAnimationImgView.h
//  OC_GiftAnimation
//
//  Created by ljq on 2019/2/12.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NDGiftAnimationImgView : UIView

@property (nonatomic, assign) NSInteger showCount;

- (void)startAnimWithDuration:(NSTimeInterval)duration complate:(void (^)(void))complate;

@end

NS_ASSUME_NONNULL_END
