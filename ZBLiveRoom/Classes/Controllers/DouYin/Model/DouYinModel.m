//
//  DouYinModel.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "DouYinModel.h"

@implementation DouYinModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
