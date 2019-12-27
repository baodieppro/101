//
//  ToolsMenuView.m
//  GSDlna
//
//  Created by ios on 2019/12/26.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "ToolsMenuView.h"
static ToolsMenuView* updateappearances = nil;
@interface ToolsMenuView ()<UIGestureRecognizerDelegate>
@property (nonatomic,weak) UIWindow * window;//!<
@property (nonatomic ,strong) UIView * menuBackGroundView;
@property (nonatomic ,strong) UIView * menuView;

@property (nonatomic ,strong) UIButton * setupButton;
@property (nonatomic ,strong) UIButton * backButton;
@property (nonatomic ,strong) UIButton * shareButton;

@property (nonatomic,strong) NSMutableArray * itemTitleArr;//!<按钮名称
@property (nonatomic,strong) NSMutableArray * itemImagerArr;//!<图片名称

@end
@implementation ToolsMenuView


+ (ToolsMenuView *)menu
{
    static dispatch_once_t onceUpdateToken;
    dispatch_once(&onceUpdateToken, ^{
        updateappearances = [[ToolsMenuView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__)];
    });
    
    return updateappearances;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
        [self setCreateButton:self.itemTitleArr imager:self.itemImagerArr];

    }
    return self;
}
-(void)g_Init{
    self.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
    [[UIApplication sharedApplication].keyWindow addSubview:self];

}
-(void)g_CreateUI{
    [self addSubview:self.menuBackGroundView];
    [self addSubview:self.menuView];
    [_menuView addSubview:self.setupButton];
    [_menuView addSubview:self.backButton];
    [_menuView addSubview:self.shareButton];

}
-(void)g_LayoutFrame{
    [_menuBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.menuView.mas_bottom).mas_offset(-10);
        make.left.mas_equalTo(self.menuView.mas_left).mas_offset(20);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuView);
        make.centerY.mas_equalTo(self.setupButton);
    }];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.right.mas_equalTo(self.menuView.mas_right).mas_offset(-20);
    }];
}
#pragma mark - 私有方法
- (void)gs_display{
    [_menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(-10);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.mas_equalTo(__kNewSize(500));
    }];
}
- (void)gs_hiddenView{
    [_menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(510);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.mas_equalTo(__kNewSize(500));
    }];
}
-(void)gs_removeView{
    self.hidden = YES;
}
#pragma mark - 公共方法
-(void)show{
    __kWeakSelf__;
    self.hidden = NO;
    [weakSelf gs_display];
    CGPoint startPosition = self.menuView.layer.position;
    self.menuView.layer.position = CGPointMake(startPosition.x, CGRectGetMaxY(self.frame) + startPosition.y);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.menuView.layer.position = startPosition;
    } completion:^(BOOL finished) {
        
    }];

}
-(void)dismiss{
    __kWeakSelf__;
    CGPoint startPosition = self.menuView.layer.position;
    CGPoint endPosition = self.menuView.layer.position;
    endPosition = CGPointMake(startPosition.x, startPosition.y + startPosition.y);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.menuView.layer.position = endPosition;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        weakSelf.menuView.layer.position = startPosition;
    }];
    
}
-(void)isFavorite:(BOOL)isF{
    UIControl * con = [_menuView viewWithTag:120+3];
    UIImageView * img = [con viewWithTag:44444+3];
//    UILabel * lab = [con viewWithTag:55555+3];
    if (isF == YES) {
        img.image = [UIImage imageNamed:@"collect_done"];
    }else{
        img.image = [UIImage imageNamed:@"collect_noun"];
    }
}
#pragma mark - 懒加载

