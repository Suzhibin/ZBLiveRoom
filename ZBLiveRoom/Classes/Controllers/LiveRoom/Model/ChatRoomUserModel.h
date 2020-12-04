//
//  ChatRoomUserModel.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/21.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomUserModel : NSObject
///用户
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *userId;
@end

NS_ASSUME_NONNULL_END
