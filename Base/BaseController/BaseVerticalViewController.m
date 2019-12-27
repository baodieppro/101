//
//  BaseVerticalViewController.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/28.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "BaseVerticalViewController.h"

@interface BaseVerticalViewController ()

@end

@implementation BaseVerticalViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewWillAppear:(BOOL)animated {
    __kAppDelegate__.allowRotation = NO;//关闭横屏仅允许竖屏
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __kAppDelegate__.allowRotation = NO;//关闭横屏仅允许竖屏
    if (self.navigationController == nil) {
        self.myView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
        self.baseNavigationBar.isHidden = YES;
    }
}

-(void)windowOrientation:(UIWindow *)window isallowRotation:(BOOL)isallowRotation{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    NSLog(@"windowOrientation:%ld",orientation);
    if (orientation == UIInterfaceOrientationPortrait) {
        
    }
    
    if (orientation == UIInterfaceOrientationLandscapeRight) {
    
    }
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
