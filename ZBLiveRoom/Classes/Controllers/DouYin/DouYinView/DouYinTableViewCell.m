//
//  DouYinTableViewCell.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "DouYinTableViewCell.h"
#import <Masonry/Masonry.h>

#import "DouYinModel.h"
#import "UIImageView+WebCache.h"


@interface DouYinTableViewCell()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UIButton * headBtn;
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UIButton * likeBtn;
@property (nonatomic,strong)UIButton * commentBtn;
@property (nonatomic,strong)UIButton * shareBtn;
@property (nonatomic,strong)UIButton * musicBtn;

@end
@implementation DouYinTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
          self.contentView.backgroundColor=[UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
       // [self initSubviews];
    }
    return self;
}
- (void)setDyModel:(DouYinModel *)dyModel{
    _dyModel=dyModel;
    //[self playVideo];
//    self.nameLabel.text=[NSString stringWithFormat:@"@%@",dyModel.nick_name];
//    self.titleLabel.text=dyModel.title;
//    NSLog(@"dyModel.head:%@",dyModel.head);
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dyModel.head]];
}
- (void)pause{
    if (self.cellDelegate) {
        [self.cellDelegate douYinCell:self startPlay:NO dyModel:self.dyModel];
     }
}
- (void)playVideo{
    if (self.cellDelegate) {
        [self.cellDelegate douYinCell:self startPlay:YES dyModel:self.dyModel];
      }
}
- (void)initSubviews{
   
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:titleLabel];
     [self.contentView bringSubviewToFront:titleLabel];
    self.titleLabel=titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-80);
        make.left.equalTo(@(16));
        make.height.equalTo(@(20));
    }];
    
    UILabel *nameLabel=[[UILabel alloc]init];
       nameLabel.font=[UIFont systemFontOfSize:18];
       nameLabel.textColor=[UIColor whiteColor];
       [self.contentView addSubview:nameLabel];
     [self.contentView bringSubviewToFront:nameLabel];
       self.nameLabel=nameLabel;
       [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(titleLabel.mas_top).offset(-10);
           make.left.equalTo(@(16));
           make.height.equalTo(@(20));
       }];
    
    UIButton *musicBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [musicBtn setImage:[UIImage imageNamed:@"douyin"] forState:UIControlStateNormal];
    [musicBtn addTarget:self action:@selector(musicBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:musicBtn];
    [self.contentView bringSubviewToFront:musicBtn];
    self.musicBtn=musicBtn;
    [musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.contentView.mas_bottom).offset(-80);
           make.right.equalTo(self.contentView.mas_right).offset(-16);
           make.width.height.equalTo(@(44));
    }];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareBtn];
    [self.contentView bringSubviewToFront:shareBtn];
    self.shareBtn=shareBtn;
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(musicBtn.mas_top).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.width.height.equalTo(@(44));
    }];
    
    UIButton *commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentBtn];
    [self.contentView bringSubviewToFront:commentBtn];
    self.commentBtn=commentBtn;
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(shareBtn.mas_top).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.width.height.equalTo(@(44));
    }];

    UIButton *likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"ss_icon_star_selected"] forState:UIControlStateSelected];
       
       [likeBtn addTarget:self action:@selector(likeBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
       [self.contentView addSubview:likeBtn];
    [self.contentView bringSubviewToFront:likeBtn];
       self.likeBtn=likeBtn;
       [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.bottom.equalTo(commentBtn.mas_top).offset(-20);
              make.right.equalTo(self.contentView.mas_right).offset(-16);
              make.width.height.equalTo(@(44));
       }];
    
    UIImageView *headImage=[[UIImageView alloc]init];
    headImage.layer.cornerRadius = 20;
    headImage.layer.masksToBounds = YES;
    [self.contentView addSubview:headImage];
    [self.contentView bringSubviewToFront:headImage];
    self.headImage=headImage;
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(likeBtn.mas_top).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
