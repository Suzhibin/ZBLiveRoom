//
//  DouYinTableViewCell.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DouYinModel;
@class DouYinTableViewCell;
NS_ASSUME_NONNULL_BEGIN
@protocol DouYinTableViewCellDelegate

- (void)douYinCell:(DouYinTableViewCell*)cell startPlay:(BOOL)isPlay dyModel:(DouYinModel *)dyModel;

@end
@interface DouYinTableViewCell : UITableViewCell
@property (nonatomic, strong) DouYinModel *dyModel;
@property (nonatomic, weak)id<DouYinTableViewCellDelegate> cellDelegate;
- (void)pause;
- (void)playVideo;
@end

NS_ASSUME_NONNULL_END
