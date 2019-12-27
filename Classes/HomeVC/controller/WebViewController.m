//
//  WebViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
#import "NSString+SKYExtension.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "HistoryViewController.h"
#import "DownloadViewController.h"
#import "BookmarkClickVC.h"
#import "PlayViewController.h"
#import "QRCodeViewController.h"

#import "GSWeb.h"
#import "SearchView.h"
#import "NSURLProtocol+WKWebVIew.h"
#import "HybridNSURLProtocol.h"
#import "WebBottomView.h"
#import "ToolsMenuView.h"

@interface WebViewController ()
<
GSWebViewDelegate,
GSWebViewJavaScript,
UIScrollViewDelegate,
UITextFieldDelegate,
MyWebBottomViewDelegate,
MySearchViewControllerDelegate,
MyToolsMenuViewDelegate,
QRDelegate
>
{
    BOOL isplay;
    BOOL isFavorite;

}
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic,strong) UIButton * refreshBtn;//!<刷新按钮

@property (nonatomic,strong) GSWebView * webView;
@property (nonatomic,strong) NSString * webTitle;
@property (nonatomic,strong) NSString * webUrl;
@property (nonatomic,strong) NSString * playUrl;

@property (nonatomic,strong) NSMutableArray * historyDataList;
@property (nonatomic,strong) NSMutableArray * playHistoryDataList;
@property (nonatomic,strong) NSMutableArray * favoriteDataList;

@property (nonatomic, strong) WebBottomView *bottomView;

@end

@implementation WebViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [_webView wkgsDealloc];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:NEED_M3U8_Capture_NOTIFICATION object:nil];
}
//-(void)backVC_Click{
//    [super backVC_Click];
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_CreateUI];
    [self g_LayoutFrame];
    [self g_loadUrl];
}
- (void)g_init{
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    if (kStringIsEmpty(self.url)) {
        self.url = [BookMarkManager readDefUrl]?:@"http://www.63ys.com/";
    }
    isplay = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteboardNotification:) name:NEED_PUSH_Pasteboard_NOTIFICATION object:nil];
    [DownLoadManager initConfig:@"GSDownLoad"];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCaptureM3U8Notification:) name:NEED_M3U8_Capture_NOTIFICATION object:nil];
}
-(void)g_CreateUI{
    [self.myView addSubview:self.webView];
    [self.myView addSubview:self.searchView];
    [self.searchView addSubview:self.refreshBtn];
    [self.myView addSubview:self.bottomView];
}
-(void)g_LayoutFrame{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.myView).insets(UIEdgeInsetsMake(__kNavigationBarHeight__, 0, __kTabBarHeight__, 0));
    }];
    [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView.searchTextField);
        make.right.equalTo(self.searchView.mas_right).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(__kNewSize(60), __kNewSize(60)));
        
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.webView.mas_bottom);
        make.left.right.mas_equalTo(self.myView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(__kTabBarHeight__);
    }];
}
-(void)g_loadUrl{
    if (!kStringIsEmpty(self.url)) {
        [self.webView loadURLString:[GSTool urlWithIsUrl:self.url]];
    }
    if (!kStringIsEmpty(self.html)) {
        [self.webView loadHTMLString:self.html];
    }
    
}
#pragma mark - UI
-(SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(__kNewSize(20), 0, __kScreenWidth__-__kNewSize(40), __kNavigationBarHeight__)];
        _searchView.searchTextField.delegate = self;
        _searchView.searchTextField.clearButtonMode = UITextFieldViewModeNever;

    }
    return _searchView;
}
-(GSWebView *)webView{
    if (!_webView) {
        _webView = [[GSWebView alloc]initWithFrame:CGRectZero JSPerformer:self];
        _webView.delegate = self;
        _webView.script = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        
    }
    return _webView;
}
-(UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setImage:[UIImage imageNamed:@"a3_2"] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshtoolBarClick) forControlEvents:UIControlEventTouchUpInside];
        _refreshBtn.selected = YES;
        _refreshBtn.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        _refreshBtn.layer.cornerRadius = __kNewSize(30);
    }
    return _refreshBtn;
}
-(WebBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[WebBottomView alloc]init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
-(NSMutableArray *)historyDataList{
    if (!_historyDataList) {
        _historyDataList = [[NSMutableArray alloc]init];
        //查询浏览器访问历史
        if ([EntireManageMent isExisedManager:WEB_History_Cache]) {
            [HistoryModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent readCacheDataWithName:WEB_History_Cache]] dataArrName:_historyDataList cacheName:WEB_History_Cache];
        }
    }
    return _historyDataList;
}
-(NSMutableArray *)favoriteDataList{
    if (!_favoriteDataList) {
        _favoriteDataList =[[NSMutableArray alloc]init];
        if ([EntireManageMent isExisedManager:Bookmark_History_Cache]) {
            [HistoryModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent readCacheDataWithName:Bookmark_History_Cache]] dataArrName:_favoriteDataList cacheName:Bookmark_History_Cache];
        }
    }
    return _favoriteDataList;
}
#pragma mark - QRCodeDelegate
-(void)getQRDataString:(NSString *)QRDataString{
    [self.webView stopLoading];
    [self.webView loadURLString:[GSTool urlWithIsUrl:QRDataString]];
}
#pragma mark - SearchDelegate
-(void)mySearchWithKeyWord:(NSString *)keyword{
    [self.webView stopLoading];
    [self.webView loadURLString:[GSTool urlWithIsUrl:keyword]];
}
#pragma mark - TextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    _searchView.searchTextField.text = self.webUrl;
    [self pushSearchVC];
    return NO;
}

