//
//  WebViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
#define __Def_Url__ @"http://m.zjmao.com/"
#import "NSString+m3u8.h"
#import "NSString+SKYExtension.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "HistoryViewController.h"
#import "DownloadViewController.h"
#import "BookmarkClickVC.h"
#import "PlayViewController.h"
#import "QRCodeViewController.h"
#import "SetViewController.h"

#import "GSWeb.h"
#import "SearchView.h"
#import "NSURLProtocol+WKWebVIew.h"
#import "HybridNSURLProtocol.h"
#import "WebBottomView.h"
#import "ToolsMenuView.h"
#import "LSPlayerView.h"
#import "GSTextLoading.h"

@interface WebViewController ()
<
GSWebViewDelegate,
GSWebViewJavaScript,
UIScrollViewDelegate,
UITextFieldDelegate,
MyWebBottomViewDelegate,
MySearchViewControllerDelegate,
MyToolsMenuViewDelegate,
QRDelegate,
MyHistoryViewControllerDelegate,
MyBookmarkVCDelegate,
MyLSPlayerViewDelegate
>
{
    BOOL isplay;
    BOOL isFavorite;
    CGFloat lastContentOffset;
    BOOL isFullScreen;

}
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic,strong) UIButton * refreshBtn;//!<刷新按钮
@property (nonatomic,strong) UIButton * downLoadBtn;//!<下载按钮

