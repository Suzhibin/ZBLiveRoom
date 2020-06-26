//
//  NSMutableArray+Check.h
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/21.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Check)
- (id)objectAtIndexCheck:(NSUInteger)index;

- (void)addObjectCheck:(id)anObject;

- (void)insertObjectCheck:(id)anObject atIndex:(NSUInteger)index;

- (void)removeObjectAtIndexCheck:(NSUInteger)index;

- (void)replaceObjectAtIndexCheck:(NSUInteger)index withObject:(id)anObject;
@end

NS_ASSUME_NONNULL_END
