//
//  NDGiftAnimationImgView.m
//  OC_GiftAnimation
//
//  Created by ljq on 2019/2/12.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import "NDGiftAnimationImgView.h"

#define MAXCOUNT 9999

@interface NDGiftAnimationImgView ()
@property (nonatomic, strong) UIImageView *imageViewX;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *imageView4;

@end

@implementation NDGiftAnimationImgView

- (instancetype)init {
    if (self = [super init]) {
        [self setSubViewUI];
    }
    return self;
}

- (void)setShowCount:(NSInteger)showCount {
    // 1. 保持上线
    _showCount = showCount > MAXCOUNT ? MAXCOUNT : showCount;
    
    // 2. 到达上线后清零
    // _showCount = showCount;
    // while (_showCount > MAXCOUNT) {
    //     _showCount = _showCount - MAXCOUNT;
    // }
    
    NSString *textCount = [NSString stringWithFormat:@"%ld", _showCount];
    NSUInteger length = textCount.length;
    
    CGRect r = self.frame;
    r.size.width = 16 * (length + 1);
    self.frame = r;
    
    if (length >= 1) {
        self.imageView1.image = [self getImageView:[textCount substringWithRange:NSMakeRange(0, 1)]];
    } else {
        self.imageView1.image = nil;
    }
    
    if (length >= 2) {
        self.imageView2.image = [self getImageView:[textCount substringWithRange:NSMakeRange(1, 1)]];
    } else {
        self.imageView2.image = nil;
    }
    
    if (length >= 3) {
        self.imageView3.image = [self getImageView:[textCount substringWithRange:NSMakeRange(2, 1)]];
    } else {
        self.imageView3.image = nil;
    }
    
    if (length >= 4) {
        self.imageView4.image = [self getImageView:[textCount substringWithRange:NSMakeRange(3, 1)]];
    } else {
        self.imageView4.image = nil;
    }
}

- (UIImage *)getImageView:(NSString *)countStr {
    return [UIImage imageNamed:[NSString stringWithFormat:@"live_icon_gift_animate_%@",countStr]];
}

- (void)startAnimWithDuration:(NSTimeInterval)duration complate:(void (^)(void))complate {
    // delay : 延迟时间
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            
            self.transform = CGAffineTransformMakeScale(2, 2);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
    } completion:^(BOOL finished) {
        // Damping:弹簧效果 0~1  Velocity：初始速度
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            complate();
        }];
    }];
}

#pragma mark ------ UI
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat _wid = 18;
    CGFloat _hei = 25;
    self.imageViewX.frame = CGRectMake(0, 0, _wid, _hei);
    self.imageView1.frame = CGRectMake(_wid, 0, _wid, _hei);
    self.imageView2.frame = CGRectMake(_wid*2, 0, _wid, _hei);
    self.imageView3.frame = CGRectMake(_wid*3, 0, _wid, _hei);
    self.imageView4.frame = CGRectMake(_wid*4, 0, _wid, _hei);
}

- (void)setSubViewUI {
    [self addSubview:self.imageViewX];
    [self addSubview:self.imageView1];
    [self addSubview:self.imageView2];
    [self addSubview:self.imageView3];
    [self addSubview:self.imageView4];
}

#pragma mark ----- 懒加载
- (UIImageView *)imageViewX {
    if (!_imageViewX) {
        _imageViewX = [UIImageView new];
        _imageViewX.image = [UIImage imageNamed:@"live_icon_gift_animate_x"];
    }
    return _imageViewX;
}
- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [UIImageView new];
    }
    return _imageView1;
}
- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [UIImageView new];
    }
    return _imageView2;
}
- (UIImageView *)imageView3 {
    if (!_imageView3) {
        _imageView3 = [UIImageView new];
    }
    return _imageView3;
}
- (UIImageView *)imageView4 {
    if (!_imageView4) {
        _imageView4 = [UIImageView new];
    }
    return _imageView4;
}



@end