@property (nonatomic,strong) GSWebView * webView;
@property (nonatomic,strong) NSString * webTitle;
@property (nonatomic,strong) NSString * webUrl;
@property (nonatomic,strong) NSString * playUrl;
@property (nonatomic,assign) BOOL isHiddenTopBar;
@property (nonatomic,strong) LSPlayerView* playerView ;
@property (nonatomic,assign) BOOL isplayView;//!<是否展示playView

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
     [[NSNotificationCenter defaultCenter] removeObserver:self name:NEED_PUSH_Pasteboard_NOTIFICATION object:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//
//    [self prefersStatusBarHidden];
//
//    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//
//    }
     //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteboardNotification:) name:NEED_PUSH_Pasteboard_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCaptureM3U8Notification:) name:NEED_M3U8_Capture_NOTIFICATION object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_CreateUI];
    [self g_LayoutFrame];
    [self g_loadUrl];
}
- (void)g_init{
      NSString *rootPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"GSDownLoad"];
    GSLog(@"%@",rootPath);
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    if (kStringIsEmpty(self.url)) {
        self.url = [BookMarkManager readDefUrl]?:__Def_Url__;
    }
    isplay = NO;
    self.isHiddenTopBar = NO;
    self.isplayView = NO;
}
-(void)g_CreateUI{
    [self.myView addSubview:self.webView];
    [self.myView addSubview:self.searchView];
    [self.searchView addSubview:self.refreshBtn];
    [self.myView addSubview:self.bottomView];
    [self.myView addSubview:self.downLoadBtn];
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
    [_downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-__kNewSize(30));
        make.right.mas_equalTo(self.myView.mas_right).mas_offset(-__kNewSize(20));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(100), __kNewSize(100)));
    }];
    
}
-(void)g_loadUrl{
    //保留最后打开的页面
    if ([__isRecord__ isEqualToString:@"1"]) {
        self.url = [DEFAULTS objectForKey:@"Record_Url"];
        [self.webView loadURLString:[GSTool urlWithIsUrl:self.url]];
    }else{
        if (!kStringIsEmpty(self.url)) {
            [self.webView loadURLString:[GSTool urlWithIsUrl:self.url]];
        }
        if (!kStringIsEmpty(self.html)) {
            [self.webView loadHTMLString:self.html];
        }
    }

//    self.url = @"https://quark.sm.cn/s";
//    [self.webView loadURLString:self.url];
//    [IphoneType newOpenURL:[NSURL URLWithString:self.url]];
}
#pragma mark - UI
-(SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(__kNewSize(20), 0, __kScreenWidth__-__kNewSize(40), __kNavigationBarHeight__)];
        _searchView.searchTextField.delegate = self;
        _searchView.searchTextField.clearButtonMode = UITextFieldViewModeNever;
        [_searchView.videoBtn addTarget:self action:@selector(playVideoClick) forControlEvents:UIControlEventTouchUpInside];
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
-(UIButton *)downLoadBtn{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn setImage:[UIImage imageNamed:@"xiazai_guanli"] forState:UIControlStateNormal];
//        [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
//        [_downLoadBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _downLoadBtn.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
//        _downLoadBtn.titleEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
//        UIImage *image = [UIImage imageNamed:@"tool_bird_3"];
//        UIImageView *iconView = [[UIImageView alloc]initWithImage:image];
//        iconView.frame = CGRectMake(__kNewSize(10), __kNewSize((120-30)/2), __kNewSize(30), __kNewSize(30));
//        [_downLoadBtn addSubview:iconView];
        _downLoadBtn.layer.masksToBounds = YES;
        _downLoadBtn.layer.cornerRadius = __kNewSize(100/2);
        _downLoadBtn.layer.borderWidth = __kNewSize(1);
        CGColorRef colorref = [UIColor colorWithHexString:@"#ffffff"].CGColor;
        [_downLoadBtn.layer setBorderColor:colorref];
        _downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(24)];
        _downLoadBtn.hidden = YES;
        [_downLoadBtn addTarget:self action:@selector(downLoadPlayVideoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}
-(LSPlayerView *)playerView{
    if (!_playerView) {
        LSPlayerView* playerView = [LSPlayerView playerView];
        playerView.index=0;
        playerView.delegate = self;
        //playerView.currentFrame=CGRectMake(0, 64, __kScreenWidth__, __KSize(340));
        //必须先设置tempSuperView在设置videoURL
        playerView.tempSuperView= [UIApplication sharedApplication].delegate.window;
        __kWeakSelf__
        playerView.backBlock = ^{
            weakSelf.isplayView = NO;
        };
        _playerView = playerView;
    }
    return _playerView;
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
-(NSString *)cicId{
    return [NSString stringWithFormat:@"%ld",[HistoryData allCount]];
}
#pragma mark - BookMarkDelegate
-(void)myBookmarkVCRloadViewWithUrl:(NSString *)url{
    [self.webView stopLoading];
    [self.webView loadURLString:[GSTool urlWithIsUrl:url]];
}
#pragma mark - historyDelegate
-(void)myHistoryRloadViewWithUrl:(NSString *)url{
    [self.webView stopLoading];
    [self.webView loadURLString:[GSTool urlWithIsUrl:url]];
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
#pragma mark - MyLSPlayerViewDelegate
-(void)myPrefersStatusBarHidden:(BOOL)isHidden{
    self.isHiddenTopBar = isHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:NO];
    [self prefersStatusBarHidden];

}
- (BOOL)prefersStatusBarHidden
{

return self.isHiddenTopBar;

}
#pragma mark - 捕获M3U8通知
-(void)pasteboardNotification:(NSNotification *)notification{
    GSLog(@"收到剪切板通知：%@",notification.object);
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:notification.object];
    NSString * url = [dict objectForKey:@"url"];
    if (!kStringIsEmpty(url)) {
    isplay = [self playWithUrl:url];
        if(isplay == YES){
            __kWeakSelf__;
            [[GSLAlertView alertManager] createInitWithTitle:@"是否播放视频" message:self.playUrl sureBtn:@"确定" cancleBtn:@"取消"];
            [GSLAlertView alertManager].resultIndex = ^(NSInteger index) {
                switch (index) {
                    case 1:
                    {
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = @"";
                    }
                        break;
                    case 2:
                    {
                        [weakSelf playVideoClick];
                    }
                        break;
                    default:
                        break;
                }
            };
            [[GSLAlertView alertManager] showGSAlertView];
        }else{
            [[GSLAlertView alertManager] createInitWithTitle:@"是否访问地址" message:url sureBtn:@"确定" cancleBtn:@"取消"];
            [GSLAlertView alertManager].resultIndex = ^(NSInteger index) {
                switch (index) {
                    case 1:
                    {
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = @"";
                    }
                        break;
                    case 2:
                    {
                        [self.webView loadURLString:url];
                    }
                        break;
                    default:
                        break;
                }
            };
            [[GSLAlertView alertManager] showGSAlertView];
        }
    }
//     [self pushPlayVC_Url:url];
}
-(void)setCaptureM3U8Notification:(NSNotification *)notification{
    GSLog(@"接收到捕获M3U8通知%@",notification);
    NSDictionary * dict = (NSDictionary *)notification.object;
    NSString * url = [dict objectForKey:@"play"];
    isplay = [self playWithUrl:url];

}
//捕获视频播放地址
-(BOOL)playWithUrl:(NSString *)url{
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
                    self.downLoadBtn.hidden = NO;
                    [_searchView playVideoButtonIs:YES];
                   return  YES;
                }
            }else{
                GSLog(@"后缀是.m3u8,但捕获规则未加\n%@",url);
                self.playUrl = url;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主线程执行
                    self.downLoadBtn.hidden = NO;
                    [self.searchView playVideoButtonIs:YES];
                });
              
                return  YES;
            }
        }
        else
        {
            GSLog(@"包含有m3u8的url，但后缀不是.m3u8\n%@",url);
        }
        
    }
    self.playUrl = @"";
    self.downLoadBtn.hidden = YES;
    [_searchView playVideoButtonIs:NO];
    return NO;
}

