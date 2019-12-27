//
//  BaseView.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseView.h"

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

@end
