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
-(void)gs_ViewDidAppear{
    [self loadViewCell];
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
        cell.tag = 1001+indexPath.row;
        tableViewCell = cell;
        
    }
    
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    return tableViewCell;
}
//用于判断tableview是否加载完成
//
//-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//
//    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
//        [self loadViewCell];
//    }
//}
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
        [self push_PlayViewControllerWithUrl:model.downLoadUrl name:model.title];
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
#pragma mark - 更新下载数据
-(void)loadViewCell{
    if (self.downLoadList.count != 0) {
        for (NSInteger i = 0; i< self.downLoadList.count; i++) {
            Download_FMDBDataModel * model = self.downLoadList[i];
            if ([model.isDown integerValue] == 1) {
                continue;
            }
//            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.tableView registerClass:[DownloadCell class] forCellReuseIdentifier:@"DownloadCell"];
//            DownloadCell * newCell  = (DownloadCell *)[self tableView:self.tableView cellForRowAtIndexPath:cellIndexPath];
//            __kWeakSelf__;
            [DownLoadManager start:model.downLoadUrl Name:model.title progressBlock:^(CGFloat progress) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    newCell.urlLabel.text = [NSString stringWithFormat:@"%.00f%%",progress * 100];
////                    newCell.loadedView.progress = progress;
//                    [newCell.loadedView setProgress:progress animated:YES];
//                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cellIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                });
            }];
        }
       
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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
