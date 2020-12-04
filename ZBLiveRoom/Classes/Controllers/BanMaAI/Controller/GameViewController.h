//
//  GameViewController.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/11/30.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol GameViewControllerDelegate <NSObject>
@optional

- (void)gameComplete;
@end
@interface GameViewController : UIViewController
@property(nonatomic,weak)id<GameViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
