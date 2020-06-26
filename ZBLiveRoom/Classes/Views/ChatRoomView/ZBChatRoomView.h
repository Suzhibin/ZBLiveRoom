//
//  ZBChatRoomView.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/21.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomMessageModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ZBReloadChatRoomType) {
    ZBReloadChatRoomType_Direct,     // 直接刷新
    ZBReloadChatRoomType_Time ,      // 按照时间刷新一次消息
};
@protocol ZBChatRoomDelegate <NSObject>
@optional
- (void)startScroll;
- (void)endScroll;
/** 点击cell */
- (void)cellDidSelectClick:(ChatRoomMessageModel *)msgModel;

@end
@interface ZBChatRoomView : UIView
@property (nonatomic, weak) id<ZBChatRoomDelegate> delegate;
@property (nonatomic, assign) ZBReloadChatRoomType reloadType;

/** 消息列表 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,assign)BOOL inPending;//是否处于爬楼状态

/**添加消息*/
- (void)sendChatRoomMessage:(ChatRoomMessageModel *)msgMode;
/**清空消息*/
- (void)reset;
/**ZBReloadChatRoomType_Time 状态 ，暂停计时器*/
- (void)stopTimer;
@end

NS_ASSUME_NONNULL_END
