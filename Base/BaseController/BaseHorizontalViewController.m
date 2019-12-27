//
//  BaseHorizontalViewController.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/28.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "BaseHorizontalViewController.h"

@interface BaseHorizontalViewController ()

@end

@implementation BaseHorizontalViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
-(void)viewWillAppear:(BOOL)animated{
//    __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.myView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
    self.baseNavigationBar.isHidden = YES;
    self.baseNavigationBar.frame = CGRectMake(0, 0, 0, 0);
    self.xian.alpha = 0;
    if (@available(iOS 13.0, *)) {
        self.myView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.myView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
    }else{
       __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.myView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.myView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
    }else{
       __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
    }
    self.baseNavigationBar.isHidden = YES;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