-(UIView *)menuBackGroundView{
    if (!_menuBackGroundView) {
        _menuBackGroundView = [[UIView alloc]init];
        _menuBackGroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [_menuBackGroundView addGestureRecognizer:tap];
    }
    return _menuBackGroundView;
}
-(UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc]init];
        _menuView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 20;
    }
    return _menuView;
}
-(UIButton *)setupButton{
    if (!_setupButton) {
        _setupButton = [self setNewButtonWithImageName:@"tool_bird_7" Target:self action:@selector(setUpClick)];
    }
    return _setupButton;
}
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [self setNewButtonWithImageName:@"tool_bird_11" Target:self action:@selector(dismiss)];
    }
    return _backButton;
}
-(UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [self setNewButtonWithImageName:@"tool_bird_5" Target:self action:@selector(shareToolBarClick)];
    }
    return _shareButton;
}
-(NSMutableArray *)itemTitleArr{
    if (!_itemTitleArr) {
        _itemTitleArr = [NSMutableArray arrayWithArray:@[@"书签",@"历史",@"下载管理",@"收藏网址",@"刷新",@"视频播放",@"二维码识别"]];
    }
    return _itemTitleArr;
}
-(NSMutableArray *)itemImagerArr{
    if (!_itemImagerArr) {
        _itemImagerArr = [NSMutableArray arrayWithArray:@[@"me_8",@"lishi",@"tool_bird_3",@"collect_noun",@"tool_bird_13",@"window_small",@"home_bird"]];
    }
    return _itemImagerArr;
}
#pragma mark - 工厂模式
- (UIButton *)setNewButtonWithImageName:(NSString *)imageStr Target:(nullable id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)setCreateButton:(NSArray *)itemTitleNameArray imager:(NSArray *)itemImageNameArray
{
    NSInteger count = itemTitleNameArray.count;
    
    for (NSInteger r = 0; r < count; r++) {
        UIControl * con = [_menuView viewWithTag:120+r];
        UIImageView * img = [con viewWithTag:44444+r];
        UILabel * lab = [con viewWithTag:55555+r];
        [img removeFromSuperview];
        [lab removeFromSuperview];
        [con removeFromSuperview];
    }
    int itmeCount = 4;
    CGFloat spaceWidth = 10;
    CGFloat spaceHeight = 20;

    CGFloat itmeWidth = (__kScreenWidth__-(spaceWidth*(itmeCount+1)))/itmeCount;

    for (int i=0; i<count; i++)
    {
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(spaceWidth +(i%itmeCount)*(__kNewSize(136)+spaceWidth),40+spaceHeight +(i/itmeCount)*(spaceWidth+__kNewSize(120)), itmeWidth,__kNewSize(120))];
        
        control.tag = 120+i;
        [control addTarget:self action:@selector(btnMenuClickedOK:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:control];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((control.bounds.size.width-__kNewSize(68))/2, 0, __kNewSize(68), __kNewSize(68))];
        imageView.tag = 44444+i;
        imageView.image = [UIImage imageNamed:itemImageNameArray[i]];
        [control addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, control.frame.size.height-__kNewSize(24+12), control.bounds.size.width, __kNewSize(24));
        label.text = itemTitleNameArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:__kNewSize(24)];
        label.tag = 55555+i;
        label.textColor = [UIColor colorWithHexString:@"#4e4e4e"];
        [control addSubview:label];
        
    }
}
#pragma mark - 代理实现
- (void)setDelegateItmeWithClick:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(myToolsMenuSelectedIndexItmeWithClick:)]) {
        [self.delegate myToolsMenuSelectedIndexItmeWithClick:index];
    }
    [self dismiss];
}
#pragma mark - 响应
-(void)shareToolBarClick{
    GSLog(@"分享");
    [self setDelegateItmeWithClick:888];
}
-(void)setUpClick{
    GSLog(@"设置");
    [self setDelegateItmeWithClick:999];
}
-(void)btnMenuClickedOK:(UIControl *)ctl{
    GSLog(@"%ld",ctl.tag-120);
    NSInteger _tag = ctl.tag-120;
    [self setDelegateItmeWithClick:_tag];
}
- (void)tap:(UITapGestureRecognizer *)tap{
    [self dismiss];
}

#pragma mark - 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 假设为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
        GSLog(@"%@",NSStringFromClass([touch.view class]));
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"menuView"]) {
            return NO;
        }
    
    return  YES;
    
}
@end
