//
//  ChatInputBoardView.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatInputBoardView;
NS_ASSUME_NONNULL_BEGIN
#define ChatKeyBoardInputViewH      50     //输入部分的高度
#define ChatKeyBordBottomHeight     220    //底部视图的高度

//键盘总高度
#define ChatKeyBordHeight   ChatKeyBoardInputViewH + ChatKeyBordBottomHeight

#define ChatBtnSize           34           //按钮的大小
#define ChatLeftDistence      5            //左边间隙
#define ChatRightDistence     5            //左边间隙
#define ChatBtnDistence       10           //控件之间的间隙
#define ChatTextHeight        34           //输入框的高度
#define ChatTextMaxHeight   ((MAIN_SCREEN_HEIGHT == 667.0f) ? 50 : 83)           //输入框的最大高度
#define ChatTextWidth      MAIN_SCREEN_WIDTH - (16+16+10+55)                    //输入框的宽度

#define ChatTBottomDistence   8            //输入框上下间隙
#define ChatBBottomDistence   8.5          //按钮上下间隙

#define NAVBAR_HEIGHT       self.navigationController.navigationBar.frame.size.height
#define safeAreaBottomHeight (CGFloat)(IS_IPhoneX_All?(34.0):(0.0))
#define safeAreaTopHeight (CGFloat)(IS_IPhoneX_All?(44.0):(22.0))
#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define MAIN_SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define MAIN_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/**
 底部按钮点击的状态
 */
typedef NS_ENUM(NSInteger,BJXChatKeyBoardStatus) {
    BJXChatKeyBoardStatusDefault=1,//默认在底部的状态
    BJXChatKeyBoardStatusEdit,//准备编辑文本的状态
    BJXChatKeyBoardStatusAdd//其他状态
};
@protocol ChatInputBoardViewDelegate <NSObject>
@optional
//键盘高度改变
-(void)chatKeyInputBoardHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime;

//发送文本信息
-(void)chatKeyInputBoardView:(ChatInputBoardView *)inputBoardView messageText:(NSString *)messageText;
@end
@interface ChatInputBoardView : UIView<UITextViewDelegate>
@property(nonatomic,weak)id<ChatInputBoardViewDelegate>delegate;

@property(nonatomic,strong) UIButton *sendBtn;
//占位文字
@property(nonatomic,copy)NSString *placeHolder;
//输入框 最大输入文字数量
@property(nonatomic,assign)NSInteger maxFontNum;
//是否禁言
@property(nonatomic,assign)BOOL isBanned;
//输入框内容
@property(nonatomic,assign)NSString * content;
///发送消息
- (void)startSendMessage;
///手动弹出键盘
- (void)becomeFirstResponder;
///键盘归位
-(void)setChatKeyBoardInputViewEndEditing;
@end

NS_ASSUME_NONNULL_END
