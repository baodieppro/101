//
//  BookmarkClickVC.m
//  GSDlna
//
//  Created by ios on 2019/12/18.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BookmarkClickVC.h"
#import "BookmarkClickView.h"

@interface BookmarkClickVC ()
@property (nonatomic,strong) BookmarkClickView * bookMarkView;
@end

@implementation BookmarkClickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_addUI];
    [self g_layoutFrame];
}
- (void)g_init{
    self.baseNavigationBar.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    self.navigationTitle = @"书签";
    self.baseNavigationBar.titleLabel.textColor = [UIColor whiteColor];

}
- (void)g_addUI{
    [self.myView addSubview:self.bookMarkView];
    [self.myView bringSubviewToFront:self.backButton];

}
- (void)g_layoutFrame{
    [_bookMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.myView);
    }];
}
#pragma mark - 懒加载
-(BookmarkClickView *)bookMarkView{
    if (!_bookMarkView) {
        _bookMarkView = [[BookmarkClickView alloc]init];
    }
    return _bookMarkView;
}
@end
