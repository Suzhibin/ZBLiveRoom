//
//  ChatRoomMessageModel.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Macro.h"
#import "ChatRoomUserModel.h"
#import "ChatRoomGiftModel.h"
@class ChatRoomMessageModel;
NS_ASSUME_NONNULL_BEGIN
@protocol ChatRoomMessageModelDelegate <NSObject>
@optional
/** 属性文字刷新后调用 */
- (void)attributeUpdated:(ChatRoomMessageModel *)model;
// 富文本点击
- (void)msgAttributeTapAction;

@end
@interface ChatRoomMessageModel : NSObject
///发送内容
@property (nonatomic,copy)NSString *content;
///消息类型 
@property (nonatomic,assign)NSInteger mesType;
//用户数据
@property (nonatomic,strong)ChatRoomUserModel *user;
@property (nonatomic,strong)ChatRoomGiftModel *gift;

@property (nonatomic, weak) id<ChatRoomMessageModelDelegate> delegate;
///富文本
@property (nonatomic, strong) NSMutableAttributedString *msgAttribText;
/// 消息高度
@property (nonatomic, assign) CGFloat msgHeight;

-(instancetype)initWithDict:(NSDictionary *)dict;
- (void)initMsgAttribute;
@end

NS_ASSUME_NONNULL_END
