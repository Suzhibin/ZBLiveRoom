//
//  ChatRoomSystemMessageCell.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ChatRoomSystemMessageCell.h"
#import "ChatRoomMessageModel.h"
@implementation ChatRoomSystemMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        }];
    }
    return self;
}
- (void)setMsgModel:(ChatRoomMessageModel *)msgModel{
    [super setMsgModel:msgModel];
    self.msgLabel.attributedText=msgModel.msgAttribText;
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
