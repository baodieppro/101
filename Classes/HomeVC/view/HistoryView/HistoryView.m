//
//  HistoryView.m
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
#import "PlayViewController.h"
#import "WebViewController.h"

#import "HistoryView.h"
#import "HistoryManagerHeaderView.h"
#import "HistoryManagerFooterView.h"

#import "LeftCollectionViewCell.h"
#import "RightCollectionViewCell.h"

@interface HistoryView ()

<
MyHistoryManagerHeaderViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
MyRightCollectionViewCellDelegate,
MyLeftCollectionViewCellDelegate,
MyHistoryManagerFooterViewDelegate
>
{
    NSInteger pageIndex;
}
@property (nonatomic,strong) HistoryManagerHeaderView * headerView;
@property (nonatomic,strong) UICollectionView * collectionView;//!<
@property (nonatomic,strong) LeftCollectionViewCell * left_Under_Cell;//!<
@property (nonatomic,strong) RightCollectionViewCell * right_On_Cell;//!<
@property (nonatomic,strong) HistoryManagerFooterView * footerView;
@property (nonatomic,strong) UIButton * editBtn;//!<编辑：YES / 完成：NO

@end
@implementation HistoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
    }
    return self;
}

-(void)g_Init{
    
}
-(void)g_CreateUI{
    [self addSubview:self.headerView];
    [self addSubview:self.editBtn];
    [self addSubview:self.collectionView];
}
-(void)g_LayoutFrame{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(__kNewSize(15*2), __kNewSize(80*2), 0, __kNewSize(80*2)));
        make.height.mas_equalTo(__kNewSize(30*2));
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headerView);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(__kNavigationBarHeight__, __kNavigationBarHeight__));
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(__kNewSize(15*2));
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        //        make.bottom.mas_equalTo(self.footerView.mas_top).mas_offset(-__kNewSize(15*2));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}
#pragma mark - 代理
-(void)mydidSelectAtIndexPath:(NSInteger)index itme:(NSString *)itme{
    //控制当前选择View状态切换
    if (_collectionView.scrollEnabled == NO) {
        self.editBtn.selected = NO;
        [self editClick:self.editBtn];
    }
    pageIndex = index;
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self setDelegateDidSelectAtIndexPath:index itme:itme];
}
-(void)setDelegateDidSelectAtIndexPath:(NSInteger)index itme:(NSString *)itme{
    if ([self.delegate respondsToSelector:@selector(mySelectAtIndexPath:itme:)]) {
        [self.delegate mySelectAtIndexPath:index itme:itme];
    }
    
}
-(void)mySelected_On_IndexItmeWithClick:(PlayCacheModel *)model{
    PlayViewController * playVC = [[PlayViewController alloc]init];
    __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
    playVC.playUrl = model.url;
    playVC.topName = model.title;
    playVC.playStyle = playStyleTypeHistory;
    self.tagViewController.definesPresentationContext = YES;
    //设置模态视图弹出样式
    playVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.tagViewController presentViewController:playVC animated:NO completion:nil];
}
-(void)mySelected_Under_IndexItmeWithClick:(History_FMDBDataModel *)model{
//    WebViewController * webVC = [[WebViewController alloc] init];
//    webVC.url = model.h_url;
//    [[self getCurrentVC] presentViewController:webVC animated:NO completion:nil];
    if ([self.delegate respondsToSelector:@selector(mySelectAtIndexPathItmeUrl:)]) {
        [self.delegate mySelectAtIndexPathItmeUrl:model.url];
    }
}
-(void)mySelectAllClick:(BOOL)isAll{
    if(pageIndex == 0){

        LeftCollectionViewCell * leftCell = (LeftCollectionViewCell *)[self returnPageCell];
        leftCell.allSelected = isAll;
        
    }else{

        RightCollectionViewCell * rightCell = (RightCollectionViewCell *)[self returnPageCell];
        rightCell.allSelected = isAll;
    }
}
-(void)myDeleteWithSelectAllClick{
    if(pageIndex == 0){
     
        LeftCollectionViewCell * leftCell = (LeftCollectionViewCell *)[self returnPageCell];
        [leftCell delete_HitoryDataLoadView];
        
    }else{
     
        RightCollectionViewCell * rightCell = (RightCollectionViewCell *)[self returnPageCell];
        [rightCell delete_HitoryDataLoadView];
    }
}
//获取当前cell
-(id)returnPageCell
{
    UICollectionViewCell * cell;
    //全选未完成
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
    if(pageIndex == 0){

        LeftCollectionViewCell * leftCell = (LeftCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:scrollIndexPath];
        if (_collectionView.scrollEnabled == NO) {
            leftCell.editSelected = YES;
        }else{
            leftCell.editSelected = NO;
        }
        [leftCell reloadView];
        cell = leftCell;
    }else{

        RightCollectionViewCell * rightCell = (RightCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:scrollIndexPath];
        if (_collectionView.scrollEnabled == NO) {
            rightCell.editSelected = YES;
        }else{
            rightCell.editSelected = NO;
        }
        [rightCell reloadView];
        cell = rightCell;
    }
    return cell;
}
-(void)myDelete_itmeListCount:(NSInteger)deleteCount{
    self.footerView.numberLabel.text = [NSString stringWithFormat:@"%ld",deleteCount];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            LeftCollectionViewCell * leftCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LetfCollectionViewCell" forIndexPath:indexPath];
            leftCell.backgroundColor = [UIColor redColor];
            leftCell.delegate = self;
            self.left_Under_Cell = leftCell;
            cell = leftCell;
        }
            break;
        case 1:
        {
            RightCollectionViewCell * rightCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
            rightCell.backgroundColor = [UIColor redColor];
            rightCell.delegate = self;
            self.right_On_Cell = rightCell;
            cell = rightCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(__kScreenWidth__, self.collectionView.size.height);
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
//定义每个UICollectionView 的边距
- ( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return  0;
}
//#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return  0;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSInteger page = (int)floor(ratio);
    
    switch (page) {
        case 0:
        {
            [self.headerView setButtonStyle:YES];
        }
            break;
        case 1:
        {
            [self.headerView setButtonStyle:NO];
        }
            break;
        default:
            break;
    }
    pageIndex = page;
    NSLog(@"%li-----%f",(long)page,scrollView.contentOffset.x);
    
}
#pragma mark - Click
-(void)editClick:(UIButton *)btn{
    if (btn.selected == YES) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [self addSubview:self.footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(__kScreenWidth__, __TabBarH__));
        }];
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(__kNewSize(15*2));
            make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            //        make.bottom.mas_equalTo(self.footerView.mas_top).mas_offset(-__kNewSize(15*2));
            make.bottom.mas_equalTo(self.footerView.mas_top);
        }];
        _collectionView.scrollEnabled = NO;
        
    }else{
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.footerView removeFromSuperview];
        self.footerView = nil;
        _collectionView.scrollEnabled = YES;
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(__kNewSize(15*2));
            make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            //        make.bottom.mas_equalTo(self.footerView.mas_top).mas_offset(-__kNewSize(15*2));
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    [self returnPageCell];
    btn.selected = !btn.selected;
}
#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        //        _collectionView.userInteractionEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        /* cell */
        [_collectionView registerClass:[LeftCollectionViewCell class] forCellWithReuseIdentifier:@"LetfCollectionViewCell"];
        [_collectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}
-(HistoryManagerHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HistoryManagerHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}
-(HistoryManagerFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[HistoryManagerFooterView alloc]init];
        _footerView.delegate = self;
    }
    return _footerView;
}
-(UIButton *)editBtn{
    if (_editBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        button.layer.cornerRadius =5;
        button.backgroundColor = [UIColor clearColor];
        button.selected = YES;
        [button addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn = button;
    }
    return _editBtn;
}
@end
