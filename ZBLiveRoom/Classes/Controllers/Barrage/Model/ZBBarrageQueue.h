//
//  ZBBarrageQueue.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/6/5.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBBarrageQueue;
NS_ASSUME_NONNULL_BEGIN
@interface ZBBarrageModel : NSObject
@property (nonatomic,assign)NSInteger seconds;
@property (nonatomic,copy)NSString * text;
@end

@protocol ZBBarrageQueueDelegate <NSObject>
@optional

//返回弹幕
- (void)barrageQueueGetTextArray:(NSArray *)textArray;

/*
如果 视频播放器有当前播放时间回调 直接使用startQueueWithCurrentTime
不用实现此代理
   返回 视频对应时间
*/
- (NSInteger)barrageTimeForQueue:(ZBBarrageQueue *)Queue;

@end
    
@interface ZBBarrageQueue : NSObject
@property (nonatomic,weak)id<ZBBarrageQueueDelegate>delegate;
//加载弹幕
- (void)loadBarrageList:(NSArray *)barrageList;
//开始取弹幕
- (void)startQueueWithCurrentTime:(NSInteger)currentTime;


/*
 如果 视频播放器有当前播放时间回调 直接使用startQueueWithCurrentTime
 不用使用此方法
    开启队列
 */
- (void)startQueue;
/*
 如果 视频播放器有当前播放时间回调 直接使用startQueueWithCurrentTime
 不用使用此方法
    关闭队列
*/
- (void)stopQueue;
@end

NS_ASSUME_NONNULL_END
