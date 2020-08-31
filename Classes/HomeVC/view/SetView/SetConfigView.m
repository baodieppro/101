//
//  SetView.m
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/29.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "SetConfigView.h"
#import "SetViewCell.h"

@interface SetConfigView ()
<
UITableViewDataSource,
UITableViewDelegate,
MySetViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) UIButton *compButton;

@end
@implementation SetConfigView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self set_init];
        [self set_UI];
        [self set_Frame];
    }
    return self;
}

-(void)set_init{
    //读取plist
    [self getDataFromPlist];
}
-(void)set_UI{
    [self addSubview:self.tableView];
    [self addSubview:self.compButton];
}
-(void)set_Frame{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(self);
    }];
    [_compButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(__kTabBarHeight__);
    }];
}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.autoHideMjFooter = YES;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        /// 自动关闭估算高度，不想估算那个，就设置那个即可
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[SetViewCell class] forCellReuseIdentifier:@"SetViewCell"];
     
    }
    return _tableView;
}

-(UIButton *)compButton{
    if(!_compButton)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(36)];
        [btn setTitle:@"恢复默认设置" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#F1720F"] forState:UIControlStateNormal];
//        btn.layer.cornerRadius = __kNewSize(50);
        btn.backgroundColor = [UIColor colorWithHexString:@"#FFF0E5"];
        [btn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];

//        btn.enabled = YES;
        _compButton = btn;
    }
    return _compButton;
}
#pragma mark - 数据初始化
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
        NSURL * URL  =[[NSBundle mainBundle]URLForResource:@"SetList" withExtension:@"plist"];
        NSMutableArray * plistArr = [NSMutableArray arrayWithContentsOfURL:URL];
        for (NSDictionary * dict in plistArr) {
            SetPlistModel *centModel = [[SetPlistModel alloc]initWithDictionary:dict error:nil];
            GSLog(@"%@",centModel);
            [_dataArr addObject:centModel];
        }
    }
    return _dataArr;
}
#pragma mark - 读取plist
- (void)getDataFromPlist{//沙盒获取路径
    NSString *filePatch = [self filePath];
    NSMutableArray * plistArr = [[NSMutableArray alloc]initWithContentsOfFile:filePatch];
    if(plistArr == nil) {
        //去创建并导入数据
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for (SetPlistModel * model in self.dataArr) {
            NSDictionary * dict = [EntireManageMent dicFromObject:model];
            [arr addObject:dict];
        }
        [arr writeToFile:filePatch atomically:YES];
    }else{
        [self.dataArr removeAllObjects];
        for (NSDictionary * dict in plistArr) {
            SetPlistModel *centModel = [[SetPlistModel alloc]initWithDictionary:dict error:nil];
            GSLog(@"%@",centModel);
            [_dataArr addObject:centModel];
        }
    }
    NSLog(@"sandBox %@",_dataArr);

    
}
#pragma mark - 修改Plist
- (void)writeDataToPlist{
    //这里使用位于沙盒的plist（程序会自动新建的那一个）
    NSString *filePatch = [self filePath];
    NSMutableArray * plistArr = [[NSMutableArray alloc]initWithContentsOfFile:filePatch];
    NSLog(@"old sandBox is %@",plistArr);
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (SetPlistModel * model in _dataArr) {
        NSDictionary * dict = [EntireManageMent dicFromObject:model];
        [arr addObject:dict];
    }
    [arr writeToFile:filePatch atomically:YES];
    plistArr = [[NSMutableArray alloc]initWithContentsOfFile:filePatch];
    NSLog(@"new sandBox is %@",plistArr);

}
#pragma mark - 删除恢复默认
-(void)deleteDataToPlist{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *filePatch = [self filePath];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePatch];
    if (!blHave) {
        NSLog(@"不存在");
        return ;
    }else {
    NSLog(@" 存在");
        BOOL blDele= [fileManager removeItemAtPath:filePatch error:nil];
        if (blDele) {
            
        NSLog(@"dele success");
            [_dataArr  removeAllObjects];
            _dataArr = nil;
        }else {

        NSLog(@"dele fail");

        }
    }
    
}
-(NSString *)filePath{
    NSArray*pathArray =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString*filePatch = [path stringByAppendingPathComponent:@"setConfig.plist"];
    //没有会自动创建
    NSLog(@"file patch%@",filePatch);
    return filePatch;
}
#pragma mark Cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier=@"SetViewCell";
    SetViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    if(Cell==nil)
    {
        Cell=[[SetViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    [Cell setConfigModel:self.dataArr[indexPath.row]];
    Cell.delegate = self;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return Cell;
}
#pragma mark 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}
#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return __kNewSize(92);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.00f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00f;
}
-(void)mySelectClickWithModel:(SetPlistModel *)model{

    if ([model.isSel isEqualToString:@"0"]) {
        model.isSel = @"1";
    }else{
        model.isSel = @"0";
    }
    [self.dataArr replaceObjectAtIndex:[model.type integerValue] withObject:model];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[model.type integerValue] inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self writeDataToPlist];
    //更新本地配置数据库
    SetConfigModel * setModel = [[SetConfigManager sharedManager] getUserInfo];
    for (SetPlistModel * pModel in _dataArr) {
        switch ([pModel.type integerValue]) {
            case 0:
                setModel.isTrace = pModel.isSel;
                break;
            case 1:
                setModel.isRecord = pModel.isSel;
                break;
            case 2:
                setModel.isFullScreen = pModel.isSel;
                break;
            default:
                break;
        }
    }
    [[SetConfigManager sharedManager] updataModel:setModel];

}
#pragma mark - Click
-(void)deleteClick{
    [self deleteDataToPlist];
    [_tableView reloadData];
}


@end
