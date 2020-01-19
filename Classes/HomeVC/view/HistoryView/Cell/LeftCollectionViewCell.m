//
//  LetfCollectionViewCell.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "LeftCollectionViewCell.h"
#import "HistoryTableViewCell.h"

@interface LeftCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger refreshPage;//!<请求分页

@property (nonatomic,strong) NSMutableArray * selectDataArr;//!<

@property (nonatomic,strong) NSMutableArray * delList;//!<要删除的数据下标

@end
@implementation LeftCollectionViewCell
//全选
-(void)setAllSelected:(BOOL)allSelected{
    for (int i = 0; i < self.selectDataArr.count ; i++) {
        HistoryItmeModel * itmeModel = self.selectDataArr[i];
        itmeModel.isSeleted = allSelected;
        [self.selectDataArr replaceObjectAtIndex:i withObject:itmeModel];
    }
    [self reloadDelCount];
    [self reloadView];
}
#pragma mark - 刷新页面
-(void)reloadView{
    [self.leftTableView reloadData];
}
-(void)layoutSubviews{
    [super layoutSubviews];
   
}
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
    [self addSubview:self.leftTableView];
}
-(void)g_LayoutFrame{
    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - 公共方法
//删除全选数据
-(void)delete_HitoryDataLoadView{
    //获取已选中的下标
    if(self.selectDataArr.count == self.delList.count){
        [self.selectDataArr removeAllObjects];
        [EntireManageMent removeCacheWithName:WEB_History_Cache];

    }else{
        [self.delList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj = [NSString stringWithFormat:@"%@", obj];
            GSLog(@"DeleteListIndex: %@ idx:%ld",obj,idx);
            [self.selectDataArr removeObjectAtIndex:[obj intValue]];
        }];
        [HistoryModel addCacheName:WEB_History_Cache title:nil url:nil arr:self.selectDataArr];

    }
    [self reloadView];
    [self reloadDelCount];
}
//刷新要删除的数据下标
-(void)reloadDelCount{
    [self.delList removeAllObjects];
    for (int i = 0; i< self.selectDataArr.count; i ++) {
        HistoryItmeModel * itmeModel = self.selectDataArr[i];
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
    return self.selectDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * tableViewCell;
    if (self.selectDataArr.count == 0) {
        static NSString *CellTableIndentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
        }
        tableViewCell = cell;

    }else{
        static NSString *CellTableIndentifier = @"leftTableViewCell";
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
        }
        if (self.selectDataArr.count != 0) {
            HistoryItmeModel * itmeModel = self.selectDataArr[indexPath.row];
            [cell setItmeModel:itmeModel];
        }
        [cell setEditSelected:self.editSelected];
        [cell setIsLefOrRight:YES];
        tableViewCell = cell;
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectDataArr.count != 0) {
        return __kNewSize(105*2);
    }
    return 0.00f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSLog(@"tableViewcell_touch");
     if (self.selectDataArr.count != 0) {
         HistoryItmeModel * itmeModel = self.selectDataArr[indexPath.row];
        if (self.editSelected == NO) {
            if ([self.delegate respondsToSelector:@selector(mySelected_Under_IndexItmeWithClick:)]) {
                    [self.delegate mySelected_Under_IndexItmeWithClick:itmeModel];
                }
        }else{
            //遍历当前选中itme (多选)
            itmeModel.isSeleted = !itmeModel.isSeleted;
            [self.selectDataArr replaceObjectAtIndex:indexPath.row withObject:itmeModel];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self reloadDelCount];
        }
    }
}
#pragma mark - 右滑删除
-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//设置滑动时显示多个按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.selectDataArr removeObjectAtIndex:indexPath.row];
        [HistoryModel addCacheName:WEB_History_Cache title:nil url:nil arr:self.selectDataArr];
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    //将设置好的按钮方到数组中返回
    return @[deleteAction];
}
#pragma mark - 懒加载
- (UITableView *)leftTableView
{
    if(_leftTableView == nil)
    {
        _leftTableView = [[UITableView alloc]init];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"leftTableViewCell"];
        _leftTableView.tableFooterView = [[UIView alloc]init];
        _leftTableView.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        if (@available(iOS 11.0, *)) {
            _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _leftTableView.translatesAutoresizingMaskIntoConstraints = false;
        }
        _leftTableView.estimatedRowHeight = 0;
        _leftTableView.estimatedSectionHeaderHeight = 0;
        _leftTableView.estimatedSectionFooterHeight = 0;
    }
    return _leftTableView;
}

-(NSMutableArray *)selectDataArr{
    if (!_selectDataArr) {
        _selectDataArr = [[NSMutableArray alloc]init];
        if ([EntireManageMent isExisedManager:WEB_History_Cache]) {
            [HistoryModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent readCacheDataWithName:WEB_History_Cache]] dataArrName:_selectDataArr cacheName:WEB_History_Cache];
        }
    }
    return _selectDataArr;
}
-(NSMutableArray *)delList{
    if (!_delList) {
        _delList = [[NSMutableArray alloc]init];
    }
    return _delList;
}

@end
