//
//  ZBBarrageQueue.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/6/5.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ZBBarrageQueue.h"
#import "OCBarrageManager.h"
#import "YYWeakProxy.h"
@implementation ZBBarrageModel
@end
@interface ZBBarrageQueue ()
@property (nonatomic,strong)NSMutableDictionary *cacheDict;
@property (nonatomic, strong) NSTimer *refreshTimer;
@end
@implementation ZBBarrageQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheDict=[[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)loadBarrageList:(NSArray *)barrageList{
    if (barrageList.count<=0) {
        return;
    }
   NSMutableArray *array = [NSMutableArray arrayWithArray:barrageList];
   
   for (int i = 0; i < array.count; i ++) {
       
       ZBBarrageModel *barrageModel = array[i];
       
       NSMutableArray *tempArray = [@[] mutableCopy];
       
       [tempArray addObject:barrageModel.text];
       
       for (int j = i+1; j < array.count; j ++) {
           
           ZBBarrageModel *barrageModel11 = array[j];
           
           if(barrageModel.seconds==barrageModel11.seconds){
               
               [tempArray addObject:barrageModel11.text];
               
               [array removeObjectAtIndex:j];
               j -= 1;
           }
       }
       
       [self.cacheDict setObject:tempArray forKey:@(barrageModel.seconds).stringValue];
   }
}
- (void)startQueueWithCurrentTime:(NSInteger)currentTime{
    if ([self.cacheDict.allKeys containsObject:@(currentTime).stringValue]) {
         
         NSMutableArray *textArray=[self.cacheDict objectForKey:@(currentTime).stringValue];
            if ([self.delegate respondsToSelector:@selector(barrageQueueGetTextArray:)]) {
                [self.delegate barrageQueueGetTextArray:textArray];
            }
     }
}
- (void)createRefreshTimer{
    if (self.refreshTimer) {
        return;
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSRunLoopCommonModes];
}
- (void)timerEvent{
    NSInteger seconds= [self currentTime];

    [self startQueueWithCurrentTime:seconds];
}
- (NSInteger)currentTime{
    NSInteger seconds = 0;
    if ([self.delegate respondsToSelector:@selector(barrageTimeForQueue:)]) {
           seconds=[self.delegate barrageTimeForQueue:self];
    }
    return seconds;
}
- (void)startQueue{
    [self createRefreshTimer];
}
- (void)stopQueue{
    [self.refreshTimer invalidate];
    self.refreshTimer =nil;
}
@end
