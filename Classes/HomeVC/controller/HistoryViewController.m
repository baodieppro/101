//
//  HistoryViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryView.h"

@interface HistoryViewController ()<MyHistoryViewDelegate>
@property (nonatomic,strong) HistoryView * historyView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_addUI];
    [self g_layoutFrame];
}
- (void)g_init{
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
}
- (void)g_addUI{
    [self.myView addSubview:self.historyView];
    [self.myView bringSubviewToFront:self.backButton];
}
- (void)g_layoutFrame{
    [_historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.myView).insets(UIEdgeInsetsMake(ToolbarHeight+10, 0, 0, 0));
    }];
}
#pragma mark - 代理实现
-(void)mySelectAtIndexPathItmeUrl:(NSString *)url{
  
    if ([self.delegate respondsToSelector:@selector(myHistoryRloadViewWithUrl:)]) {
        [self.delegate myHistoryRloadViewWithUrl:url];
    }
      [self dismissVC];
}
#pragma mark - 懒加载
-(HistoryView *)historyView{
    if (!_historyView) {
        _historyView = [[HistoryView alloc]init];
        _historyView.delegate = self;
    }
    return _historyView;
}


@end
