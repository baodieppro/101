//
//  LetfCollectionViewCell.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "LeftCollectionViewCell.h"
#import "HistoryTableViewCell.h"
#import "YUFoldingSectionHeader.h"

@interface LeftCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,YUFoldingSectionHeaderDelegate>

@property (nonatomic,assign) NSInteger refreshPage;//!<请求分页

@property (nonatomic,strong) NSMutableArray * selectDataArr;//!<

@property (nonatomic,strong) NSMutableArray * delList;//!<要删除的数据下标
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * dayArr;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end
@implementation LeftCollectionViewCell
//全选
-(void)setAllSelected:(BOOL)allSelected{
    for (int i = 0; i < self.dataArr.count ; i++) {
        History_FMDBDataModel * itmeModel = self.dataArr[i];
        itmeModel.isSeleted =  [NSString stringWithFormat:@"%d",allSelected];
        [[HistoryManager historyManager] updataIndexExistNewModel:itmeModel complete:^{
            
        } failed:^{
            
        }];
//        [self.dataArr replaceObjectAtIndex:i withObject:itmeModel];
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
//    self.dataArr = [[NSMutableArray alloc]initWithArray:[[CollectionManager collectionManager] readModelsWithRecord]];
    self.dayArr = [[NSMutableArray alloc]initWithArray:[[TimeManager timeManager] allDayArray]];

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
//    if(self.dataArr.count == self.delList.count){
//        [self.selectDataArr removeAllObjects];
//        [EntireManageMent removeCacheWithName:WEB_History_Cache];
//        [[TimeManager timeManager] deleteDayAllManage];
//        [[HistoryManager historyManager] deleteHISAllManage];

//    }else{

//        for (History_FMDBDataModel * itmeModel in _delList) {
//        }
        for (NSInteger i = 0; i< _delList.count; i++) {
            History_FMDBDataModel * itmeModel = _delList[i];
            [[HistoryManager historyManager] deleteHISWithDetailedTime:itmeModel.detailedTime];
        }
        [self.delList removeAllObjects];
        
//        [HistoryModel addCacheName:WEB_History_Cache title:nil url:nil arr:self.selectDataArr];
        //

//    }
    [self reloadView];
    [self reloadDelCount];
}
//刷新要删除的数据下标
-(void)reloadDelCount{
    [self.delList removeAllObjects];
    for (int i = 0; i< self.dataArr.count; i ++) {
        History_FMDBDataModel * itmeModel = self.dataArr[i];
        if ([itmeModel.isSeleted boolValue] == YES) {
            [self.delList addObject:itmeModel];
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
#pragma mark - tableViewHeader 配置

-(YUFoldingSectionHeaderArrowPosition )perferedArrowPosition
{
    return YUFoldingSectionHeaderArrowPositionRight;
}
-(UIColor *)backgroundColorForSection:(NSInteger )section
{
    return [UIColor colorWithHexString:@"#ffffff"];
}
-(NSString *)titleForSection:(NSInteger )section
{
    if (_dayArr.count != 0) {
        NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:[[TimeManager timeManager] allDayArray]];
        NSString * titleSection = [NSString stringWithFormat:@"    %@",[GSTimeTools compareDate:arr[section]]];
        return titleSection ;
    }
    return nil;
}
-(UIFont *)titleFontForSection:(NSInteger )section
{
    return [UIFont systemFontOfSize:__kNewSize(26)];
}
-(UIColor *)titleColorForSection:(NSInteger )section
{
    return [UIColor colorWithHexString:@"#666666"];
}
-(NSString *)descriptionForSection:(NSInteger )section
{
  //  return [NSString stringWithFormat:@"%ld",[self historyArr:section].count];
    return nil;
}
-(UIFont *)descriptionFontForSection:(NSInteger )section
{
    return [UIFont boldSystemFontOfSize:__kNewSize(24)];
}

-(UIColor *)descriptionColorForSection:(NSInteger )section
{
    return [UIColor blackColor];
}

-(UIImage *)arrowImageForSection:(NSInteger )section
{
    return [UIImage imageNamed:@"Arrow"];
}
#pragma mark - YUFoldingSectionHeaderDelegate

-(void)yuFoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    NSInteger numberOfRow;
    if (_dayArr.count != 0) {
        numberOfRow = [self historyArr:index].count;
    }else{
        numberOfRow = _dataArr.count;
    }
    //    NSInteger numberOfRow = [self tableView:self.tabelView numberOfRowsInSection:index];
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [self.leftTableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.leftTableView insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger _state;
//    if(section == 0){
//        _state = 1;
//    }else{
        _state = ((NSNumber *)self.statusArray[section]).integerValue;
//    }
        YUFoldingSectionHeader *sectionHeaderView = [[YUFoldingSectionHeader alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth__, [self tableView:self.leftTableView heightForHeaderInSection:section])  withTag:section];
        
        [sectionHeaderView setupWithBackgroundColor:[self backgroundColorForSection:section]
                                        titleString:[self titleForSection:section]
                                         titleColor:[self titleColorForSection:section]
                                          titleFont:[self titleFontForSection:section]
                                  descriptionString:[self descriptionForSection:section]
                                   descriptionColor:[self descriptionColorForSection:section]
                                    descriptionFont:[self descriptionFontForSection:section]
                                         arrowImage:[self arrowImageForSection:section]
                                      arrowPosition:[self perferedArrowPosition]
                                       sectionState:_state];
        
        sectionHeaderView.tapDelegate = self;
//        sectionHeaderView.jsonTheme.backgroundColor(@"ident1");

    if (_dayArr.count != 0) {
        return sectionHeaderView;
    }
    return nil;


}
#pragma mark - GSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dayArr.count != 0) {
        return _dayArr.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dayArr.count != 0) {
//        NSLog(@"--%@----%ld",_dayArr[section],[self historyArr:section].count);
        BOOL currentIsOpen = ((NSNumber *)self.statusArray[section]).boolValue;
        
        if(currentIsOpen){
            return [self historyArr:section].count;
        }
        
    }
    return 0;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * tableViewCell;
    if (self.dataArr.count == 0) {
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
//        if (_dayArr.count != 0) {
//               _dataArr = [NSMutableArray arrayWithArray:[[HistoryManager historyManager] timeModelArrayfromeKey:_dayArr[indexPath.section]]];
//           }
        if (self.dataArr.count != 0) {
            History_FMDBDataModel * itmeModel = self.dataArr[indexPath.row];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dayArr.count != 0) {
        return __kNewSize(55*2);
    }else{
        return __kNewSize(55*2);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_dayArr.count != 0) {
        return __kNewSize(48*2);
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSLog(@"tableViewcell_touch");
     if (self.dataArr.count != 0) {
         History_FMDBDataModel * itmeModel = self.dataArr[indexPath.row];
        if (self.editSelected == NO) {
            if ([self.delegate respondsToSelector:@selector(mySelected_Under_IndexItmeWithClick:)]) {
                    [self.delegate mySelected_Under_IndexItmeWithClick:itmeModel];
                }
        }else{
            //遍历当前选中itme (多选)
            itmeModel.isSeleted = [NSString stringWithFormat:@"%d",![itmeModel.isSeleted boolValue]];
            [[HistoryManager historyManager] updataIndexExistNewModel:itmeModel complete:^{
                
            } failed:^{
                
            }];
            [self.dataArr replaceObjectAtIndex:indexPath.row withObject:itmeModel];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [tableView reloadData];
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
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
            History_FMDBDataModel * model = _dataArr[indexPath.row];
            [_dataArr removeObjectAtIndex:indexPath.row];
            if(_dayArr.count != 0){
                [[HistoryManager historyManager] deleteModelForTime:model.detailedTime];
            }

        [tableView reloadData];
    };
    void(^rowActionHandler1)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        History_FMDBDataModel * model = _dataArr[indexPath.row];
//        _shareView.shareType = ShareViewType;
//        _shareView.titleShare =model.title;
//        _shareView.urlShare = model.url;
//        [_shareView show];
        [tableView reloadData];
    };
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    action1.backgroundColor = [UIColor redColor];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享" handler:rowActionHandler1];
    action2.backgroundColor = [UIColor orangeColor];
//    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:rowActionHandler2];
//    action3.backgroundColor = [UIColor orangeColor];
    
    return @[action1,action2];
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
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(NSMutableArray *)dayArr{
    if (!_dayArr) {
        _dayArr = [[NSMutableArray alloc]init];
    }
    return _dayArr;
}
-(NSArray *)historyArr:(NSInteger)index{
    
    self.dataArr = [NSMutableArray arrayWithArray:[[HistoryManager historyManager] timeModelArrayfromeKey:_dayArr[index]]];
    
    return self.dataArr;
}
-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > self.leftTableView.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.leftTableView.numberOfSections - 1, _statusArray.count - self.leftTableView.numberOfSections)];
        }else if (_statusArray.count < self.leftTableView.numberOfSections) {
            for (NSInteger i = self.leftTableView.numberOfSections - _statusArray.count; i < self.leftTableView.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateFlod]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.leftTableView.numberOfSections; i++) {
            if (i == 0) {
                [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateShow]];
            }else{
                [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateFlod]];
                
            }
        }
    }
    return _statusArray;
}
@end
