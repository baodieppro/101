//
//  DownloadViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/13.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadView.h"

@interface DownloadViewController ()
@property (nonatomic,strong) DownloadView * downView;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_addUI];
    [self g_layoutFrame];
}
- (void)g_init{
    self.baseNavigationBar.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    self.navigationTitle = @"下载管理";
    self.baseNavigationBar.titleLabel.textColor = [UIColor whiteColor];
}
- (void)g_addUI{
    [self.myView addSubview:self.downView];
    [self.myView bringSubviewToFront:self.backButton];
}
- (void)g_layoutFrame{
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.myView);
    }];
}
#pragma mark - 懒加载
-(DownloadView *)downView{
    if (!_downView) {
        _downView = [[DownloadView alloc]init];
    }
    return _downView;
}
@end
