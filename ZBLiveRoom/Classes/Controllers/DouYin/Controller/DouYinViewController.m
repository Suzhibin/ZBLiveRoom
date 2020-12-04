//
//  DouYinViewController.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "DouYinViewController.h"
#import "DouYinModel.h"
#import "Macro.h"
#import <SuperPlayer/SuperPlayer.h>
#import "UIImageView+WebCache.h"
#import "DouYinTableViewCell.h"
#import "SPDouYinControlView.h"
@interface DouYinViewController ()<UITableViewDelegate,UITableViewDataSource,SuperPlayerDelegate,DouYinTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;//正式数据
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isfinish;
//@property (nonatomic,strong)SuperPlayerView *superPlayer;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSIndexPath* curPlayIndexPath;
// 当前播放的cell（跟上面curPlayIndexPath是一一对应的）
@property (nonatomic, weak)  DouYinTableViewCell* curPlayingCell;
@property (nonatomic,strong)SuperPlayerView *superPlayer;
@property (nonatomic,strong)SuperPlayerModel *playerModel;
@property (nonatomic,strong)SPDouYinControlView *controlView;
@end

@implementation DouYinViewController
- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
    // 暂停当前的播放
    [self.superPlayer resetPlayer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    [self requestData];
    self.superPlayer = [[SuperPlayerView alloc] initWithFrame:CGRectZero];
     self.superPlayer.disableGesture = YES;
    self.controlView= [[SPDouYinControlView alloc] initWithFrame:CGRectZero];
    self.superPlayer.userInteractionEnabled=NO;
    self.superPlayer.controlView =self.controlView;

     self.superPlayer.loop=YES;
     //self.superPlayer.delegate = self;
     self.superPlayer.playerConfig.enableLog=NO;
}
- (void)setCurPlayIndexPath:(NSIndexPath *)curPlayIndexPath {
    if ([_curPlayingCell isEqual:curPlayIndexPath]) {
        return;
    }
    _curPlayIndexPath = curPlayIndexPath;
    DouYinTableViewCell* cell = [self.tableView cellForRowAtIndexPath:_curPlayIndexPath];
    // 如果cell不存在，说明是第一个cell,还没入栈到tableView的重用队列，这里获取不到的;在cellForRowAtIndexPath回调中缓存这个cell
    if (cell) {
        self.curPlayingCell = cell;
    }
}
- (void)setCurPlayingCell:(DouYinTableViewCell *)curPlayingCell {
    // 不要重复设置
    if (_curPlayingCell && _curPlayingCell == curPlayingCell) {
        return;
    }
    // 当前播放的cell存在时，暂停播放
    if (_curPlayingCell) {
       [_curPlayingCell pause];
    }
    // 更新cell
    _curPlayingCell = curPlayingCell;
    // 播放新缓存的cell
    if (_curPlayingCell) {
        [_curPlayingCell playVideo];
    }
}
- (void)douYinCell:(DouYinTableViewCell *)cell  startPlay:(BOOL)isPlay dyModel:(nonnull DouYinModel *)dyModel{
    if (isPlay) {
     
        //[self.superPlayer.coverImageView sd_setImageWithURL:[NSURL URLWithString:dyModel.thumbnail_url]];
        self.superPlayer.fatherView = cell.contentView;
        self.playerModel = [SuperPlayerModel new];
        self.playerModel.videoURL=dyModel.video_url;
        [self.superPlayer playWithModel:self.playerModel];
        self.controlView.dyModel=dyModel;
    }else{
        self.superPlayer.fatherView =nil;
         [self.superPlayer pause];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 当前cell的行数
    NSInteger row = (NSInteger)scrollView.contentOffset.y / k_SCREEN_HEIGHT;
    self.curPlayIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.view];
    // 当前所有的视频个数
    NSInteger total = [self.tableView numberOfRowsInSection:0];
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSInteger row = self.curPlayIndexPath ? self.curPlayIndexPath.row : 0;
    CGFloat curCellStartY = row * k_SCREEN_HEIGHT;
    // 在最后一个cell的位置
    if (total > 0 && row == total - 1) {
        // 不是上拉刷新
        if (velocity.y > 0) {
            scrollView.pagingEnabled = YES;
        }
        // 上拉刷新时:要屏蔽分页效果，否则MJRefresh悬停会导致cell位置不在屏幕边界
        else if (velocity.y < 0) {
            scrollView.pagingEnabled = NO;
        }
    }
    // 一种情况:scrollViewDidEndDecelerating没有触发时，且当前滚动到了顶部，重置当前播放indexPath为0位置
    if (contentOffsetY == 0 && !scrollView.isTracking) {
        self.curPlayIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        return;
    }
    // 当前播放的cell的indexPath不在屏幕可见区内，就要设置indexPath为空，将当前播放暂停
    if (contentOffsetY <= curCellStartY - k_SCREEN_HEIGHT || contentOffsetY >= curCellStartY + k_SCREEN_HEIGHT) {
        if (self.curPlayIndexPath) {
            self.curPlayIndexPath = nil;
        }
    }
    // 而cell能到屏幕可见区内的话，scrollViewDidEndDecelerating就一定会被触发，到那个方法里面去重置当前播放的indexPath
}
- (void)requestData {
    self.isfinish=NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"douyin" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        DouYinModel *dyModel = [[DouYinModel alloc] init];
        [dyModel setValuesForKeysWithDictionary:dataDic];
        [self.dataArray addObject:dyModel];
    }
    self.isfinish=YES;
    [self.tableView reloadData];

}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DouYinModel *dyModel=self.dataArray[indexPath.row];

   DouYinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DouYinTableViewCell class])];
    cell.dyModel=dyModel;
    cell.cellDelegate=self;
     CGFloat contentOffsetY = tableView.contentOffset.y;
        CGFloat headerHeight = 44;
       // 这种情况为:界面和数据刚加载完毕，不会触发任何滚动事件
        if (indexPath.row == 0 && contentOffsetY > -0.01 - headerHeight && contentOffsetY < 0.01 + headerHeight) {
            // row==0时，因为cell还没入栈，cellForRowAtIndexPath:获取不到cell；不能自动播放，这里要手动
            self.curPlayIndexPath = indexPath;
            self.curPlayingCell = cell;
        }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 80%出现后，需要去加载数据
    if (indexPath.row > self.dataArray.count * 0.8&&self.isfinish) {
        [self requestData];
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
       // CGFloat cell_HEIGHT=k_SCREEN_HEIGHT-(k_safeAreaTopHeight+k_NAVBAR_HEIGHT);
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_tableView.contentInset = UIEdgeInsetsMake(k_SCREEN_HEIGHT, 0, k_SCREEN_HEIGHT * 3, 0);
        _tableView.backgroundColor=[UIColor colorWithRed:(240)/255.0 green:(242)/255.0 blue:(245)/255.0 alpha:(1)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight = k_SCREEN_HEIGHT;
        _tableView.pagingEnabled=YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        _tableView.scrollsToTop = NO;
        _tableView.tableFooterView=[UIView new];
        if (@available(iOS 11.0,*))  {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
        [_tableView registerClass:[DouYinTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DouYinTableViewCell class])];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.frame = CGRectMake(15, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
