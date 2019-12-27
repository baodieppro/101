//
//  SearchHistoryView.m
//  GSDlna
//
//  Created by ios on 2019/12/12.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "SearchHistoryView.h"
#import "SearchHistoryCell.h"
#import "SearchView.h"

@interface SearchHistoryView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) SearchView *searchView;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * historyArr;//!<

@end
@implementation SearchHistoryView

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
    [self addSubview:self.searchView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.tableView];
    [self.tableView setTableFooterView:self.removeSearchAllBtn];
}
-(void)g_LayoutFrame{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchView.searchTextField);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(__kNavigationBarHeight__, __kNewSize(62)));
    }];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(__kNewSize(15));
        make.right.mas_equalTo(self.cancelBtn.mas_left).mas_offset(__kNewSize(-2));
        make.height.mas_equalTo(__kNavigationBarHeight__);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.bottom.mas_equalTo(self);
    }];
//    [_removeSearchAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.size.mas_equalTo(CGSizeMake(__kScreenWidth__, __kNewSize(50*2)));
//    }];
}
#pragma mark - 代理实现
-(void)setDelegatemySelectedIndexItmeWithClick:(NSString *)keyword{
    if ([self.delegate respondsToSelector:@selector(mySelectedIndexItmeWithClick:)]) {
        [self.delegate mySelectedIndexItmeWithClick:keyword];
    }
}
#pragma mark - click
- (void)shangClick:(UIButton *)btn{
    NSInteger index = btn.tag-10000;
    if (self.historyArr.count != 0) {
          SearchHistoryItmeModel *itemsModel  = self.historyArr[index];
        _searchView.searchTextField.text = itemsModel.keyword;
    }
}
-(void)removeHistoryClick{
    [EntireManageMent removeCacheWithName:Search_History_Cache];
    if (self.historyArr.count != 0) {
        [self.historyArr removeAllObjects];
    }
    _removeSearchAllBtn.hidden = YES;
    [_tableView reloadData];
}
#pragma mark - TextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!kStringIsEmpty(textField.text)) {
        [SearchHistoryItmeModel addCacheName:Search_History_Cache title:textField.text arr:self.historyArr];
        [self setDelegatemySelectedIndexItmeWithClick:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{

    return YES;
}
#pragma mark - GSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellTableIndentifier = @"SearchHistoryCell";
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
    //初始化单元格
    if(cell == nil)
    {
        cell = [[SearchHistoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
    }
//            cell.delegate = self;
    
    if (self.historyArr.count != 0) {
        SearchHistoryItmeModel * itmeModel = self.historyArr[indexPath.row];
        [cell setItmeModel:itmeModel];
    }
    cell.historyShang.tag = 10000 + indexPath.row;
    [cell.historyShang addTarget:self action:@selector(shangClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.historyArr.count != 0) {
        return __kNewSize(50*2);
    }
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSLog(@"tableViewcell_touch");
    if (self.historyArr.count != 0) {
        SearchHistoryItmeModel * itmeModel = self.historyArr[indexPath.row];
        [self setDelegatemySelectedIndexItmeWithClick:itmeModel.keyword];
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
        [self.historyArr removeObjectAtIndex:indexPath.row];
        [SearchHistoryItmeModel addCacheName:Search_History_Cache title:nil arr:self.historyArr];
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    
    //将设置好的按钮方到数组中返回
    return @[deleteAction];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SearchHistoryCell class] forCellReuseIdentifier:@"SearchHistoryCell"];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _tableView.translatesAutoresizingMaskIntoConstraints = false;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
-(SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectZero];
        _searchView.searchTextField.delegate = self;
    }
    return _searchView;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button.layer.cornerRadius =5;
        button.backgroundColor = [UIColor clearColor];
        _cancelBtn = button;
    }
    return _cancelBtn;
}
-(UIButton *)removeSearchAllBtn{
    if (_removeSearchAllBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, __kScreenWidth__, __kNewSize(50*2));
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"清空输入历史" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#a5a5a5"] forState:UIControlStateNormal];
        //        button.layer.cornerRadius =5;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(removeHistoryClick) forControlEvents:UIControlEventTouchUpInside];
        _removeSearchAllBtn = button;
    }
    return _removeSearchAllBtn;
}
-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [[NSMutableArray alloc]init];
        if ([EntireManageMent isExisedManager:Search_History_Cache]) {
            [SearchHistoryItmeModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent readCacheDataWithName:Search_History_Cache]] dataArrName:_historyArr cacheName:Search_History_Cache];
        }
    }
    return _historyArr;
}
@end
