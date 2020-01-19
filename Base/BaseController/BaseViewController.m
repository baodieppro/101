//
//  BaseViewController.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabBarController.h"
#import "CCWeChatpopView.h"
#import "AppDelegate.h"
#import "CCGS_NO_NetWorkView.h"


@interface BaseViewController ()
@property (nonatomic,strong) CCGS_NO_NetWorkView * netWorkView;

@end

@implementation BaseViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
// 字体设置为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self gs_init];
}
-(void)gs_init{
    self.modalPresentationStyle = UIModalPresentationFullScreen;
//    self.isModalInPresentation = false;
    [self.view addSubview:self.myView];

//    if (self.navigationController == nil) {
//        GSLog(@"没有导航栏");
//        [self no_naviLayoutView];
//    }else{
        GSLog(@"有导航栏");
        if ([NSStringFromClass([self class]) isEqualToString:@"WebViewController"]
            ||[NSStringFromClass([self class]) isEqualToString:@"QRCodeViewController"] )
        {
            [self layoutSubviews];
        }else{
            [self.view addSubview:self.baseNavigationBar];
            [self layoutViews];
        }
        self.view.backgroundColor = [UIColor whiteColor];
        //消除导航栏的影响,显示的视图不被导航栏覆盖
        self.view.userInteractionEnabled = YES;
        self.automaticallyAdjustsScrollViewInsets = false;
//    }
    GSLog(@"%@",NSStringFromClass([self class]));
    
    
}
- (void)layoutViews {
    _myView.frame = CGRectMake(0, __kNavigationBarHeight__, __kScreenWidth__,__kContentHeight__);
    _baseNavigationBar.frame = CGRectMake(0, 0, __kScreenWidth__,__kNavigationBarHeight__);
}
- (void)layoutSubviews {    
    _myView.frame = CGRectMake(0, 0, __kScreenWidth__,__kScreenHeight__);
}
-(void)no_naviLayoutView{
    _myView.frame = CGRectMake(0, 0, __kScreenWidth__,__kScreenHeight__-__kNavigationBarHeight__);
}
#pragma mark - 添加通知
-(void)addNotification{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataNotification:) name:NEED_RLOADDATA_LOGIN_NOTIFICATION object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endNotWorkNotification:) name:NEED_NO_NETWORK_NOTIFICATION object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusNotWorkNotification:) name:NEED_STATUS_NETWORK_NOTIFICATION object:nil];
//
    
}
-(void)removeNotification{
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:NEED_RLOADDATA_LOGIN_NOTIFICATION object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:NEED_NO_NETWORK_NOTIFICATION object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:NEED_STATUS_NETWORK_NOTIFICATION object:nil];

}
#pragma mark - 消息通知
-(void)loadDataNotification:(NSNotification *)notification{
    GSLog(@"base收到登陆后通知了");
}
-(void)endNotWorkNotification:(NSNotification *)notification{
    [self.view insertSubview:self.netWorkView atIndex:1];
    
}
-(void)statusNotWorkNotification:(NSNotification *)notification{
    if (_netWorkView) {
        [_netWorkView removeFromSuperview];
        _netWorkView = nil;
    }
   
}
-(void)wechatBinding_Success_Notification:(NSNotification *)notification{
    GSLog(@"wechatBinding_Success_Notification");

}
-(void)wechatBinding_Error_kNotification:(NSNotification *)notification{
    GSLog(@"wechatBinding_Error_kNotification");
}
#pragma mark - set
-(void)setNavigationTitle:(NSString *)navigationTitle{
    self.baseNavigationBar.titleLabel.text = navigationTitle;
}
#pragma mark - 懒加载
- (BaseView *)myView
{
    if (!_myView) {
        _myView = [[BaseView alloc]init];
        _myView.backgroundColor = GlobalBGColor;
    }
    return _myView;
}
-(CCGS_NO_NetWorkView *)netWorkView{
    if (!_netWorkView) {
        _netWorkView = [[CCGS_NO_NetWorkView alloc]init];
        [_netWorkView.backButton addTarget:self action:@selector(dismissRooVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_netWorkView];
    }
    return _netWorkView;
}

- (BaseNavigationBar *)baseNavigationBar{
    if (!_baseNavigationBar) {
        _baseNavigationBar = [[BaseNavigationBar alloc] initWithFrame:CGRectZero];
        //        GSLog(@"_baseNavigationBar Height %f",__kNavigationBarHeight__);
        _baseNavigationBar.backgroundColor = [UIColor whiteColor];
        [_baseNavigationBar addSubview:self.xian];
    }
    return _baseNavigationBar;
}
-(UIView *)xian{
    if (!_xian) {
        _xian = [[UIView alloc]initWithFrame:CGRectMake(0, __kNavigationBarHeight__, __kScreenWidth__, 1)];
        _xian.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    }
    return _xian;
}
#pragma mark - Push

#pragma mark - 公开方法
- (void)createRightBarButtonWithImageName:(NSString *)imageName WithSelector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.frame = CGRectMake(__kScreenWidth__-20, 0, 22, 22);
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.baseNavigationBar.rightBarButtons = @[btn];
    
}
- (void)createRightBarButtonWithTitle:(NSString *)titleName WithSelector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:titleName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(__kScreenWidth__-70, 0, 60, 22);
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.baseNavigationBar.rightBarButtons = @[btn];
    
}
- (void)createLeftBarButtonWithImageName:(NSString *)imageName WithSelector:(SEL)selector
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.baseNavigationBar.leftBarButtons = @[backBtn];
    
}
-(void)dismissRooVC{
    UIViewController * presentingViewController = self.presentingViewController;
    while (presentingViewController.presentingViewController) {
        presentingViewController = presentingViewController.presentingViewController;
    }
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)dismissRooVC:(NSString *)vcName{
    UIViewController * presentingViewController = self.presentingViewController;
    if ([NSStringFromClass([presentingViewController class]) isEqualToString:vcName]) {
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }else{
        while (presentingViewController.presentingViewController) {
            presentingViewController = presentingViewController.presentingViewController;
            GSLog(@"%@",NSStringFromClass([presentingViewController class]));
            if ([NSStringFromClass([presentingViewController class]) isEqualToString:vcName]) {
                break;
            }
        }
        [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
}
-(void)dismissVC{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        
    }
  
}
-(void)dismissVCsubtype:(NSString *)type{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionPush;
    animation.subtype = type;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


-(BOOL)isBaseOrientation{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
        NSLog(@"windowOrientation:%ld",orientation);
        if (orientation == UIInterfaceOrientationPortrait) {
            return NO;
        }

        if (orientation == UIInterfaceOrientationLandscapeRight) {
            return YES;
        }
    //默认没有横屏
     return NO;
}

-(void)indexVCpop:(NSInteger)index{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *controller = app.window.rootViewController;
    
    BaseTabBarController *rvc = (BaseTabBarController *)controller;
    
    [rvc setSelectedIndex:index];//假如要跳转到第四个tabBar那里，因为tabBar默认索引是从0开始的
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//- (BOOL)shouldAutorotate {
//    return YES;
//}
////返回支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
////由模态推出的视图控制器 优先支持的屏幕方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}
@end
