//
//  SubViewController.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/21.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "SubViewController.h"
#import "AppDelegate.h"

@interface SubViewController ()

@end

@implementation SubViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
}
#pragma mark - title
- (void)setNaviTitle:(NSString *)naviTitle{
    if (self.navigationController == nil) {
//            self.navigationView.titleLabel.text = naviTitle;
        }else{
            self.baseNavigationBar.titleLabel.text = naviTitle;
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sub_Init];
    [self sub_CreateUI];
    [self sub_LayoutFrame];
}
-(void)sub_Init{
    
    if (self.navigationController == nil) {
        self.myView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
        self.baseNavigationBar.isHidden = YES;
    }else{
        self.myView.frame = CGRectMake(0, __kNavigationBarHeight__, __kScreenWidth__, __kOriginalHeight__);
        self.baseNavigationBar.frame = CGRectMake(0, 0, __kScreenWidth__, __kNavigationBarHeight__);
    }

}
-(void)sub_CreateUI{
    if (self.navigationController == nil) {
        [self.myView addSubview:self.backButton];
    }else{
        [self createLeftBarButtonWithImageName:@"icon_subject_back" WithSelector:@selector(backAction:)];
    }
}
-(void)sub_LayoutFrame{
    if (self.navigationController == nil) {
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myView).mas_offset(StatusBarHeight);
            make.left.mas_equalTo(self.myView).mas_offset(20);
        }];
    }
}

- (void)backAction:(UIButton *)sender{
    [self backVC_Click];
}
-(void)backVC_Click{
    if (self.navigationController != nil) {
        switch (self.popVCType) {
            case RootControllerType:
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
                break;
            case popControllerType:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_subject_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel];
    }
    return _backButton;
}
@end
