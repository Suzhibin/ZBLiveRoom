//
//  NDGiftAnimationView.m
//  OC_GiftAnimation
//
//  Created by ljq on 2019/1/25.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import "NDGiftAnimationView.h"
#import "NDGiftAnimationImgView.h"
#import "EWDispatchAfterBlocks.h"
#import "UIView+Frame.h"
#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
blue:((float)(v & 0x0000FF))/255.0 \
alpha:a]
#define NDBezier(view, corners, rads)\
\
{[view layoutIfNeeded];\
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(rads, rads)];\
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];\
maskLayer.frame = view.bounds;\
maskLayer.path = maskPath.CGPath;\
view.layer.mask = maskLayer;\
}
@interface NDGiftAnimationView()

@property (nonatomic, strong) NDGiftAnimationImgView *animationImgView;

//记录原始坐标
@property (nonatomic, assign) CGRect originFrame;
// 停留时间 默认3秒
@property (nonatomic, assign) CGFloat timeFloat;

@property (nonatomic, strong) UIView *backgroupView;
@property (nonatomic, strong) UIImageView *headImageView; // 头像
@property (nonatomic, strong) UIImageView *giftImageView; // 礼物
@property (nonatomic, strong) UILabel *nameLabel; // 送礼物者
@property (nonatomic, strong) UILabel *giftLabel; // 礼物名称

////////////////////// 辅助属性 //////////////////////
@property (nonatomic, assign) NSInteger currentIndex;
/** 礼物结束动画结束 */
@property (nonatomic, strong) void(^finishedBlock)(NDGiftModel *gift);
@property (nonatomic, strong) EWDelayedBlockHandle delayedBlockHandle;

@end

@implementation NDGiftAnimationView

- (instancetype)init {
    if (self = [super init]) {
        _timeFloat = 3.0;
        self.userInteractionEnabled = YES;
        self.alpha = 0.0;
        
        [self setUI];
    }
    return self;
}

- (void)startAnimationWithGift:(NDGiftModel *)gift finishedBlock:(void (^)(NDGiftModel * _Nonnull))finishedBlock {
    
    self.animationStatus = NDAnimationStatusStart;
    self.currentGift = gift;
    
    self.finishedBlock = finishedBlock;
    self.originFrame = self.frame;
    
    [UIView animateWithDuration:AnimationStartDuration animations:^{
        self.alpha = 1.0;
        // 该动画是将X轴设置为0 横向移动效果
        self.x=0;
    } completion:^(BOOL finished) {
        [self doShakeNumberLabel];
    }];
}

- (BOOL)animationStatusWith:(NDGiftModel *)gift {
    // 是否同用户同礼物  判断唯一的key
    if ([self.currentGift.giftKey isEqualToString:gift.giftKey]) {
        // 礼物即将结束或者处于未启动状态
        if (self.animationStatus == NDAnimationStatusUnknown || self.animationStatus == NDAnimationStatusEnd) {
            return NO;
        }
        // 礼物处于开始动画中
        if (self.animationStatus == NDAnimationStatusStart) {
            self.currentGift.giftCount = gift.giftCount;
            self.currentGift.doubleHitCount += self.currentGift.giftCount;
            return YES;
        }
        // 礼物处于连击状态
        if (self.animationStatus == NDAnimationStatusSerial) {
            self.currentGift.giftCount = gift.giftCount;
            self.currentGift.doubleHitCount += self.currentGift.giftCount;
            return YES;
        }
        // 礼物停止运行动画，处于停止中
        if (self.animationStatus == NDAnimationStatusStop) {
            self.currentGift.giftCount = gift.giftCount;
            self.currentGift.doubleHitCount += self.currentGift.giftCount;
            // 连击
            [self doShakeNumberLabel];
            return YES;
        }
    }
    return NO;
}


- (void)doShakeNumberLabel {
    [self cleanDelayedBlockHandle];
    
    self.animationStatus = NDAnimationStatusSerial;
    _currentIndex = self.currentGift.doubleHitCount;
    self.animationImgView.showCount = _currentIndex;
    
    __weak typeof(self) weakSelf = self;;
    [self.animationImgView startAnimWithDuration:AnimationSerialDuration complate:^{
        // 判断礼物连击是否达到上限 
        if (weakSelf.currentIndex >= weakSelf.currentGift.doubleHitCount) {
            
            // 更新礼物状态处于静止中
            weakSelf.animationStatus = NDAnimationStatusStop;
            weakSelf.delayedBlockHandle = perform_block_after_delay(weakSelf.timeFloat, ^{
                [weakSelf endAnimation];
            });
        } else { // 递归 继续连击
            [weakSelf doShakeNumberLabel];
        }
    }];
}

