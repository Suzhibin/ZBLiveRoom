//
//  ChatRoomBaseCell.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Macro.h"
#import "ChatRoomMessageModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ChatRoomBaseCellDelegate <NSObject>
@optional
/** 长按事件*/
- (void)cellLongPressClick:(ChatRoomMessageModel *)msgModel;
/** 富文本点击*/
- (void)cellMessageAttributeClick:(ChatRoomMessageModel *)msgModel;
@end
@interface ChatRoomBaseCell : UITableViewCell<ChatRoomMessageModelDelegate >
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, weak) id<ChatRoomBaseCellDelegate> delegate;
@property(nonatomic,strong)ChatRoomMessageModel *msgModel;
//添加长按事件
- (void)addLongPressGes;
@end

NS_ASSUME_NONNULL_END
