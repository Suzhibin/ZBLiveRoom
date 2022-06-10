//
//  ZBChatRoomView.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/21.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ZBChatRoomView.h"
#import "ChatRoomBaseCell.h"
#import "ChatRoomTextMessageCell.h"
#import "ChatRoomSystemMessageCell.h"
#import "NSMutableArray+Check.h"
@interface ZBChatRoomView ()<UITableViewDelegate,UITableViewDataSource,ChatRoomBaseCellDelegate>
@property (nonatomic,strong)NSMutableArray<ChatRoomMessageModel *> *dataArray;//正式数据
@property (nonatomic,strong)NSMutableArray<ChatRoomMessageModel *> *tempMsgArray;//临时数据
@property (nonatomic,strong)UIButton * moreButton;//新消息按钮
@property (nonatomic) dispatch_source_t timer;
@end
@implementation ZBChatRoomView
- (void)dealloc {
    NSLog(@"dealloc-----%@", NSStringFromClass([self class]));
}
- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self reset];
}
- (instancetype)init{
    if(self = [super init]){
        //_mutex = PTHREAD_MUTEX_INITIALIZER;
        self.backgroundColor = [UIColor whiteColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tableView];
        [self addSubview:self.moreButton];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];

        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.left.equalTo(@(10));
            make.width.equalTo(@(80));
            make.height.equalTo(@(25));
        }];
    }
    return self;
}
- (void)setReloadType:(ZBReloadChatRoomType)reloadType {
    _reloadType = reloadType;
    if (_reloadType == ZBReloadChatRoomType_Time) {
        [self createTimer];
    }
}
- (void)createTimer{
    [self stopTimer];
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.5*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf checkReloadData];
        });
    });
    dispatch_resume(_timer);
}
- (void)stopTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
//清空消息重置
- (void)reset {
    [self stopTimer];
    [self.dataArray removeAllObjects];
    [self.tempMsgArray removeAllObjects];
    [self.tableView reloadData];
    self.moreButton.hidden = YES;
}
#pragma mark - 添加消息
- (void)sendChatRoomMessage:(ChatRoomMessageModel *)msgModel{
    if (!msgModel) return;
    [self.tempMsgArray addObject:msgModel];
    if (_reloadType == ZBReloadChatRoomType_Direct) {
        [self checkReloadData];
    }
}
- (void)checkReloadData{
    [self updateMoreBtnHidden];
    if (!self.inPending) {
        [self reloadDataAndScrollToBottom];
    }
}
- (void)reloadDataAndScrollToBottom{
    if (self.tempMsgArray.count < 1) {
        return;
    }
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (ChatRoomMessageModel *msgModel in self.tempMsgArray) {
        [self.dataArray addObjectCheck:msgModel];
        [indexPaths addObjectCheck:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0]];
    }

   [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tempMsgArray removeAllObjects];
    /**
    iphone 6s  测试大于1400条 会卡，可以根据具体情况适当调整下面的数值
     */
    if (self.dataArray.count>500) {//如果大于500 删除前200条 保持流畅度
        [self.dataArray removeObjectsInRange:NSMakeRange(0,200)];
        [self.tableView reloadData];
    }
    
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
#pragma mark - 爬楼判断
- (void)setInPending:(BOOL)inPending {
    _inPending = inPending;
    [self updateMoreBtnHidden];
}
- (void)updateMoreBtnHidden {
    if (self.inPending && self.tempMsgArray.count > 0) {
        NSString *str=[NSString stringWithFormat:@"%ld 条新消息",self.tempMsgArray.count];
        [_moreButton setTitle:str forState:UIControlStateNormal];
        self.moreButton.hidden = NO;
    } else {
        self.moreButton.hidden = YES;
    }
}
#pragma mark -新消息按钮事件
- (void)moreClick:(UIButton *)sender {
    [self reloadDataAndScrollToBottom];
    self.inPending = NO;
}
#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.inPending = YES;// 手动拖拽开始
    if (self.delegate && [self.delegate respondsToSelector:@selector(startScroll)]) {
        [self.delegate startScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 手动拖拽结束（decelerate：0松手时静止；1松手时还在运动,会触发DidEndDecelerating方法）
    NSLog(@"decelerate:%d",decelerate);
    if (!decelerate) {
        [self finishDraggingWith:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self finishDraggingWith:scrollView];// 静止后触发（手动）
}
/** 手动拖拽动作彻底完成(减速到零) */
- (void)finishDraggingWith:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endScroll)]) {
           [self.delegate endScroll];
    }
    CGFloat contentSizeH = scrollView.contentSize.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat sizeH = scrollView.frame.size.height;
    self.inPending = contentSizeH - contentOffsetY - sizeH > 20.0;
    [self checkReloadData];// 如果不处在爬楼状态，追加数据源并滚动到底部
    NSLog(@"Offset：%f，contentSizef：%f, frame：%f", contentOffsetY, contentSizeH, sizeH);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRoomMessageModel *msgModel = [self.dataArray objectAtIndexCheck: indexPath.row];
    return msgModel.msgHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatRoomMessageModel *msgModel=[self.dataArray objectAtIndexCheck: indexPath.row];
    NSString *identifier= [self cellIdentifier:msgModel];
    ChatRoomBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.msgModel=msgModel;
    cell.delegate=self;
    return cell;
}
- (NSString *)cellIdentifier:(ChatRoomMessageModel *)msgModel{
    if (msgModel.mesType==1) {
        return NSStringFromClass([ChatRoomTextMessageCell class]);//文本消息
    }else{
        return NSStringFromClass([ChatRoomSystemMessageCell class]);//系统消息
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatRoomMessageModel *msgModel=[self.dataArray objectAtIndexCheck: indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidSelectClick:)]) {
        [self.delegate cellDidSelectClick:msgModel];
    }
}
#pragma mark - ChatRoomBaseCellDelegate
- (void)cellLongPressClick:(ChatRoomMessageModel *)msgModel{
    NSLog(@"长按");
}
- (void)cellMessageAttributeClick:(ChatRoomMessageModel *)msgModel{
    NSLog(@"点击");
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor colorWithRed:(240)/255.0 green:(242)/255.0 blue:(245)/255.0 alpha:(1)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive|UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.tableFooterView=[UIView new];
        if (@available(iOS 11.0,*))  {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        //[_tableView registerClass:[ChatRoomBaseCell class] forCellReuseIdentifier:NSStringFromClass([ChatRoomBaseCell class])];
        [_tableView registerClass:[ChatRoomSystemMessageCell class] forCellReuseIdentifier:NSStringFromClass([ChatRoomSystemMessageCell class])];
        [_tableView registerClass:[ChatRoomTextMessageCell class] forCellReuseIdentifier:NSStringFromClass([ChatRoomTextMessageCell class])];
    }
    return _tableView;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreButton setTitleColor:[UIColor redColor] forState:normal];
        _moreButton.backgroundColor = [UIColor whiteColor];
        _moreButton.hidden = YES;
        _moreButton.layer.borderWidth = 0.5;
        _moreButton.layer.borderColor = [[UIColor redColor] CGColor];
        _moreButton.layer.masksToBounds = YES;
        _moreButton.layer.cornerRadius=8;
        [_moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (NSMutableArray *)tempMsgArray {
    if(!_tempMsgArray){
        _tempMsgArray = [NSMutableArray array];
    }
    return _tempMsgArray;
}
- (NSMutableArray *)dataArray {
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