#pragma mark -GSWebViewDelegate
- (BOOL)gswebView:(GSWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(GSWebViewNavigationType)navigationType
{
    GSLog(@"页面请求加载 %@ ",[request.URL absoluteString] );
    isplay = [self playWithUrl:[request.URL absoluteString]];
    
    return YES;
}
-(void)gswebViewDidStartLoad:(GSWebView *)webView url:(nonnull NSString *)url Title:(nonnull NSString *)title{
    GSLog(@"页面开始加载 %@  %@ ",url ,title);
    if (!kStringIsEmpty(url)) {
        self.webUrl = url;
        self.webTitle = title;
        self.searchView.searchTextField.text = url;
        [ToolscreenShot screenShot].qrCodeStr = self.webUrl ;
        [self refreshBackImage:NO];
        if(isplay == YES){
            isplay = [self playWithUrl:url];
        }
    }
    [[GSTextLoading loadingManager] startLoading];
//    [GSTextLoading showGSLoadingView:webView];
}
-(void)gswebViewDidFinishLoad:(GSWebView *)webView url:(nonnull NSString *)url Title:(nonnull NSString *)title{
    //    __kWeakSelf__;
    GSLog(@"页面加载完成  %@  %@ ",url ,title);
    [self refreshBackImage:YES];
    if (!kStringIsEmpty(title)) {

        if ([url containsString:@"play/"]&&[url containsString:@".html"])
        {
            self.webTitle = [NSString stringWithFormat:@"%@%@",title,[url subStringFrom:@"play/" to:@".html"]];
        }
        else if ([url containsString:@"movie/"]&&[url containsString:@".html"])
        {
            self.webTitle = [NSString stringWithFormat:@"%@%@",title,[url subStringFrom:@"movie/" to:@".html"]];
        }else {
            self.webTitle = title;
        }
        self.searchView.searchTextField.text = title;
        self.webUrl = url;
        [ToolscreenShot screenShot].qrCodeStr = self.webUrl ;
//        [HistoryModel addCacheName:WEB_History_Cache title:title url:url arr:self.historyDataList];
       [self displayNoneAd:url];

        [[ToolsMenuView menu] isFavorite:[BookMarkManager isExistAppForUrl:self.webUrl]];
    }
    if(![self.url isEqualToString:url]){
        //无痕浏览
        if ([__isTrace__ isEqualToString:@"0"]) {
            //历史记录
               dispatch_async(dispatch_get_main_queue(), ^
                  {
                      NSDictionary * dict = @{@"url":url,@"title":title,@"historyId":@"1"};
                      [HistoryData addHistoryData:dict];
                  });
        }

    }
   if(isplay == YES){
       if (self.isplayView == YES) {
            [self playVideo:self.playUrl];
       }
   }
    //保留最后一次浏览的Url
    if([__isRecord__ isEqualToString:@"1"]){
        [DEFAULTS setObject:self.webUrl forKey:@"Record_Url"];
        [DEFAULTS synchronize];
    }
    [[GSTextLoading loadingManager] stopLoading];
//    [GSTextLoading reomveGSLoadingView:webView];
}

-(void)gswebView:(GSWebView *)webView url:(nonnull NSString *)url Title:(nonnull NSString *)title didFailLoadWithError:(nonnull NSError *)error{
    //    [STCModel stcModel].netWorkNEW = 0;
    GSLog(@"页面加载失败  %@  %@ ",url ,title);
    if (!kStringIsEmpty(url)) {
        self.searchView.searchTextField.text = url;
    }
    [self refreshBackImage:YES];
    [[GSTextLoading loadingManager] stopLoading];
//    [GSTextLoading reomveGSLoadingView:webView];

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
    if([url rangeOfString:@"yilongtv.com"].location != NSNotFound)
    {
        NSString * isNone2 = @"document.getElementById('a_wrap').style.display = 'none'";
        [_webView excuteJavaScript:isNone2 completionHandler:^(id  _Nonnull params, NSError * _Nonnull error) {
            GSLog(@"params :%@\nerror :%@",params,error);
        }];
    }
    
}
-(void)stopVideoHtmlJavaScript{
    NSString * downPalay = [NSString stringWithFormat:@"document.getElementsByTagName('video')[0].pause()"];
    [_webView excuteJavaScript:downPalay completionHandler:^(id  _Nonnull params, NSError * _Nonnull error) {
        if (error) {
            GSLog(@"注入JS方法shouldUseLatestWebView出错：%@",[error localizedDescription]);
        }else{
            GSLog(@"注入JS方法shouldUseLatestWebView成功");
        }
    }];
    
}
#pragma mark - scrollView代理
//实现scrollView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//全局变量记录滑动前的contentOffset
   lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([__isFullScreen__ isEqualToString:@"1"]){
         if (scrollView.contentOffset.y < lastContentOffset ){
            //向上
            NSLog(@"上滑");
             if (isFullScreen == NO) {
                 _searchView.hidden = isFullScreen;
                 _bottomView.hidden = isFullScreen;
                 [_webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.top.left.bottom.right.mas_equalTo(self.myView).insets(UIEdgeInsetsMake(__kNavigationBarHeight__, 0, __kTabBarHeight__, 0));
                 }];
                 isFullScreen = YES;
             }
        } else if (scrollView.contentOffset.y > lastContentOffset ){
            //向下
            NSLog(@"下滑");
            if (isFullScreen == YES) {
                _searchView.hidden = isFullScreen;
                _bottomView.hidden = isFullScreen;
                [_webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.right.mas_equalTo(self.myView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                isFullScreen = NO;
            }
        }
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
-(void)playVideoClick{
    [self playVideo:self.playUrl];
//    [self pushPlayVC_Url:self.playUrl];
}
-(void)downLoadPlayVideoClick{
    [self.myView gs_showTextHud:[NSString stringWithFormat:@"准备下载 - %@",self.webTitle]];

    if ([DownloadDataManager isExistAppForTitle:self.webTitle] == YES) {
        //已经下载过了
        [self.myView gs_showTextHud:[NSString stringWithFormat:@"已经下载过了 - %@",self.webTitle]];

    }else{
        //还没有下载过
        [DownLoadManager start:self.playUrl Name:self.webTitle errorBlock:^(NSError * _Nullable error) {
            [self.myView gs_showTextHud:[NSString stringWithFormat:@"下载失败 \n %@",self.webTitle]];

        } progressBlock:^(CGFloat progress) {
            
        }];
        [self.myView gs_showTextHud:[NSString stringWithFormat:@"下载中 \n %@",self.webTitle]];
    }
   

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
            [self.webView loadURLString:[BookMarkManager readDefUrl]?:__Def_Url__];
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
        case 7:
        {
            GSLog(@"复制播放地址");
            NSString * msg ;
            if (!kStringIsEmpty(self.playUrl)) {
                msg = self.playUrl;
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = msg;
            }else{
                msg = self.webUrl;
            }
            [[GSLAlertView alertManager] createInitWithTitle:@"复制成功" message:msg sureBtn:@"知道了" cancleBtn:nil];
            [[GSLAlertView alertManager] showGSAlertView];
        }
            break;
        case 888:
        {
           GSLog(@"分享");
            [self shareShow];
        }
            break;
        case 999:
        {
            GSLog(@"设置");
            [self push_SetVC];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 分享
- (void)shareShow{
    __kAppDelegate__.allowRotation = NO;//关闭横屏仅允许竖屏
    UIImage * img = [UIImage snapshotScreenInView:self.view rect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage * image = [UIImage addImage:[GSQRCodeTool SG_generateWithLogoQRCodeData:self.webUrl logoImageName:@"" logoScaleToSuperView:2.0] toImage:img];
    NSArray * arr = @[image];
    [ShareTool shareWithItem:arr MySelf:self completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed) {
        GSLog(@"activityType %@",activityType);
        if (completed == YES) {
            GSLog(@"分享成功");
        }else{
            GSLog(@"取消分享");
        }
    }];

}
#pragma mark - push
-(void)pushPlayVC_Url:(NSString *)url{
    PlayViewController * playVC = [[PlayViewController alloc]init];
    __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
    if (!kStringIsEmpty(url)) {
        if([[url pathExtension] isEqualToString:@"m3u8"]||
           [[url pathExtension] isEqualToString:@"mp4"]
           ){
            isplay = NO;
            playVC.playUrl = url;
            playVC.topName = self.webTitle;
            playVC.playStyle = playStyleTypeNormal;
            [self presentViewController:playVC animated:NO completion:nil];
        }else{
            [self.view gs_showTextHud:[NSString stringWithFormat:@"播放地址不正确～\n%@",self.searchView.searchTextField.text]];
        }
    }else{
        playVC.playStyle = playStyleTypeHistory;
        if (iPhoneX_New == NO) {
            self.definesPresentationContext = YES;
            //设置模态视图弹出样式
            playVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:playVC animated:NO completion:nil];
        }else{
            [self.navigationController pushViewController:playVC animated:NO];
        }

    }
    
}
-(void)pushSearchVC{
    SearchViewController * searchVC = [[SearchViewController alloc]init];
    searchVC.delegate = self;
    self.definesPresentationContext = YES;
    //设置模态视图弹出样式
    searchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:searchVC animated:NO completion:nil];
}
-(void)push_HistoryVC{
    HistoryViewController * historyVC = [[HistoryViewController alloc]init];
    historyVC.delegate = self;
//    self.definesPresentationContext = YES;
//    //设置模态视图弹出样式
//    historyVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:historyVC animated:NO completion:nil];
    [self.navigationController pushViewController:historyVC animated:YES];
}
-(void)push_DownloadVC{
    DownloadViewController *downLoadVC = [[DownloadViewController alloc]init];
//    [self presentViewController:downLoadVC animated:YES completion:nil];
    [self.navigationController pushViewController:downLoadVC animated:YES];

}
-(void)push_BookmarkVC{
    BookmarkClickVC * bookVC = [[BookmarkClickVC alloc] init];
    bookVC.delegate = self;
    [self.navigationController pushViewController:bookVC animated:YES];
}
-(void)push_SetVC{
    SetViewController * pushVC = [[SetViewController alloc] init];
//    pushVC.delegate = self;
    [self.navigationController pushViewController:pushVC animated:YES];

}
-(void)push_QRCodeVC{
    QRCodeViewController * qrVC = [[QRCodeViewController alloc] init];
    qrVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
    qrVC.delegate = self;
    self.definesPresentationContext = YES;
    //设置模态视图弹出样式
    qrVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:qrVC animated:YES completion:nil];

}
#pragma mark - 自定义播放器
-(void)playVideo:(NSString *)url{
    if ([__isTrace__ isEqualToString:@"0"]) {
        [PlayManager addPlayData:@{@"title":self.webTitle,@"url":self.playUrl}];
    }
    [self stopVideoHtmlJavaScript];
    self.playerView.videoURL=url;
    self.isplayView = YES;

}

@end
