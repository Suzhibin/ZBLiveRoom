//
//  ScoreView.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/12/1.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ScoreView.h"
#import <Masonry/Masonry.h>
@interface ScoreView ()
@property (nonatomic,strong)UIImageView *star1;
@property (nonatomic,strong)UIImageView *star2;
@property (nonatomic,strong)UIImageView *star3;
@property (nonatomic,strong)UILabel *label;
@end
@implementation ScoreView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden=YES;
        self.backgroundColor=[UIColor clearColor];

        [self createUI];
    }
    return self;
}
- (void)createUI{
    UIImageView *star1=[[UIImageView alloc]init];
    star1.alpha=0;
    star1.hidden=YES;
    if (@available(iOS 13.0, *)) {
        star1.image=[UIImage systemImageNamed:@"sparkles"];
        star1.tintColor=[UIColor colorWithRed: 255/255.0 green: 165/255.0 blue: 0/255.0 alpha:1.000];
    }else{
        star1.backgroundColor=[UIColor redColor];
    }
    [self addSubview:star1];
    self.star1=star1;
    
    UIImageView *star2=[[UIImageView alloc]init];
    star2.alpha=0;
    star2.hidden=YES;
    if (@available(iOS 13.0, *)) {
        star2.image=[UIImage systemImageNamed:@"sparkles"];
        star2.tintColor=[UIColor colorWithRed: 255/255.0 green: 165/255.0 blue: 0/255.0 alpha:1.000];
    }else{
        star2.backgroundColor=[UIColor redColor];
    }
    [self addSubview:star2];
    self.star2=star2;
    
    [star2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@(90));
        make.width.height.equalTo(@(60));
    }];
    
    [star1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(star2.mas_left).offset(-20);
        make.top.equalTo(@(120));
        make.width.height.equalTo(@(60));
    }];
    
    UIImageView *star3=[[UIImageView alloc]init];
    star3.alpha=0;
    star3.hidden=YES;
    if (@available(iOS 13.0, *)) {
        star3.image=[UIImage systemImageNamed:@"sparkles"];
        star3.tintColor=[UIColor colorWithRed: 255/255.0 green: 165/255.0 blue: 0/255.0 alpha:1.000];
    }else{
        star3.backgroundColor=[UIColor redColor];
    }
    [self addSubview:star3];
    self.star3=star3;
    [star3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(star2.mas_right).offset(20);
        make.top.equalTo(@(120));
        make.width.height.equalTo(@(60));
    }];
    
    UILabel *label=[[UILabel alloc]init];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:25];
    label.textColor=[UIColor whiteColor];
    label.text=@"你真棒";
    label.hidden=YES;
    label.backgroundColor=[UIColor orangeColor];
    [self addSubview:label];
    self.label=label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(star1.mas_bottom).offset(30);
        make.width.equalTo(@(200));
    }];
}
- (void)show{
    self.hidden=NO;
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.label.hidden=NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.star1.alpha=1;
    }completion:^(BOOL finished) {
        self.star1.hidden=NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.star2.alpha=1;
        }completion:^(BOOL finished) {
            self.star2.hidden=NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.star3.alpha=1;
            }completion:^(BOOL finished) {
                self.star3.hidden=NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hide];
                    if ([self.delegate respondsToSelector:@selector(scoreHideComplete)]) {
                        [self.delegate scoreHideComplete];
                    }
                });
            }];
        }];
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.star1.alpha=0;
        self.star2.alpha=0;
        self.star3.alpha=0;
    }completion:^(BOOL finished) {
        self.star1.hidden=YES;
        self.star2.hidden=YES;
        self.star3.hidden=YES;
        self.hidden=YES;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
