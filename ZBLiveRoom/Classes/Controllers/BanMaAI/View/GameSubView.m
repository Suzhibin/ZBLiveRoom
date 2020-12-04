//
//  GameSubView.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/12/1.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "GameSubView.h"

@implementation GameSubView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed: 254/255.0 green: 244/255.0 blue: 217/255.0 alpha:1.000];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        
        
        self.roundView=[[UIView alloc]init];
        self.roundView.backgroundColor=[UIColor colorWithRed: 235/255.0 green: 189/255.0 blue: 74/255.0 alpha:1.000];
        self.roundView.layer.cornerRadius = 30.0f;
        self.roundView.layer.masksToBounds = YES;
        [self addSubview:self.roundView];
     
        self.roundView.center=self.center;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.roundView.frame=CGRectMake(15, 15, 60, 60);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
