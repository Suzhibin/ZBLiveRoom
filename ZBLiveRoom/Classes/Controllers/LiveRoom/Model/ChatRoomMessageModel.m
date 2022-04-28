//
//  ChatRoomMessageModel.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ChatRoomMessageModel.h"
#import <YYText/YYText.h>
@implementation ChatRoomMessageModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
      
    }
    return self;
}
- (void)initMsgAttribute{
    switch (self.mesType) {
        case 1:
            [self setUpComment];
            break;
        case 2:
            [self setUpAnnouncement];
            break;
        case 3:
            [self setUpMemberEnter];
            break;
        case 4:
            [self setUpGift];
            break;
        default:
            break;
    }
}
- (void)setUpComment{
    NSString *nameStr=[NSString stringWithFormat:@"%@：",self.user.name];
    NSMutableAttributedString *textView = [self setUpAttributedText:nameStr color:COLOR_UI_RED tap:YES];
    // 内容
    NSMutableAttributedString *content = [self setUpAttributedText:self.content color:[UIColor blackColor] tap:NO];
    [textView appendAttributedString:content];
     self.msgAttribText = textView;
    [self textLayoutSize:self.msgAttribText];
}
- (void)setUpAnnouncement{

    NSString *nameStr=[NSString stringWithFormat:@"系统公告："];
     NSMutableAttributedString *textView = [self setUpAttributedText:nameStr color:COLOR_UI_RED tap:NO];
    // 内容
    NSMutableAttributedString *content = [self setUpAttributedText:self.content color:[UIColor blackColor] tap:NO];
    [textView appendAttributedString:content];
    self.msgAttribText = textView;
    [self textLayoutSize:self.msgAttribText];
}
- (void)setUpMemberEnter{
    NSLog(@"self.user.name:%@",self.user.name);
    NSString *nameStr=[NSString stringWithFormat:@"%@：",self.user.name];
    NSMutableAttributedString *textView = [self setUpAttributedText:nameStr color:COLOR_UI_RED tap:YES];
       // 内容
    NSMutableAttributedString *content = [self setUpAttributedText:self.content color:[UIColor blackColor] tap:NO];
    [textView appendAttributedString:content];
    self.msgAttribText = textView;
    [self textLayoutSize:self.msgAttribText];
}
- (void)setUpGift{
    NSString *nameStr=[NSString stringWithFormat:@"%@：",self.user.name];
    NSMutableAttributedString *textView = [self setUpAttributedText:nameStr color:COLOR_UI_RED tap:YES];
       // 内容
    NSMutableAttributedString *content = [self setUpAttributedText:self.content color:[UIColor blackColor] tap:NO];
    [textView appendAttributedString:content];
    self.msgAttribText = textView;
    [self textLayoutSize:self.msgAttribText];
}

- (NSMutableAttributedString *)setUpAttributedText:(NSString *)text color:(UIColor *)color tap:(BOOL)isTap{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14]
                          range:NSMakeRange(0, [text length])];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:NSMakeRange(0, [text length])];
    return  AttributedStr;
}

- (void)textLayoutSize:(NSMutableAttributedString *)attrStr {

    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(k_SCREEN_WIDTH-20-self.msgWidth, CGFLOAT_MAX)options:options context:nil];
    self.msgHeight= ceilf(rect.size.height);
}

/*
- (void)textLayoutSize:(NSMutableAttributedString *)attribText {
    // 距离左边8  距离右边也为8
    CGFloat maxWidth = k_SCREEN_WIDTH - 20;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, MAXFLOAT) text:attribText];
    CGSize size = layout.textBoundingSize;
    
    if (size.height && size.height < 20) {
        size.height = 20;
    } else {
        // 再加上6=文字距离上下的间距
        size.height = size.height + 6;
    }
    
    self.msgHeight = size.height;
}

- (NSMutableAttributedString *)setUpAttributedText:(NSString *)text color:(UIColor *)color tap:(BOOL)isTap{
    if (text.length>0) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:text attributes:nil];
         attribute.yy_font = [UIFont systemFontOfSize:14];
         attribute.yy_color =color ;
         // 强制排版(从左到右)
         attribute.yy_baseWritingDirection = NSWritingDirectionLeftToRight;
         attribute.yy_writingDirection = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)];
         NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
         //paraStyle.lineSpacing = 0.0f;//行间距
         paraStyle.alignment = NSTextAlignmentLeft;
         paraStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
         attribute.yy_paragraphStyle = paraStyle;
        
        if (isTap) {
               __weak typeof(self) weakSelf = self;
               YYTextHighlight *highlight = [YYTextHighlight new];
               highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                   if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(msgAttributeTapAction)]) {
                       [weakSelf.delegate msgAttributeTapAction];
                   }
               };
               [attribute yy_setTextHighlight:highlight range:attribute.yy_rangeOfAll];
           }
        
         return  attribute;
    }
    return nil;
}
  */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
