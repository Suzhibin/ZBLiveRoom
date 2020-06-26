//
//  LiveRoomViewController.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiveRoomViewController : UIViewController
@property (nonatomic,strong)NSArray *conmentAry;
@property (nonatomic,strong)NSArray *nameAry;
@property (nonatomic, assign)NSInteger mesType;
@end

NS_ASSUME_NONNULL_END
