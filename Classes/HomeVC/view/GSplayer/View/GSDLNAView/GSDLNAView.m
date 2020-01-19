//
//  GSDlLNAView.m
//  GSPlay
//
//  Created by Roger on 2019/9/11.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import "GSDLNAView.h"
#import "DLNABottomView.h"
#import "DlnaTableViewCell.h"


@interface GSDLNAView ()<UITableViewDataSource,UITableViewDelegate,GSDLNADelegate,UIGestureRecognizerDelegate>
{
    BOOL isData;
    NSInteger index;
}
@property (nonatomic,strong) UIView * backGroundView;//!<背景View
@property (nonatomic,strong) UIView * dlnaView;//!<投屏View
@property (nonatomic,strong) UILabel * dlnaLable;//!<投屏顶部title
@property (nonatomic,strong) UITableView * dlnaTableView;//!<投屏列表
@property (nonatomic,strong) DLNABottomView * bottomView;//!<底部说明View
@property(nonatomic,strong) NSMutableArray *deviceArr;

@property(nonatomic,strong) LBManager *dlnaManager;
//手势
@property (nonatomic, strong) UITapGestureRecognizer *tapNewGesture;

@end

@implementation GSDLNAView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self d_Init];
        [self d_createUI];
        [self d_layoutFrame];
        [self addGesture];
    }
    return self;
}

-(void)d_Init{
    isData = NO;
//    NSArray * deviceArr = @[@"客厅的小米电视",@"乐播电视",@"小米电视",@"华为电视",@"果果投屏",@"优酷投屏",@"虎牙直播"];
//    [self.deviceArr addObjectsFromArray:deviceArr];
//    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//    [self startSearchDLNA];
}
-(void)d_createUI{
    [self addSubview:self.backGroundView];
    [self addSubview:self.dlnaView];
    [_dlnaView addSubview:self.dlnaLable];
    [_dlnaView addSubview:self.dlnaTableView];
    [_dlnaView addSubview:self.bottomView];
}
-(void)d_layoutFrame{
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_dlnaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(self);
    }];
    [_dlnaLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dlnaView).mas_offset(30);
        make.left.mas_equalTo(self.dlnaView).mas_offset(20);
        make.width.mas_equalTo(202);
        make.height.mas_equalTo(20);
    }];
    [_dlnaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dlnaLable.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(self.dlnaLable);
        make.right.mas_equalTo(self.dlnaView);
        make.height.mas_equalTo(200);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dlnaTableView.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(self.dlnaTableView);
        make.right.mas_equalTo(self.dlnaTableView);
        make.bottom.mas_equalTo(self.dlnaView.mas_bottom);
    }];
}

#pragma mark - UI
-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    }
    return _backGroundView;
}
-(UIView *)dlnaView{
    if (!_dlnaView) {
        _dlnaView = [[UIView alloc]init];
        _dlnaView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _dlnaView;
}
-(UILabel *)dlnaLable{
    if (_dlnaLable == nil) {
        _dlnaLable = [[UILabel alloc]init];
        _dlnaLable.font =[UIFont systemFontOfSize:12];
        _dlnaLable.textAlignment = NSTextAlignmentLeft;
        _dlnaLable.textColor = [UIColor colorWithHexString:@"#ffffff"];
        //        _dlnaLable.userInteractionEnabled = YES;
        _dlnaLable.text = @"请选择需要投屏的设备";
    }
    return _dlnaLable;
}
-(UITableView *)dlnaTableView{
    if (!_dlnaTableView) {
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
        
        [tableView registerClass:[DlnaTableViewCell class] forCellReuseIdentifier:@"DlnaTableViewCell"];
        _dlnaTableView = tableView;
    }
    return _dlnaTableView;
}
-(DLNABottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[DLNABottomView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _bottomView;
}
-(NSMutableArray *)deviceArr{
    if (!_deviceArr) {
        _deviceArr = [[NSMutableArray alloc]init];
    }
    return _deviceArr;
}
#pragma mark - 公共方法
-(void)startSearchDLNA{
    self.dlnaManager = [LBManager sharedDLNAManager];
    self.dlnaManager.delegate = self;
    [self.dlnaManager searchService];
    [self.dlnaView gs_showLoadingHud:@"正在搜索设备..."];

}
#pragma mark - Click
-(void)tapRemove{
    [self gs_hideHudImmediately];
    [self.dlnaManager endService];
    [self removeFromSuperview];
}
#pragma mark - 添加手势识别器
- (void)addGesture
{
    // 添加Tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemove)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    self.tapNewGesture = tapGesture;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 判断是不是UIButton的类
//    NSLog(@"%@",NSStringFromClass([touch.view class]));
    
//    if ([touch.view isKindOfClass:[UIButton class]])
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - DLNA

- (void)gs_searchDLNAResult:(NSArray *)devicesArray{
    if (devicesArray.count != 0) {
        if (_deviceArr.count != 0) {
            [_deviceArr removeAllObjects];
        }
        //测试
         isData = YES;
         NSLog(@"发现设备");
    }else{
        NSLog(@"没有发现设备");
        [self.dlnaView gs_showTextHud:@"没有发现设备"];
    }
    [self.dlnaView gs_hideHudImmediately];
    [self.deviceArr addObjectsFromArray:devicesArray];
    [self.dlnaTableView reloadData];
}

- (void)dlnaStartPlay{
    NSLog(@"投屏成功 开始播放");
    [self tapRemove];
    [self gs_showTextHud:@"投屏成功，开始播放"];
    NSString *model = self.deviceArr[index];
    if ([self.delegate respondsToSelector:@selector(gs_dlnaStartPlay:listIndex:)])
    {
        [self.delegate gs_dlnaStartPlay:model listIndex:self.listIndex];
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
    return _deviceArr.count;
}
//数据交互
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIndentifier = @"DlnaTableViewCell";
    DlnaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
    //初始化单元格
    if(cell == nil)
    {
        cell = [[DlnaTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
    }
    if (_deviceArr.count != 0) {
        cell.nameLable.text = _deviceArr[indexPath.row];
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择设备:%@",_deviceArr[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    index =indexPath.row;
    if (isData == YES) {
        if (self.deviceArr.count != 0) {
            [self.dlnaManager startLBLelinkConnection:indexPath.row];
            [self.dlnaManager setLBLelinkPlayerItemPlayUrl:self.playUrl];
        }
    }
   
}
@end
