//
//  ZBGameQueue.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/12/3.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZBGameModel : NSObject
@property (nonatomic,assign)NSInteger seconds;//游戏时间
@property (nonatomic,assign)NSInteger gameId;//游戏id
@property (nonatomic,assign)NSInteger gameType;//游戏类型 1为游戏  
@end
NS_ASSUME_NONNULL_BEGIN
@protocol ZBGameQueueDelegate <NSObject>
@optional

//返回弹幕
- (void)gameQueueGetGameModel:(ZBGameModel *)gameModel;

@end
@interface ZBGameQueue : NSObject
@property (nonatomic,weak)id<ZBGameQueueDelegate>delegate;
//加载弹幕
- (void)loadGameList:(NSArray *)barrageList;
//开始取游戏时间
- (void)startQueueWithCurrentTime:(NSInteger)currentTime;
@end

NS_ASSUME_NONNULL_END
