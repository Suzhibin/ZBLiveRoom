//
//  ZBGameQueue.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/12/3.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ZBGameQueue.h"
@implementation ZBGameModel
@end
@interface ZBGameQueue ()
@property (nonatomic,strong)NSMutableDictionary *cacheDict;
@end
@implementation ZBGameQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheDict=[[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)loadGameList:(NSArray *)gameList{
    if (gameList.count<=0) {
        return;
    }
   for (int i = 0; i < gameList.count; i ++) {
       ZBGameModel *gameModel = gameList[i];
       [self.cacheDict setObject:gameModel forKey:@(gameModel.seconds).stringValue];
   }
}
- (void)startQueueWithCurrentTime:(NSInteger)currentTime{
    if ([self.cacheDict.allKeys containsObject:@(currentTime).stringValue]) {
        ZBGameModel *gameModel =[self.cacheDict objectForKey:@(currentTime).stringValue];
        if ([self.delegate respondsToSelector:@selector(gameQueueGetGameModel:)]) {
            [self.delegate gameQueueGetGameModel:gameModel];
        }
     }
}
@end