#pragma mark - 捕获M3U8通知
-(void)pasteboardNotification:(NSNotification *)notification{
    GSLog(@"收到剪切板通知：%@",notification.object);
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:notification.object];
    NSString * url = [dict objectForKey:@"url"];
    
    if([[url pathExtension] isEqualToString:@"m3u8"]){
        [self pushPlayVC_Url:url];
    }
    else
    {
        [self.webView loadURLString:[GSTool urlWithIsUrl:url]];
    }
    
}
-(void)setCaptureM3U8Notification:(NSNotification *)notification{
    GSLog(@"接收到捕获M3U8通知%@",notification);
    NSDictionary * dict = (NSDictionary *)notification.object;
    self.playUrl = [dict objectForKey:@"play"];
    if (!kStringIsEmpty(self.playUrl)) {
        isplay = YES;
    }
}
//捕获视频播放地址
-(void)playWithUrl:(NSString *)url{
    if ([url containsString:@"m3u8"]) {
        //后戳.m3u8
        if([[url pathExtension] isEqualToString:@"m3u8"]){
            NSArray *array;
            if ([url containsString:@"?id="]) {
                array = [url componentsSeparatedByString:@"?id="];
            }else if ([url containsString:@"?url="]){
                array = [url componentsSeparatedByString:@"?url="];
            }else if ([url containsString:@"?type="]){
                array = [url componentsSeparatedByString:@"?type="];
            }
            //判断是否捕获到地址
            if (array.count >= 2) {
                GSLog(@"视频播放地址：%@",array[1]);
                self.playUrl = array[1];
                if (!kStringIsEmpty(self.playUrl)) {
                    isplay = YES;
                }
            }else{
                GSLog(@"后缀是.m3u8,但捕获规则未加\n%@",url);
            }
        }
        else
        {
            GSLog(@"包含有m3u8的url，但后缀不是.m3u8\n%@",url);
        }
        
    }
}
#pragma mark -GSWebViewDelegate
- (BOOL)gswebView:(GSWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(GSWebViewNavigationType)navigationType
{
    GSLog(@"页面请求加载 %@ ",[request.URL absoluteString] );

    [self playWithUrl:[request.URL absoluteString]];
    
    return YES;
}
-(void)gswebViewDidStartLoad:(GSWebView *)webView url:(nonnull NSString *)url Title:(nonnull NSString *)title{
    GSLog(@"页面开始加载 %@  %@ ",url ,title);
    if (!kStringIsEmpty(url)) {
        self.searchView.searchTextField.text = url;
        [self refreshBackImage:NO];

    }
    
}
-(void)gswebViewDidFinishLoad:(GSWebView *)webView url:(nonnull NSString *)url Title:(nonnull NSString *)title{
    //    __kWeakSelf__;
    GSLog(@"页面加载完成  %@  %@ ",url ,title);
    [self refreshBackImage:YES];
    
    if (!kStringIsEmpty(title)) {
        self.searchView.searchTextField.text = title;
        self.webUrl = url;
        self.webTitle = title;
        [HistoryModel addCacheName:WEB_History_Cache title:title url:url arr:self.historyDataList];
       [self displayNoneAd:url];
        if (isplay == YES) {
            [self pushPlayVC_Url:self.playUrl];
        }
            [[ToolsMenuView menu] isFavorite:[BookMarkManager isExistAppForUrl:self.webUrl]];
       
    }
    
}

-(void)gswebView:(GSWebView *)webView url:(nonnull NSString *)url Title:(nonnull NSString *)title didFailLoadWithError:(nonnull NSError *)error{
    //    [STCModel stcModel].netWorkNEW = 0;
    GSLog(@"页面加载失败  %@  %@ ",url ,title);
    if (!kStringIsEmpty(url)) {
        self.searchView.searchTextField.text = url;
    }
    [self refreshBackImage:YES];

}
-(void)displayNoneAd:(NSString *)url{
    if([url rangeOfString:@"63ys.com"].location != NSNotFound)
    {
        NSString * isNone = @"document.getElementsByClassName('acss')[0].style.display = 'none'";
        [_webView excuteJavaScript:isNone completionHandler:^(id  _Nonnull params, NSError * _Nonnull error) {
            GSLog(@"params :%@\nerror :%@",params,error);
        }];
        NSString * isNone1 = @"document.getElementsByClassName('acss')[1].style.display = 'none'";
        [_webView excuteJavaScript:isNone1 completionHandler:^(id  _Nonnull params, NSError * _Nonnull error) {
            GSLog(@"params :%@\nerror :%@",params,error);
        }];
        NSString * isNone2 = @"document.getElementsByClassName('acss')[2].style.display = 'none'";
        [_webView excuteJavaScript:isNone2 completionHandler:^(id  _Nonnull params, NSError * _Nonnull error) {
            GSLog(@"params :%@\nerror :%@",params,error);
        }];

    }
}
#pragma mark - click
-(void)refreshtoolBarClick
{
    if (_refreshBtn.selected == YES) {
        [self.webView loadURLString:self.webUrl];
    }else{
        [self.webView stopLoading];
    }
    _refreshBtn.selected = !_refreshBtn.selected;
}

#pragma mark - 刷新按钮当前状态
-(void)refreshBackImage:(BOOL)isStop
{
    if (isStop == NO) {
        [_refreshBtn setImage:[UIImage imageNamed:@"a3_3"] forState:UIControlStateNormal];
    }else{
        [_refreshBtn setImage:[UIImage imageNamed:@"a3_2"] forState:UIControlStateNormal];
    }

}
#pragma mark - 底部工具栏状态
-(void)mySelectedIndexItmeWithClick:(WebBottomViewStyleType)Type{
    switch (Type) {
        case GoBackStyleType:
        {
            [_webView goBack];
        }
            break;
        case GoForwardStyleType:
        {
            [_webView goForward];
        }
            break;
        case FavoriteStyleType:
        {
            [[ToolsMenuView menu] show];
            [ToolsMenuView menu].delegate = self;

        }
            break;
        case HomeStyleType:
        {
            [self.webView loadURLString:self.url];
            
        }
            break;
        default:
            break;
    }
}
-(void)myToolsMenuSelectedIndexItmeWithClick:(NSInteger)Type{
    switch (Type) {
        case 0:
        {
            GSLog(@"书签");
            [self push_BookmarkVC];
        }
            break;
        case 1:
        {
            GSLog(@"历史");
            [self push_HistoryVC];
        }
            break;
        case 2:
        {
            GSLog(@"下载管理");
            [self push_DownloadVC];
        }
            break;
        case 3:
        {
            GSLog(@"收藏");
            
            if ([BookMarkManager isExistAppForUrl:self.webUrl] == NO) {
                [BookMarkManager addHistoryData:@{@"title":self.webTitle,@"url":self.webUrl,@"isDef":@"0"}];
            }else{
                [BookMarkManager deleteModelForUrl:self.webUrl];
            }
            [[ToolsMenuView menu] isFavorite:[BookMarkManager isExistAppForUrl:self.webUrl]];

        }
            break;
        case 4:
        {
            GSLog(@"刷新");
            [self.webView reload];
        }
            break;
        case 5:
        {
            GSLog(@"播放视频");
            [self pushPlayVC_Url:self.playUrl];

        }
            break;
        case 6:
        {
            GSLog(@"识别二维码");
            [self push_QRCodeVC];
        }
            break;
        case 888:
        {
           GSLog(@"分享");
        }
            break;
        case 999:
        {
            GSLog(@"设置");
        }
            break;
        default:
            break;
    }
}
#pragma mark - push
-(void)pushPlayVC_Url:(NSString *)url{
    if (!kStringIsEmpty(url)) {
        if([[url pathExtension] isEqualToString:@"m3u8"]||
           [[url pathExtension] isEqualToString:@"mp4"]
           ){
            isplay = NO;
            PlayViewController * playVC = [[PlayViewController alloc]init];
            __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
            playVC.playUrl = url;
            playVC.topName = self.webTitle;
            playVC.playStyle = playStyleTypeNormal;
            [self presentViewController:playVC animated:NO completion:nil];
        }else{
            [self.view gs_showTextHud:[NSString stringWithFormat:@"播放地址不正确～\n%@",self.searchView.searchTextField.text]];
        }
    }else{
        [self.view gs_showTextHud:@"播放地址不能为空～"];
    }
    
}
-(void)pushSearchVC{
    SearchViewController * searchVC = [[SearchViewController alloc]init];
    searchVC.delegate = self;
    [self presentViewController:searchVC animated:NO completion:nil];
}
-(void)push_HistoryVC{
    HistoryViewController * historyVC = [[HistoryViewController alloc]init];
    [self presentViewController:historyVC animated:NO completion:nil];
//    [self.navigationController pushViewController:historyVC animated:YES];
}
-(void)push_DownloadVC{
    DownloadViewController *downLoadVC = [[DownloadViewController alloc]init];
//    [self presentViewController:downLoadVC animated:YES completion:nil];
    [self.navigationController pushViewController:downLoadVC animated:YES];

}
-(void)push_BookmarkVC{
    BookmarkClickVC * bookVC = [[BookmarkClickVC alloc] init];
//    [self presentViewController:bookVC animated:YES completion:nil];
    [self.navigationController pushViewController:bookVC animated:YES];

}
-(void)push_QRCodeVC{
    QRCodeViewController * qrVC = [[QRCodeViewController alloc] init];
    qrVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
    qrVC.delegate = self;
    [self presentViewController:qrVC animated:YES completion:nil];

}
@end
