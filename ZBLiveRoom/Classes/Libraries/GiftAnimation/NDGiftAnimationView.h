//
//  NDGiftAnimationView.h
//  OC_GiftAnimation
//
//  Created by ljq on 2019/1/25.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDGiftModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 气泡左右移动的动画时长 */
#define AnimationStartDuration 0.20
/** 礼物数字放大动画时间 */
#define AnimationSerialDuration 0.30
/** 动画已停止，悬浮在视图上的时间 */
#define AnimationStopDuration 2.0
/** 动画结束 视图消失时间 */
#define AnimationEndDuration 0.20


/** 动画过程
    这是一个普遍的礼物动画过程，
    当然你可以根据自身业务调整
 */
typedef NS_ENUM(NSInteger, NDAnimationStatus) {
    NDAnimationStatusUnknown = 0,
    NDAnimationStatusStart,     // 开始运行动画，从左边横向出现的动画(0.2s)
    NDAnimationStatusSerial,    // 连击动画中~，一个放大缩小动画(0.3s)
    NDAnimationStatusStop,      // 动画已停止，悬浮在视图上(默认2秒，可根据🎁调整时间)
    NDAnimationStatusEnd,       // 动画将结束，视图向上的渐隐消失动画(0.2s)
};


@interface NDGiftAnimationView : UIView

/** 当前礼物动画状态 */
@property (nonatomic, assign) NDAnimationStatus animationStatus;

/** 当前正在展示的礼物 */
@property (nonatomic, strong) NDGiftModel *currentGift;

/** 执行礼物动画 */
- (void)startAnimationWithGift:(NDGiftModel *)gift finishedBlock:(void(^)(NDGiftModel *gift))finishedBlock;

// 更新
- (BOOL)animationStatusWith:(NDGiftModel *)gift;

@end

NS_ASSUME_NONNULL_END
