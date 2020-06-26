//
//  NDGiftAnimation.m
//  OC_GiftAnimation
//
//  Created by ljq on 2019/1/25.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import "NDGiftAnimation.h"
#import "NDGiftAnimationView.h"


@interface NDGiftAnimation ()

@property (nonatomic, strong) NSMutableArray<NDGiftAnimationView *> *animationArray;
/**
 需要执行的礼物动画
 
 礼物数据源（统一礼物,同一用户且相同礼物id）
 */
@property (nonatomic, strong) NSMutableArray<NDGiftModel *> *giftArray;

@end

@implementation NDGiftAnimation

- (instancetype)initWithView:(UIView *)bearView frame:(CGRect)frame{
    if (self = [super init]){
        
        // 没有做屏幕适配，可自行调整
        //CGFloat _width = size.width;
        //CGFloat _maxY = [UIScreen mainScreen].bounds.size.height / 2 - 48;
        CGFloat _maxY =frame.origin.y;
        for (int i = 0; i<2; i++) {
            NDGiftAnimationView *animationV = [[NDGiftAnimationView alloc] init];
            if (i == 1) {
                animationV.frame = CGRectMake(-frame.size.width, _maxY, frame.size.width, frame.size.height);
            } else {
                animationV.frame = CGRectMake(-frame.size.width, frame.size.height+8+_maxY, frame.size.width, frame.size.height);
            }
            [bearView addSubview:animationV];
            [self.animationArray addObject:animationV];
        }
    }
    return self;
}

// 收到礼物
- (void)receivedGift:(NDGiftModel *)gift {
    if (!gift) return;
    
    // 更新总数量
    gift.doubleHitCount = gift.giftCount;
    
    // 1. 判读当前礼物视图是否需要显示动画
    for (NDGiftAnimationView *giftView in self.animationArray) {
        BOOL update = [giftView animationStatusWith:gift];
        if (update) {
            return;
        }
    }
    
    // 2. 追加|更新礼物队列
    [self insertOrUpdate:gift];
    
    // 3. 执行礼物队列动画
    [self animateNextGift];
}

/** 执行礼物动画 */
- (void)animateNextGift {
    // 1. 没有要显示的礼物
    NDGiftModel *gift = self.giftArray.firstObject;
    if (!gift) {
        return;
    }
    // 2. 执行礼物动画
    __weak typeof(self) weakSelf = self;
    for (NDGiftAnimationView *animationView in self.animationArray) {
        if (animationView.animationStatus == NDAnimationStatusUnknown) {
            
            [weakSelf.giftArray removeObject:gift];
            
            [animationView startAnimationWithGift:gift finishedBlock:^(NDGiftModel *gift) {
                
                // 执行完动画递归
                [weakSelf animateNextGift];
            }];
            return;
        }
    }
}

#pragma mark - 数据源
- (void)insertOrUpdate:(NDGiftModel *)model {
    // 遍历相同礼物累加
    for (NDGiftModel *item in self.giftArray) {
        if ([item.giftKey isEqualToString:model.giftKey]) {
            item.giftCount = model.giftCount;
            item.doubleHitCount += item.giftCount;
            return;
        }
    }
    // 优先级插入（价格高的在前）
    // [obj.gift.contributions floatValue] < [model.gift.contributions floatValue])
    
    [self.giftArray addObject:model];
}

- (void)destoryLiveRoom {
    [self.giftArray removeAllObjects];
    [self.animationArray removeAllObjects];
}

#pragma mark ----- GET
- (NSMutableArray<NDGiftAnimationView *> *)animationArray {
    if (!_animationArray) {
        _animationArray = [NSMutableArray array];
    }
    return _animationArray;
}

- (NSMutableArray<NDGiftModel *> *)giftArray {
    if (!_giftArray) {
        _giftArray = [NSMutableArray array];
    }
    return _giftArray;
}

@end
