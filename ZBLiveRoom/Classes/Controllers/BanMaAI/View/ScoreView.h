//
//  ScoreView.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/12/1.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ScoreViewDelegate <NSObject>
@optional

- (void)scoreHideComplete;
@end
@interface ScoreView : UIView
@property(nonatomic,weak)id<ScoreViewDelegate>delegate;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
