//
//  GSplayListView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/15.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSplayListView.h"
#import "GSplayListViewCell.h"

@interface GSplayListView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView * tapGroundView;//!<半透明背景View
@property (nonatomic,strong) UIView * backGroundView;//!<播放列表背景iew
@property (nonatomic,strong) UITableView * playListTableView;//!<播放列表
@property (nonatomic,strong) UILabel * listCounLabel;//!<播放列表数量
@property (nonatomic,strong) UIButton * dismmsButton;//!<关闭按钮
@property (nonatomic,strong) UILabel * titleLabel;//!<播放列表数量
@property (nonatomic, strong) UITapGestureRecognizer *tapNewGesture;
@property (nonatomic,assign)       NSInteger  indexPage;   //!<分页page


@end
@implementation GSplayListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self g_Init];
        [self g_CreateUI];
        [self addGesture];
        

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self g_LayoutFrame];

}

-(void)g_Init{
//    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}
-(void)g_CreateUI{
    [self addSubview:self.tapGroundView];
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.listCounLabel];
    [_backGroundView addSubview:self.dismmsButton];
    [_backGroundView addSubview:self.titleLabel];
    [_backGroundView addSubview:self.playListTableView];
}
-(void)g_LayoutFrame{
    [_tapGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_backGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(172);
    }];
    [_listCounLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backGroundView).mas_offset(20);
        make.left.mas_equalTo(self.backGroundView).mas_offset(15);
        make.height.mas_equalTo(18);
    }];
    [_dismmsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.listCounLabel);
        make.right.mas_equalTo(self.backGroundView.mas_right).mas_offset(-20);
    }];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.listCounLabel.mas_bottom).mas_offset(4);
        make.left.right.mas_equalTo(self.backGroundView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(20);
    }];
    [_playListTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        make.left.right.bottom.mas_equalTo(self.backGroundView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - 刷新
- (void)setUpRrfresh
{
    __kWeakSelf__;
    self.playListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf showLoading];
        [weakSelf.playListTableView.mj_footer resetNoMoreData];
        //数据下拉刷新位置
        weakSelf.indexPage = 1;
        [weakSelf setDeleaget_loadRequestPage:1];
        [weakSelf.playListTableView.mj_header endRefreshing];
    }];
    //
    _playListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //数据上拉刷新
        
        weakSelf.indexPage++;

        [weakSelf setDeleaget_loadRequestPage:weakSelf.indexPage];
        [weakSelf.playListTableView.mj_footer endRefreshing];
    }];
    [_playListTableView.mj_header beginRefreshing];
}
-(void)setDeleaget_loadRequestPage:(NSInteger)page{
    if ([self.delegate respondsToSelector:@selector(myplaylistRequestLoadPage:)]) {
        [self.delegate myplaylistRequestLoadPage:page];
    }
}
#pragma mark - LoadView
-(void)setPlayListData:(NSArray *)playListData{
    _playListData = playListData;
    [self.playListTableView reloadData];
}
-(void)setPlayListIndex:(NSInteger)playListIndex{
    _playListIndex = playListIndex+1;
    [self playListIndex:_playListIndex Listcount:_playListData.count];
}
-(void)playListIndex:(NSInteger)index Listcount:(NSInteger)listcount{
    _listCounLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)index,(long)listcount];
}
#pragma mark - CLick
-(void)dismmsClick{
    [self removeFromSuperview];
}
- (void)addGesture
{
    // 添加Tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismmsClick)];
    [self.tapGroundView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    self.tapNewGesture = tapGesture;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 判断是不是UIButton的类
    //    NSLog(@"%@",NSStringFromClass([touch.view class]));
    
    //    if ([touch.view isKindOfClass:[UIButton class]])
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//显示有几个Cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playListData.count?:1;
}
//数据交互
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSplayListViewCell * cell = [GSplayListViewCell cellWithTableView:tableView];
    if (self.playListData.count != 0) {
        if (indexPath.row +1 == self.playListIndex) {
            [cell setCurrentLabelAlpha_PlayListIndex:1];
            [self playListIndex:self.playListIndex Listcount:self.playListData.count];
        }else{
            [cell setCurrentLabelAlpha_PlayListIndex:0];
        }
        HistoryItmeModel * itmeModel = self.playListData[indexPath.row];
        [cell setCurrentLabelTitle:itmeModel.h_name];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (self.playListData.count != 0) {
        if ([self.delegate respondsToSelector:@selector(mylistCell_didSelectRowAtIndexPath:)]) {
            [self.delegate mylistCell_didSelectRowAtIndexPath:indexPath.row];
        }
    }
    [self dismmsClick];
}
#pragma mark - UI
-(UIView *)tapGroundView{
    if (!_tapGroundView) {
        _tapGroundView = [[UIView alloc]init];
        _tapGroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    }
    return _tapGroundView;
}
-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _backGroundView;
}
-(UILabel *)listCounLabel{
    if (_listCounLabel == nil) {
        _listCounLabel = [[UILabel alloc]init];
        _listCounLabel.font =[UIFont systemFontOfSize:12];
        _listCounLabel.textAlignment = NSTextAlignmentCenter;
        _listCounLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        //        _dlnaLable.userInteractionEnabled = YES;
        _listCounLabel.text = @"1/3";
    }
    return _listCounLabel;
}
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font =[UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        //        _dlnaLable.userInteractionEnabled = YES;
        _titleLabel.text = @"播放目录";
    }
    return _titleLabel;
}
-(UIButton *)dismmsButton{
    if (!_dismmsButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_tv_popup_close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismmsClick) forControlEvents:UIControlEventTouchUpInside];
        _dismmsButton = button;
    }
    return _dismmsButton;
}

-(UITableView *)playListTableView{
    if (!_playListTableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor colorWithHexString:@"#3333333"];
        //        tableView.bounces = NO;
        tableView.showsVerticalScrollIndicator= NO;
        /// 自动关闭估算高度，不想估算那个，就设置那个即可
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //        tableView.tableFooterView = self.completeBtn;
        
        [tableView registerClass:[GSplayListViewCell class] forCellReuseIdentifier:@"GSplayListViewCell"];
        _playListTableView = tableView;
    }
    return _playListTableView;
}
@end
