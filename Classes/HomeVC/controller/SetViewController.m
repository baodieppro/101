//
//  SetViewController.m
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/28.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "SetViewController.h"
#import "SetConfigView.h"

@interface SetViewController ()
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) SetConfigView * setView;

@end

@implementation SetViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self create_Init];
    [self create_UI];
    [self create_Frame];
}
-(void)create_Init{
    self.baseNavigationBar.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    self.naviTitle = @"设置";
    self.baseNavigationBar.titleLabel.textColor = [UIColor whiteColor];

}
-(void)create_UI{
    [self.myView addSubview:self.setView];
}
-(void)create_Frame{
    [_setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.myView);
    }];
}
#pragma mark - 懒加载
-(SetConfigView *)setView{
    if (!_setView) {
        _setView = [[SetConfigView alloc] init];
    }
    return _setView;
}

@end
