//
//  SPDouYinControlView.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "SPDouYinControlView.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
@interface SPDouYinControlView()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UIButton * headBtn;
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UIButton * likeBtn;
@property (nonatomic,strong)UIButton * commentBtn;
@property (nonatomic,strong)UIButton * shareBtn;
@property (nonatomic,strong)UIButton * musicBtn;

@end
@implementation SPDouYinControlView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)setDyModel:(DouYinModel *)dyModel{
    _dyModel=dyModel;
    self.nameLabel.text=[NSString stringWithFormat:@"@%@",dyModel.nick_name];
      self.titleLabel.text=dyModel.title;
      NSLog(@"dyModel.head:%@",dyModel.thumbnail_url);
      [self.headImage sd_setImageWithURL:[NSURL URLWithString:dyModel.thumbnail_url]];
}
- (void)initSubviews{
   
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    [self addSubview:titleLabel];
    self.titleLabel=titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-100);
        make.left.equalTo(@(16));
        make.height.equalTo(@(20));
    }];
    
    UILabel *nameLabel=[[UILabel alloc]init];
       nameLabel.font=[UIFont systemFontOfSize:18];
       nameLabel.textColor=[UIColor whiteColor];
       [self addSubview:nameLabel];
       self.nameLabel=nameLabel;
       [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(titleLabel.mas_top).offset(-10);
           make.left.equalTo(@(16));
           make.height.equalTo(@(20));
       }];
    
    UIButton *musicBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [musicBtn setImage:[UIImage imageNamed:@"douyin"] forState:UIControlStateNormal];
    [musicBtn addTarget:self action:@selector(musicBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:musicBtn];
    self.musicBtn=musicBtn;
    [musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.mas_bottom).offset(-100);
           make.right.equalTo(self.mas_right).offset(-16);
           make.width.height.equalTo(@(44));
    }];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    self.shareBtn=shareBtn;
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(musicBtn.mas_top).offset(-20);
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.height.equalTo(@(44));
    }];
    
    UIButton *commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentBtn];
    self.commentBtn=commentBtn;
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(shareBtn.mas_top).offset(-20);
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.height.equalTo(@(44));
    }];

    UIButton *likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"ss_icon_star_selected"] forState:UIControlStateSelected];
       
       [likeBtn addTarget:self action:@selector(likeBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:likeBtn];
       self.likeBtn=likeBtn;
       [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.bottom.equalTo(commentBtn.mas_top).offset(-20);
              make.right.equalTo(self.mas_right).offset(-16);
              make.width.height.equalTo(@(44));
       }];
    
    UIImageView *headImage=[[UIImageView alloc]init];
    headImage.layer.cornerRadius = 20;
    headImage.layer.masksToBounds = YES;
    [self addSubview:headImage];
    self.headImage=headImage;
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(likeBtn.mas_top).offset(-20);
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.height.equalTo(@(44));
    }];
    
//    UIButton *headBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [headBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//    [headBtn addTarget:self action:@selector(headBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:headBtn];
//    self.headBtn=headBtn;
//    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.bottom.equalTo(likeBtn.mas_top).offset(-15);
//           make.right.equalTo(self.contentView.mas_right).offset(-16);
//           make.width.height.equalTo(@(44));
//    }];
}
- (void)musicBtn_Action:(UIButton *)sender{
    
}
- (void)headBtn_Action:(UIButton *)sender{
    
}
- (void)commentBtn_Action:(UIButton *)sender{
    
}
- (void)likeBtn_Action:(UIButton *)sender{
    sender.selected=!sender.selected;
}
- (void)shareBtn_Action:(UIButton *)sender{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
