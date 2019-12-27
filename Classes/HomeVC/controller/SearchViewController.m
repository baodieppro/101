//
//  SearchViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "SearchViewController.h"
#import "WebViewController.h"

#import "SearchHistoryView.h"

@interface SearchViewController ()<MySearchHistoryViewDelegate>
@property (nonatomic,strong) SearchHistoryView * searchHistoryView;
@end

@implementation SearchViewController

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
    [self.myView addSubview:self.searchHistoryView];
}
- (void)g_layoutFrame{
    [_searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.myView);
    }];
}
#pragma mark - Click
-(void)cancelClick{
    if ([self.delegate respondsToSelector:@selector(mySearchWithKeyWord:)]) {
        [self dismissVC];
    }else{
        [self dismissRooVC];
    }
}
#pragma mark - Delegate
-(void)mySelectedIndexItmeWithClick:(NSString *)keyword{
    if ([self.delegate respondsToSelector:@selector(mySearchWithKeyWord:)]) {
        [self.delegate mySearchWithKeyWord:keyword];
        [self dismissVC];
    }else{
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.url = keyword;
        [self presentViewController:webVC animated:YES completion:nil];
    }
   
}
#pragma mark - 懒加载
-(SearchHistoryView *)searchHistoryView{
    if (!_searchHistoryView) {
        _searchHistoryView = [[SearchHistoryView alloc]init];
        [_searchHistoryView.cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _searchHistoryView.delegate = self;
    }
    return _searchHistoryView;
}

@end
