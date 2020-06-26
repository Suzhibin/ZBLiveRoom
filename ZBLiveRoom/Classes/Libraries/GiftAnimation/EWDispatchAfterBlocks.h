//
//  EWDispatchAfterBlocks.h
//  ShowMe
//
//

#import <Foundation/Foundation.h>

/** Block 延时执行和取消 */

/** 调用：
 EWDelayedBlockHandle _delayedBlockHandle; // 成员变量
 _delayedBlockHandle = perform_block_after_delay(秒数, ^{
    // 执行内容
 });
 立刻执行（取消延时）:
 cancel_delayed_block(_delayedBlockHandle);
 */

typedef void(^EWDelayedBlockHandle)(BOOL cancel);

static EWDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t delayedBlock) {
    
    if (delayedBlock == nil) {
        return nil;
    }
    
    __block dispatch_block_t blockToExecute = [delayedBlock copy];
    __block EWDelayedBlockHandle delayHandleCopy = nil;
    
    EWDelayedBlockHandle delayHandle = ^(BOOL cancel) {
        if (cancel == NO && blockToExecute != nil) {
            dispatch_async(dispatch_get_main_queue(), blockToExecute);
        }
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_queue_create("com.delayHandle.ew", DISPATCH_QUEUE_SERIAL), ^{
        if (delayHandleCopy != nil) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
};


//  立刻执行（取消延时）
static void cancel_delayed_block(EWDelayedBlockHandle delayedHandle) {
    if (delayedHandle == nil) {
        return;
    }
    
    delayedHandle(YES);
}

