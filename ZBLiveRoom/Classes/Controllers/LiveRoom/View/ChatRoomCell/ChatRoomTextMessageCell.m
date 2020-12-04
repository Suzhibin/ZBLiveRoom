//
//  ChatRoomTextMessageCell.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ChatRoomTextMessageCell.h"
#import "ChatRoomMessageModel.h"

@implementation ChatRoomTextMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addLongPressGes];
    }
    return self;
}
- (void)setMsgModel:(ChatRoomMessageModel *)msgModel{
    [super setMsgModel:msgModel];
    self.msgLabel.attributedText=msgModel.msgAttribText;
}
- (void)msgAttributeTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellMessageAttributeClick:)]) {
        [self.delegate cellMessageAttributeClick:self.msgModel];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
