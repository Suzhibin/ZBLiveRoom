//
//  NDGiftAnimation.h
//  OC_GiftAnimation
//
//  Created by ljq on 2019/1/25.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NDGiftModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NDGiftAnimationDelegate <NSObject>

- (void)didGiftAnimationUser;
@end

@interface NDGiftAnimation : NSObject

- (instancetype)initWithView:(UIView *)bearView frame:(CGRect)frame;

@property (nonatomic, weak) id<NDGiftAnimationDelegate> delegate;
@property (nonatomic, weak) UIView *parentView;
// 最底部礼物气泡的最大Y轴
@property (nonatomic, assign) CGFloat bottomMaxY;

// 收到礼物
- (void)receivedGift:(NDGiftModel *)gift;


- (void)destoryLiveRoom;

@end

NS_ASSUME_NONNULL_END
