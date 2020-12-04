//
//  DouYinModel.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DouYinModel : NSObject
@property (nonatomic,copy)NSString *head;
///地址
@property (nonatomic,copy)NSString *video_url;
/// 作者
@property (nonatomic,copy)NSString *nick_name;
///视频title
@property (nonatomic,copy)NSString *title;
///图片
@property (nonatomic,copy)NSString *thumbnail_url;
@end

NS_ASSUME_NONNULL_END