- (void)endAnimation {
    self.animationStatus = NDAnimationStatusEnd;
    __weak typeof(self) weakSelf = self;;
    // 该动画是向上移动一小段距离的效果 隐藏
    [UIView animateWithDuration:AnimationEndDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.y -= 10;
        weakSelf.alpha = 0.0; // 渐变逐渐隐藏
    } completion:^(BOOL finished) {
        weakSelf.frame = weakSelf.originFrame;
        weakSelf.alpha = 0.0;
        weakSelf.animationStatus = NDAnimationStatusUnknown;
        weakSelf.currentGift = nil;
        if (weakSelf.finishedBlock) {
            weakSelf.finishedBlock(weakSelf.currentGift);
        }
    }];
}

- (void)cleanDelayedBlockHandle {
    if (_delayedBlockHandle) {
        _delayedBlockHandle(YES);
        _delayedBlockHandle = nil;
    }
}

#pragma mark - GETTER - SETTER
- (void)setCurrentGift:(NDGiftModel *)currentGift {
    _currentGift = currentGift;
    if (!_currentGift) return;
    
    // 刷新新的礼物气泡停留时间
    _timeFloat = _currentGift.time;
    
    _headImageView.image = [UIImage imageNamed:@"PlaceHoder_User_Head_big"];
    if (currentGift.giftImageName) {
        _giftImageView.image = [UIImage imageNamed:currentGift.giftImageName];
    }else{
       _giftImageView.image = [UIImage imageNamed:@"gift_icon_0"];
    }
    //[_headImageView ND_SetURLImageWithURLStr:_currentGift.user.avatar placeHoldImage:EWGetImage(@"PlaceHoder_User_Head_big") style:DLImageSizeStyle_1x];
    //[_giftImageView ND_SetURLImageWithURLStr:_currentGift.gift.thumbnailUrl placeHoldImage:nil style:DLImageSizeStyle_1x];
    _nameLabel.text = _currentGift.userName;
    _giftLabel.attributedText = [self getGiftName];
    
    _currentIndex = _currentGift.doubleHitCount;
    self.animationImgView.showCount = _currentIndex;
}

- (NSAttributedString *)getGiftName {
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"送出"];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", _currentGift.giftName]];
    
    [str1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, str1.length)];
    [str2 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:RGBAOF(0xFFF7AA, 1.0)} range:NSMakeRange(0, str2.length)];
    
    [str1 appendAttributedString:str2];
    
    return str1;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    [super layoutSubviews];
    _backgroupView.frame = CGRectMake(8, 0,self.frame.size.width, self.frame.size.height);
    NDBezier(_backgroupView, UIRectCornerAllCorners, self.frame.size.height / 2);
    
    _headImageView.frame = CGRectMake(3, 3, 24, 24);
    _headImageView.layer.cornerRadius=24/2;
    _headImageView.layer.masksToBounds=YES;
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame)+2, 2, 88, 15);
    
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame), 88, 12);
    
    _giftImageView.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+3, 0, self.frame.size.height, self.frame.size.height);
    
    // CGRectGetMaxX(_giftImageView.frame)
    _animationImgView.frame = CGRectMake(CGRectGetMaxX(_backgroupView.frame),2, 32, self.frame.size.height);
    _animationImgView.transform = CGAffineTransformMakeRotation(M_1_PI/6);
}

#pragma mark 初始化 UI
- (void)setUI {
    _backgroupView = [[UILabel alloc] init];
    _backgroupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    _headImageView = [[UIImageView alloc] init];
    _giftImageView = [[UIImageView alloc] init];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    
    
    _giftLabel = [[UILabel alloc] init];
    _giftLabel.textColor = RGBAOF(0xffe239, 1.0);
    _giftLabel.textAlignment = NSTextAlignmentLeft;
    _giftLabel.font = [UIFont systemFontOfSize:10];
    
    // 初始化动画label
    _animationImgView = [[NDGiftAnimationImgView alloc] init];
    
    [self addSubview:_backgroupView];
    [_backgroupView addSubview:_headImageView];
    [_backgroupView addSubview:_giftImageView];
    [_backgroupView addSubview:_nameLabel];
    [_backgroupView addSubview:_giftLabel];
    [self addSubview:_animationImgView];
}

- (void)dealloc {
    NSLog(@"EWAnimationView释放");
}


@end
