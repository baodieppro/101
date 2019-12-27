//
//  DownloadView.m
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
#import "PlayViewController.h"
#import "DownloadView.h"
#import "DownloadCell.h"

@interface DownloadView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * downLoadList;//!<

@end
@implementation DownloadView

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
    [self addSubview:self.tableView];
}
-(void)g_LayoutFrame{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(0);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.bottom.mas_equalTo(self);
    }];
}
#pragma mark - GSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.downLoadList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * tableViewCell;
    if(self.downLoadList.count == 0){
        static NSString *CellTableIndentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
            
        }
        tableViewCell = cell;
    }else{
        static NSString *CellTableIndentifier = @"DownloadCell";
        DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[DownloadCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
        }
        if (self.downLoadList.count != 0) {
            [cell setDownLoadModel:self.downLoadList[indexPath.row]];
        }

        tableViewCell = cell;
        
    }
    
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.downLoadList.count != 0) {
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
    if (self.downLoadList.count != 0) {
        Download_FMDBDataModel * model = self.downLoadList[indexPath.row];
        if ([model.isDown integerValue] == 0) {
            [self push_PlayViewControllerWithUrl:model.downLoadUrl name:model.title];
        }else{
            [self push_PlayViewControllerWithUrl:model.pathUrl name:model.title];
        }
    }
}
#pragma mark - pushPlay
-(void)push_PlayViewControllerWithUrl:(NSString *)url name:(NSString *)name{
    PlayViewController * playVC = [[PlayViewController alloc]init];
    __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
    playVC.playUrl = url;
    playVC.topName = name;
    playVC.playStyle = playStyleTypeHistory;
    [[self getCurrentVC] presentViewController:playVC animated:NO completion:nil];
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
        [DownLoadManager removeDownLoadVideo:self.downLoadList[indexPath.row]];
        [self.downLoadList removeObjectAtIndex:indexPath.row];
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
        [_tableView  registerClass:[DownloadCell class] forCellReuseIdentifier:@"DownloadCell"];
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
-(NSMutableArray *)downLoadList{
    if (!_downLoadList) {
        _downLoadList = [[NSMutableArray alloc] initWithArray:[DownloadDataManager readDownLoadDataList]];
       
    }
    return _downLoadList;
}

@end
