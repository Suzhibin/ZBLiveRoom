//
//  ChatRoomBaseCell.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ChatRoomBaseCell.h"

@implementation ChatRoomBaseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        //[UIColor colorWithRed:(240)/255.0 green:(242)/255.0 blue:(245)/255.0 alpha:(1)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}
- (void)setMsgModel:(ChatRoomMessageModel *)msgModel{
    _msgModel=msgModel;
    _msgModel.delegate=self;
}
// 添加长按点击事件
- (void)addLongPressGes {
    self.msgLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
    longPressGes.minimumPressDuration = 0.3;
    [self.msgLabel addGestureRecognizer:longPressGes];
}

// 长按手势
- (void)longPressGes:(UILongPressGestureRecognizer *)longGes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellLongPressClick:)]) {
        [self.delegate cellLongPressClick:self.msgModel];
    }
}
- (void)initSubviews{
    [self.contentView addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(@(10));
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    MASAttachKeys(self.msgLabel);
}
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.font =  [UIFont systemFontOfSize:14];
        _msgLabel.textColor = [UIColor colorWithRed:(51)/255.0 green:(51)/255.0 blue:(51)/255.0 alpha:(1)];
        _msgLabel.numberOfLines = 0;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.clipsToBounds = YES;
        //_msgLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _msgLabel.userInteractionEnabled = YES;
        // 强制排版(从左到右)
        _msgLabel.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
    return _msgLabel;
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.userInteractionEnabled = NO;
    }
    return _bgImage;
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
