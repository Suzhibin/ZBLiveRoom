//
//  NDGiftModel.m
//  OC_GiftAnimation
//
//  Created by ljq on 2019/1/25.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import "NDGiftModel.h"

@implementation NDGiftModel

- (void)setUserId:(NSString *)userId{
    _userId=userId;
    [self createGiftID];
    _time = [self.duration floatValue] / 1000;
}
- (void)setGiftId:(NSString *)giftId{
    _giftId=giftId;
    _time=[self.duration floatValue]/1000;
    [self createGiftID];
}

- (void)createGiftID {
    if (_userId && _giftId) {
        _giftKey = [NSString stringWithFormat:@"%@_%@", self.userId, self.giftId];
    }
}

@end
