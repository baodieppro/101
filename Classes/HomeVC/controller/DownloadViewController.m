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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_addUI];
    [self g_layoutFrame];
}
- (void)g_init{
    self.definesPresentationContext = YES;
    self.baseNavigationBar.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    self.navigationTitle = @"下载管理";
    self.baseNavigationBar.titleLabel.textColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"全部开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(__kScreenWidth__-70, 0, 80, 22);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(allDownloadClick) forControlEvents:UIControlEventTouchUpInside];
    self.baseNavigationBar.rightBarButtons = @[btn];
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
        _downView.tagViewController = self;
    }
    return _downView;
}
#pragma mark - Click
-(void)allDownloadClick{
    [_downView gs_ViewDidAppear];
}
@end
