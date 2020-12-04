//
//  ChatRoomGiftModel.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/21.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomGiftModel : NSObject
@property (nonatomic, copy) NSString *giftId;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, copy) NSString *giftImageName;
// 气泡动画停留时间  毫秒
@property (nonatomic, strong) NSNumber *duration;
@end

NS_ASSUME_NONNULL_END
