//
//  RightCollectionViewCell.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "RightCollectionViewCell.h"
#import "HistoryTableViewCell.h"
//model


@interface RightCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * listData;
@property (nonatomic,assign) NSInteger refreshPage;//!<请求分页
@property (nonatomic,strong) NSMutableArray * delList;//!<要删除的数据下标

@end
@implementation RightCollectionViewCell
//全选
-(void)setAllSelected:(BOOL)allSelected{
    for (int i = 0; i < self.listData.count ; i++) {
        HistoryItmeModel * itmeModel = self.listData[i];
        itmeModel.isSeleted = allSelected;
        [self.listData replaceObjectAtIndex:i withObject:itmeModel];
    }
    [self reloadDelCount];
    [self reloadView];
}
#pragma mark - 刷新页面
-(void)reloadView{
    [self.rightTableView reloadData];
}
#pragma mark - 初始化
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
//    [self setRefresh];
}
-(void)g_CreateUI{
    [self addSubview:self.rightTableView];
}
-(void)g_LayoutFrame{
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - 公共方法
//删除全选数据
-(void)delete_HitoryDataLoadView{
    //获取已选中的下标
    if(self.listData.count == self.delList.count){
        [self.listData removeAllObjects];
        [EntireManageMent removeCacheWithName:PLAY_History_Cache];

    }else{
        [self.delList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj = [NSString stringWithFormat:@"%@", obj];
            [self.listData removeObjectAtIndex:[obj intValue]];
        }];
        [HistoryModel addCacheName:PLAY_History_Cache title:nil url:nil arr:self.listData];
    }
    [self reloadDelCount];
    [self reloadView];
}
//刷新要删除的数据下标
-(void)reloadDelCount{
    [self.delList removeAllObjects];
    for (int i = 0; i< self.listData.count; i ++) {
        HistoryItmeModel * itmeModel = self.listData[i];
        if (itmeModel.isSeleted == YES) {
            [self.delList addObject:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    [self setDelegate_myDelete_itmeListCount:self.delList.count];
}
#pragma mark - SetDelegate
- (void)setDelegate_myDelete_itmeListCount:(NSInteger)delCount{
    if ([self.delegate respondsToSelector:@selector(myDelete_itmeListCount:)]) {
        [self.delegate myDelete_itmeListCount:delCount];
    }
}
#pragma mark - GSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * tableViewCell;
    if(self.listData.count == 0){
        static NSString *CellTableIndentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];

        }
        tableViewCell = cell;
    }else{
        static NSString *CellTableIndentifier = @"RightTableViewCell";
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
        }
        if (self.listData.count != 0) {
            HistoryItmeModel * itmeModel = self.listData[indexPath.row];
            [cell setItmeModel:itmeModel];
        }
        [cell setEditSelected:self.editSelected];

        tableViewCell = cell;

    }
    
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return __kNewSize(105*2);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSLog(@"tableViewcell_touch");
    if (self.listData.count != 0) {
        HistoryItmeModel * itmeModel = self.listData[indexPath.row];
        if (self.editSelected == NO) {
                if ([self.delegate respondsToSelector:@selector(mySelected_On_IndexItmeWithClick:)]) {
                    [self.delegate mySelected_On_IndexItmeWithClick:itmeModel];
                }
        }else{
            //遍历当前选中itme (多选)
            itmeModel.isSeleted = !itmeModel.isSeleted;
            [self.listData replaceObjectAtIndex:indexPath.row withObject:itmeModel];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self reloadDelCount];
        }
    }
}

#pragma mark - 懒加载

- (UITableView *)rightTableView
{
    if(_rightTableView == nil)
    {
        _rightTableView = [[UITableView alloc]init];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.delegate= self;
        _rightTableView.dataSource = self;
        [_rightTableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"RightTableViewCell"];
        _rightTableView.tableFooterView = [[UIView alloc]init];
        _rightTableView.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
       if (@available(iOS 11.0, *)) {
           _rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _rightTableView.translatesAutoresizingMaskIntoConstraints = false;
        }
        _rightTableView.estimatedRowHeight = 0;
        _rightTableView.estimatedSectionHeaderHeight = 0;
        _rightTableView.estimatedSectionFooterHeight = 0;
       
    }
    return _rightTableView;
}
-(NSMutableArray *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc]init];
        if ([EntireManageMent isExisedManager:PLAY_History_Cache]) {
            [HistoryModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent readCacheDataWithName:PLAY_History_Cache]] dataArrName:_listData cacheName:PLAY_History_Cache];
        }
    }
    return _listData;
}
-(NSMutableArray *)delList{
    if (!_delList) {
        _delList = [[NSMutableArray alloc]init];
    }
    return _delList;
}

@end
