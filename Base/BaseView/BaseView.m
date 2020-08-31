//
//  BaseView.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseView.h"
#import "BaseNavigationController.h"

@implementation BaseView

- (UIViewController *)recursiveFindCurrentShowViewControllerFromViewController:(UIViewController *)fromVC
{
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        
        return [self recursiveFindCurrentShowViewControllerFromViewController:[((UINavigationController *)fromVC) visibleViewController]];
        
    } else if ([fromVC isKindOfClass:[UITabBarController class]]) {
        
        return [self recursiveFindCurrentShowViewControllerFromViewController:[((UITabBarController *)fromVC) selectedViewController]];
        
    } else {
        
        if (fromVC.presentedViewController) {
            
            return [self recursiveFindCurrentShowViewControllerFromViewController:fromVC.presentedViewController];
            
        } else {
            
            return fromVC;
            
        }
        
    }
    
}



/** 查找当前显示的ViewController*/

- (UIViewController *)getCurrentVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowVC = [self recursiveFindCurrentShowViewControllerFromViewController:rootVC];
    return currentShowVC;
}
//模态跳转
-(void)presentViewController:(UIViewController *)vc isAnimated:(BOOL)animated{

        [self getCurrentVC].definesPresentationContext = YES;
         //设置模态视图弹出样式
         vc.modalPresentationStyle = UIModalPresentationFullScreen;
         [[self getCurrentVC] presentViewController:vc animated:animated completion:nil];
}
-(void)pushViewController:(UIViewController *)vc isAnimated:(BOOL)animated{
    if ([self getCurrentVC].navigationController == nil) {
        BaseNavigationController * navi = [[BaseNavigationController alloc]initWithRootViewController:vc];
       [[self getCurrentVC].navigationController pushViewController:navi animated:animated];
    }else{
        [[self getCurrentVC].navigationController pushViewController:vc animated:animated];

    }
   
}
-(void)pushBaseNavigationController:(UIViewController *)vc isAnimated:(BOOL)animated{
    BaseNavigationController * navi = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [[self getCurrentVC].navigationController pushViewController:navi animated:animated];
}
-(void)pushViewControllerName:(NSString *)vcName isAnimated:(BOOL)animated{
    if (!kStringIsEmpty(vcName)) {
        UIViewController *vc = [NSClassFromString(vcName) new];
           [self pushViewController:vc isAnimated:animated];
    }
}
-(void)presentViewControllerName:(NSString *)vcName isAnimated:(BOOL)animated{
    if (!kStringIsEmpty(vcName)) {
        UIViewController *vc = [NSClassFromString(vcName) new];
           [self presentViewController:vc isAnimated:animated];
    }
}
#pragma mark - pop
-(void)popToRootViewControllerAnimated:(BOOL)isAnimated{
    [[self getCurrentVC].navigationController popToRootViewControllerAnimated:isAnimated];
}
-(void)popViewControllerAnimated:(BOOL)isAnimated{
    [[self getCurrentVC].navigationController popViewControllerAnimated:isAnimated];
}
-(void)popToViewController:(NSString *)vcName animated:(BOOL)animated{
//    UIViewController *viewController = [NSClassFromString(vcName) new];
    UIViewController *viewController = nil;
  for (int i = 0; i < [self getCurrentVC].navigationController.viewControllers.count; i++) {
        viewController = [self getCurrentVC].navigationController.viewControllers[i];
//      GSLog(@"vcname:%@ index:%d",NSStringFromClass([viewController class]),i);
       if ([NSStringFromClass([viewController class]) isEqualToString:vcName]) {
           break;
       }
    }

    [[self getCurrentVC].navigationController popToViewController:viewController animated:YES];
}

#pragma mark - dismissVC

-(void)dismissRooVC{
//    if (self.navigationController != nil) {
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }else{
        UIViewController * presentingViewController = [self getCurrentVC].presentingViewController;
        while (presentingViewController.presentingViewController) {
            presentingViewController = presentingViewController.presentingViewController;
        }
        [presentingViewController dismissViewControllerAnimated:NO completion:nil];
//    }
}

-(void)dismissRooVC:(NSString *)vcName{
    UIViewController * presentingViewController = [self getCurrentVC].presentingViewController;
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
//    if ([self getCurrentVC].navigationController != nil) {
//        [[self getCurrentVC].navigationController popViewControllerAnimated:YES];
//    }else{
//        [[self getCurrentVC] dismissViewControllerAnimated:NO completion:^{
//
//        }];
//
//    }
  [[self getCurrentVC] dismissViewControllerAnimated:NO completion:^{
             
    }];
}
-(void)dismissVCsubtype:(NSString *)type{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionPush;
    animation.subtype = type;
    [[self getCurrentVC].view.window.layer addAnimation:animation forKey:nil];
    [[self getCurrentVC] dismissViewControllerAnimated:NO completion:^{
        
    }];
}

@end
