//
//  ViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
#import "NSString+SKYExtension.h"

#import "ViewController.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "PlayViewController.h"
#import "HistoryViewController.h"
#import "DownloadViewController.h"
#import "BookmarkClickVC.h"

#import "SearchView.h"

@interface ViewController ()<UITextFieldDelegate>
{
    BOOL isTextFieldClear;
}
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic,strong) UIButton  * playBtn;//!<播放
@property (nonatomic,strong) UIButton  * searchBtn;//!<搜索
@property (nonatomic,strong) UIButton  * webBtn;//!<web
@property (nonatomic,strong) UIButton  * historyBtn;//!<历史
@property (nonatomic,strong) UIButton  * downloadBtn;//!<下载
@property (nonatomic,strong) UIButton  * bookMarkBtn;//!<书签

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_addUI];
    [self g_layoutFrame];
}
- (void)g_init{
    isTextFieldClear = NO;
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#333333"];

 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteboardNotification:) name:NEED_PUSH_Pasteboard_NOTIFICATION object:nil];
    [DownLoadManager initConfig:@"GSDownLoad"];
}
- (void)g_addUI{
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.webBtn];
    [self.view addSubview:self.historyBtn];
    [self.view addSubview:self.downloadBtn];
    [self.view addSubview:self.bookMarkBtn];
}
- (void)g_layoutFrame{
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(__kNewSize(80));
        make.left.mas_equalTo(self.searchView.mas_left).mas_offset(__kNewSize(30));
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(__kNewSize(80));
        make.right.mas_equalTo(self.searchView.mas_right).mas_offset(-__kNewSize(30));
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    [_webBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBtn.mas_bottom).mas_offset(__kNewSize(80));
        make.left.mas_equalTo(self.searchView.mas_left).mas_offset(__kNewSize(30));
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    [_historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playBtn.mas_bottom).mas_offset(__kNewSize(80));
        make.right.mas_equalTo(self.searchView.mas_right).mas_offset(-__kNewSize(30));
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.webBtn.mas_bottom).mas_offset(__kNewSize(80));
        make.left.mas_equalTo(self.searchView.mas_left).mas_offset(__kNewSize(30));
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    [_bookMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.historyBtn.mas_bottom).mas_offset(__kNewSize(80));
        make.right.mas_equalTo(self.searchView.mas_right).mas_offset(-__kNewSize(30));
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
}
-(void)pasteboardNotification:(NSNotification *)notification{
    GSLog(@"s收到通知：%@",notification.object);
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:notification.object];
    self.searchView.searchTextField.text = [dict objectForKey:@"url"];
    
}
#pragma mark - TextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (isTextFieldClear == NO) {
        [self searchClick];
       
    }
     isTextFieldClear = NO;
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!kStringIsEmpty(textField.text)) {
        [self webClick];
    }
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    isTextFieldClear = YES;
    return YES;
}
#pragma mark - Click
-(void)searchClick{
    SearchViewController * searchVC = [[SearchViewController alloc]init];
    [self presentViewController:searchVC animated:NO completion:nil];
}
-(void)playClick{
    if (!kStringIsEmpty(self.searchView.searchTextField.text)) {
        if([[self.searchView.searchTextField.text pathExtension] isEqualToString:@"m3u8"]||
           [[self.searchView.searchTextField.text pathExtension] isEqualToString:@"mp4"]
           ){
            PlayViewController * playVC = [[PlayViewController alloc]init];
            __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
            playVC.playUrl = self.searchView.searchTextField.text;
            [self presentViewController:playVC animated:NO completion:nil];
        }else{
            [self.view gs_showTextHud:[NSString stringWithFormat:@"播放地址不正确～\n%@",self.searchView.searchTextField.text]];
        }
    }else{
        [self.view gs_showTextHud:@"播放地址不能为空～"];
    }
    
}
-(void)webClick{
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = self.searchView.searchTextField.text;
    [self presentViewController:webVC animated:YES completion:nil];
}
-(void)historyClick{
    HistoryViewController * historyVC = [[HistoryViewController alloc]init];
    [self presentViewController:historyVC animated:YES completion:nil];

}
-(void)downloadClick{
    DownloadViewController *downLoadVC = [[DownloadViewController alloc]init];
    [self presentViewController:downLoadVC animated:YES completion:nil];

}
-(void)bookmarkClick{
    BookmarkClickVC * bookVC = [[BookmarkClickVC alloc] init];
    [self presentViewController:bookVC animated:YES completion:nil];
}
#pragma mark - 懒加载
-(SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(__kNewSize(30),0, __kScreenWidth__-__kNewSize(60), __kNavigationBarHeight__)];
        _searchView.searchTextField.delegate = self;
    }
    return _searchView;
}
-(UIButton *)playBtn{
    if (_playBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =5;
        [button addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _playBtn = button;
    }
    return _playBtn;
}
-(UIButton *)searchBtn{
    if (_searchBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"搜索服务" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =5;
        [button addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _searchBtn = button;
    }
    return _searchBtn;
}
-(UIButton *)webBtn{
    if (_webBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"浏览器" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =5;
        [button addTarget:self action:@selector(webClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _webBtn = button;
    }
    return _webBtn;
}
-(UIButton *)historyBtn{
    if (_historyBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"历史" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =5;
        [button addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _historyBtn = button;
    }
    return _historyBtn;
}
-(UIButton *)downloadBtn{
    if (_downloadBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"下载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =5;
        [button addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _downloadBtn = button;
    }
    return _downloadBtn;
}
-(UIButton *)bookMarkBtn{
    if (_bookMarkBtn == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"书签" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =5;
        [button addTarget:self action:@selector(bookmarkClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _bookMarkBtn = button;
    }
    return _bookMarkBtn;
}
@end
