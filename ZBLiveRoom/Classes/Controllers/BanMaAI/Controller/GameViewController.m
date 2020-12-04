//
//  GameViewController.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/11/30.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "GameViewController.h"
#import "Macro.h"
#import "GameSubView.h"
#import "ScoreView.h"
@interface GameViewController ()<ScoreViewDelegate>
@property(nonatomic,strong)UIView *bjView;
@property(nonatomic,strong)GameSubView *subView;
@property(nonatomic,strong)UIImageView *image1;
@property(nonatomic,strong)ScoreView *scoreView;
@property(nonatomic,assign)BOOL isTouch;
@property(nonatomic,strong)NSMutableArray * subArray;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"palyisFullScreen" object:self userInfo:@{@"isFullScreen":@(YES)}];
    [self gameUI];
    [self createBtn];
    [self createScore];
}
- (void)createScore{
    self.scoreView=[[ScoreView alloc]initWithFrame:CGRectMake(0, 0, k_SCREEN_WIDTH, k_SCREEN_HEIGHT)];
    self.scoreView.delegate=self;
    [self.view addSubview:self.scoreView];
}
- (void)gameUI{
    UIView *bjView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    bjView.layer.cornerRadius = 10.0f;
    bjView.layer.masksToBounds = YES;
    bjView.backgroundColor=[UIColor colorWithRed: 247/255.0 green: 212/255.0 blue: 80/255.0 alpha:1.000];
    bjView.center=self.view.center;
    [self.view addSubview:bjView];
    self.bjView=bjView;

    CGFloat wSpace = (200-90*2)/3;
    CGFloat hSpace = (200-2*90)/3;
    for (int i = 0; i<4; i++) {
        GameSubView *subView= [[GameSubView alloc]init];
        subView.frame=CGRectMake(wSpace+(i%2)*(wSpace+90), hSpace+(i/2)*(hSpace+90), 90, 90);
        [bjView addSubview:subView];
        if (i==2) {
            UIImageView *star=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
            if (@available(iOS 13.0, *)) {
                star.image=[UIImage systemImageNamed:@"sparkles"];
                star.tintColor=[UIColor colorWithRed: 255/255.0 green: 165/255.0 blue: 0/255.0 alpha:1.000];
            }else{
                star.backgroundColor=[UIColor redColor];
            }
            [subView addSubview:star];
            self.subView=subView;
        }
    }
    
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(320-105, 2+5+15, 60, 60)];
    image1.layer.cornerRadius = 30;
    image1.layer.masksToBounds = YES;
    image1.backgroundColor=[UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        image1.image=[UIImage systemImageNamed:@"1.circle"];
    }
    [bjView addSubview:image1];
    self.image1=image1;
    
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(320-90, 2+5+15+60+50, 30, 30)];
    if (@available(iOS 13.0, *)) {
        image2.image=[UIImage systemImageNamed:@"bolt"];
        image2.tintColor=[UIColor colorWithRed: 245/255.0 green: 199/255.0 blue: 44/255.0 alpha:1.000];
    }
    [bjView addSubview:image2];
}
#pragma mark - ScoreViewDelegate
- (void)scoreHideComplete{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(gameComplete)]) {
            [self.delegate gameComplete];
        }
    }];
}
#pragma mark - UITouch方法
// 用户触碰时自动调用的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取到触碰的对象
    UITouch *touch = [touches anyObject];
    // 获取我们触碰的点得坐标
    CGPoint point = [touch locationInView:self.bjView];
   // NSLog(@"point = %@",NSStringFromCGPoint(point));
    // 如果我们触碰的点，在范围以内返回YES
    if (CGRectContainsPoint(self.image1.frame, point)) {
        self.isTouch = YES;  // 被我们点中了
    }
}
// 用户触碰移动时自动调用的方法 (不停的调用)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isTouch) {
        UITouch *touch = [touches anyObject];
        // 获取当前点得坐标
        CGPoint curPoint = [touch locationInView:self.bjView];
        // 获取上一个点得坐标!
        CGPoint prePoint = [touch previousLocationInView:self.bjView];
     
        CGPoint center = self.image1.center;
        center.x += curPoint.x - prePoint.x;
        center.y += curPoint.y - prePoint.y;
        self.image1.center = center;
    }
}

// 用户触碰结束时自动调用的方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isTouch = NO;  // 手指抬起，点中被取消
    CGPoint point1=self.subView.center;
    CGRect rect2=self.image1.frame;
    if (CGRectContainsPoint(rect2, point1)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.image1.center=point1;
        }completion:^(BOOL finished) {
            [self.scoreView show];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.image1.frame=CGRectMake(320-105, 2+5+15, 60, 60);
        }];
    }
}

// 触碰被取消时自动调用的方法 (电话，home，锁屏)
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)createBtn{
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 10, 44, 44);
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 13.0, *)) {
        [backBtn setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    } else {
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    }
    [self.view addSubview:backBtn];
    
    UIButton *speakBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    speakBtn.frame=CGRectMake(10, k_SCREEN_HEIGHT-50, 44, 44);
   // [speakBtn addTarget:self action:@selector(speakBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 13.0, *)) {
        [speakBtn setImage:[UIImage systemImageNamed:@"speaker.2"] forState:UIControlStateNormal];
    } else {
        [speakBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
    [self.view addSubview:speakBtn];
}

- (void)backBtnClick:(UIButton *)sender{
    [self scoreHideComplete];
}
@end
