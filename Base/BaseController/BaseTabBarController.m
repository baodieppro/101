//
//  BaseTabBarController.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;
@end

@implementation BaseTabBarController

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}

#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 添加通知观察者
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeValue) name:SSMESSAGECOUNTCHANGE object:nil];
    //
    // 添加badgeView
    [self addBadgeViewOnTabBarButtons];
    
    //    self.selectedViewController = [self.viewControllers objectAtIndex:1]; //默认选择搜索index为1
}


#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [UITabBar appearance].translucent = NO;
    self.delegate = self;
    [self addDcChildViewContorller];
}


#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    
    NSArray *childArray = @[
                            
                            @{MallClassKey  : @"HomeVC",
                              MallTitleKey  : @"首页",
                              MallImgKey    : TabBarSelImgHome,
                              MallSelImgKey : TabBarImgHome},
                            
                            @{MallClassKey  : @"ShareVC",
                              MallTitleKey  : @"分享",
                              MallImgKey    : TabBarSelImgLoans,
                              MallSelImgKey : TabBarImgLoans},
                            
                            @{MallClassKey  : @"OrderVC",
                              MallTitleKey  : @"订单",
                              MallImgKey    : TabBarSelImgInformation,
                              MallSelImgKey : TabBarImgInformation},
                            
                            @{MallClassKey  : @"MineVC",
                              MallTitleKey  : @"我的",
                              MallImgKey    : TabBarSelImgMyCenter,
                              MallSelImgKey : TabBarImgMyCenter},
                            ];
    
    
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[MallTitleKey];
        item.image = [UIImage imageNamed:dict[MallSelImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        item.imageInsets = UIEdgeInsetsMake(3, 6, 3, 6);//（当只有图片的时候）需要自动调整
        [self addChildViewController:nav];
        //未选中
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#515C6F"]} forState:UIControlStateNormal];
        //选中
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#06ADF3"]} forState:UIControlStateSelected];
        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}

#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
//        if(viewController == [tabBarController.viewControllers objectAtIndex:SSTabBarControllerShoppingCart]){
    //
    ////        if (![[SSObjManager ss_readUserDataForKey:@"isLogin"] isEqualToString:@"1"]) {
    ////
    //        [ALBCPush pushALBCSDK:pushALBCTypeMyCarts openType:ALBCOpenTypeH5 data:nil complete:^(UIViewController *vc) {
    ////            [self.navigationController pushViewController:vc animated:YES];
    //            [self presentViewController:vc animated:NO completion:nil];
    //
    //        }];
    //            return NO;
    ////        }
    //    }
    
//      if(viewController == [tabBarController.viewControllers objectAtIndex:2]){
//          LoginVC * logVC =[[LoginVC alloc]init];
//          [self.navigationController pushViewController:logVC animated:YES];
////          [self presentViewController:logVC animated:NO completion:nil];
//          return NO;
//    }
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    //    if (@available(iOS 10.0, *)) {
    //        [tabBarController.tabBarItem setBadgeColor:[UIColor orangeColor]];
    //    } else {
    //        // Fallback on earlier versions
    //        [tabBarController.tabBarItem setBadgeColor:[UIColor orangeColor]];
    //
    //    }
    //       [tabBarController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
    [self tabBarButtonClick:[self getTabBarButton]];
    //    if ([self.childViewControllers.lastObject isEqual:viewController]) { //根据tabBar的内存地址找到美信发通知jump
    ////        [[NSNotificationCenter defaultCenter] postNotificationName:@"jump" object:nil];
    //    }
    
}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
}


#pragma mark - 更新badgeView
- (void)updateBadgeValue
{
    //    _beautyMsgVc.tabBarItem.badgeValue = [SSObjManager ss_readUserDataForKey:@"isLogin"];
}


#pragma mark - 添加所有badgeView
- (void)addBadgeViewOnTabBarButtons {
    
    // 设置初始的badegValue
    //    _beautyMsgVc.tabBarItem.badgeValue = [SSObjManager ss_readUserDataForKey:@"isLogin"];
    //
    //    int i = 0;
    //    for (UITabBarItem *item in self.tabBarItems) {
    //
    //        if (i == 3) {  // 只在美信上添加
    //            [self addBadgeViewWithBadgeValue:item.badgeValue atIndex:i];
    //            // 监听item的变化情况
    //            [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
    //            _item = item;
    //        }
    //        i++;
    //    }
}

//- (void)addBadgeViewWithBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index {
//
//    SSTabBadgeView *badgeView = [SSTabBadgeView buttonWithType:UIButtonTypeCustom];
//
//    CGFloat tabBarButtonWidth = self.tabBar.dc_width / self.tabBarItems.count;
//
//    badgeView.dc_centerX = index * tabBarButtonWidth + 40;
//
//    badgeView.tag = index + 1;
//
//    badgeView.badgeValue = badgeValue;
//
//    [self.tabBar addSubview:badgeView];
//}

#pragma mark - 只要监听的item的属性一有新值，就会调用该方法重新给属性赋值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
//    for (UIView *subView in self.tabBar.subviews) {
        //        if ([subView isKindOfClass:[SSTabBadgeView class]]) {
        //            if (subView.tag == 1) {
        //                //                SSTabBadgeView *badgeView = (SSTabBadgeView *)subView;
        //                //                badgeView.badgeValue = _beautyMsgVc.tabBarItem.badgeValue;
        //            }
        //        }
//    }
    
}


#pragma mark - 移除通知
- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"badgeValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}
@end
