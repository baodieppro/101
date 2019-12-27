//
//  UIViewController+Autorotate.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/28.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "UIViewController+Autorotate.h"

@implementation UIViewController (Autorotate)

- (BOOL)shouldAutorotate{
    //是否允许转屏
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
//    UIInterfaceOrientationMask orientation  = UIInterfaceOrientationMaskPortrait;
//    //viewController初始显示的方向
//    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
//
//    switch (statusBarOrientation) {
//
//        case UIInterfaceOrientationLandscapeLeft:
//
//            orientation = UIInterfaceOrientationMaskLandscapeLeft;
//
//            break;
//
//        case UIInterfaceOrientationLandscapeRight:
//
//            orientation = UIInterfaceOrientationMaskLandscapeRight;
//
//            break;
//
//        default:
//
//            orientation = UIInterfaceOrientationMaskPortrait;
//
//            break;
//
//    }
    
    return UIInterfaceOrientationPortrait;
}
@end
