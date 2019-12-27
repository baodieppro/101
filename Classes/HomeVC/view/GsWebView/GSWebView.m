//
//  GSWebView.m
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//


#import "GSWebView.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif

#define IgnorePerformSelectorLeakWarning(code) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wnonnull\"") \
code \
_Pragma("clang diagnostic pop")

#define IgnoreSelectorWarning(code) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"--Wundeclared-selector\"") \
code \
_Pragma("clang diagnostic pop")


@interface GSWebViewConfiguration : WKWebViewConfiguration @end

@implementation GSWebViewConfiguration
    
- (instancetype)init
    {
        if (self = [super init]) {
            self.userContentController = [[WKUserContentController alloc] init];
            self.allowsInlineMediaPlayback = YES;
            //        self.allowsAirPlayForMediaPlayback = YES;
            //        self.mediaPlaybackRequiresUserAction = false;
            self.preferences.minimumFontSize = 10;
            //        WKProcessPool * process = [[WKProcessPool alloc]init];
            //        self.processPool = process;
            self.preferences.javaScriptCanOpenWindowsAutomatically = NO;
            
        }
        return self;
    }
    
    @end

/**********************************************************************************************************/


@interface GSWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIWebViewDelegate,SlideLeftOrRightDelegate>
    
    @property (nonatomic) BOOL canGoBack;
    @property (nonatomic) BOOL canGoForward;
    @property (nonatomic) BOOL isNavigator;
    @property (nonatomic) NSString * html;

    @end

@interface GSWebView (GSPrivateMethod)
    
    
- (void)excuteJavaScriptWithMethodName:(NSString *)name parameter:(id)param;
- (void)excuteFuncWithName:(NSString *)name;
    
    @end

@implementation GSWebView
    {
        NSPointerArray * _pointers;
        //    __strong UIView * _webView;
    }
-(void)wkgsDealloc{
    
    if ([_webView isKindOfClass:[WKWebView class]]) {
        [((WKWebView*)_webView).configuration.userContentController removeScriptMessageHandlerForName:@"jumpToUPloadStudy"];
        [((WKWebView*)_webView).configuration.userContentController removeScriptMessageHandlerForName:@"jumpToLink"];
        [((WKWebView*)_webView).configuration.userContentController removeScriptMessageHandlerForName:@"jumpToHome"];
        [((WKWebView*)_webView).configuration.userContentController removeScriptMessageHandlerForName:@"jumpToShoppingGoods"];
        [((WKWebView *)_webView) loadHTMLString:@"" baseURL:nil];
        [((WKWebView *)_webView) stopLoading];
        [((WKWebView *)_webView) removeFromSuperview];
        [((WKWebView *)_webView).configuration.userContentController removeAllUserScripts];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        ((WKWebView *)_webView).scrollView.delegate = nil;
        ((WKWebView *)_webView).UIDelegate = nil;
        ((WKWebView *)_webView).navigationDelegate = nil;
        //取消kvo注册
//        [((WKWebView *)_webView) removeObserver:self forKeyPath:@"estimatedProgress"];
        NSLog(@" wkWebView 释放啦");
//        [_progressView removeFromSuperview];
        [self deleteWebCache];
    }else if([_webView isKindOfClass:[UIWebView class]]){
        [self gsDealloc];
    }
}
- (void)dealloc
    {
        if ([_webView isKindOfClass:[WKWebView class]]) {
            [((WKWebView *)_webView) loadHTMLString:@"" baseURL:nil];
            [((WKWebView *)_webView) stopLoading];
            [((WKWebView *)_webView) removeFromSuperview];
            [((WKWebView *)_webView).configuration.userContentController removeAllUserScripts];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            ((WKWebView *)_webView).scrollView.delegate = nil;
            ((WKWebView *)_webView).UIDelegate = nil;
            ((WKWebView *)_webView).navigationDelegate = nil;
            [_progressView removeFromSuperview];
            //取消kvo注册
            [((WKWebView *)_webView) removeObserver:self forKeyPath:@"estimatedProgress"];
            NSLog(@" wkWebView 释放啦");
            [self deleteWebCache];
        }else if([_webView isKindOfClass:[UIWebView class]]){
            [self gsDealloc];
        }
    }
-(void)gsDealloc{
    NSLog(@" UIWebView 释放啦");
    if ([_webView isKindOfClass:[UIWebView class]]) {
        [((UIWebView *)_webView) loadHTMLString:@"" baseURL:nil];
        [((UIWebView *)_webView) stopLoading];
        [((WKWebView *)_webView) removeFromSuperview];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
          ((UIWebView *)_webView).delegate = nil;
//        [_progressView removeFromSuperview];
          [self deleteWebCache];
        //取消kvo注册
        [((UIWebView *)_webView) removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
    {
        IgnorePerformSelectorLeakWarning(return [self initWithFrame:frame JSPerformer:nil];)
    }
    
#pragma mark - 补充
-(void)removejsAllUserScripts{
        [((WKWebView *)_webView).configuration.userContentController removeAllUserScripts];
}
-(UIProgressView *)progressView{
        if (!_progressView) {
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0, __kScreenWidth__,2)];
            _progressView.tintColor =[UIColor colorWithHexString:__Web_ProgressColor__];
            _progressView.trackTintColor = [UIColor whiteColor];
            _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        }
    return _progressView;
    }
-(GSPanLoad *)pan{
    if (!_pan) {
        _pan = [[GSPanLoad alloc]initWithFrame:CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__)];
        _pan.slideDelegate =self;
        [_pan setPanGestureRecognizer:_webView];
    }
    return _pan;
}
#pragma  mark - 添加左划右划手势
    
-(BOOL)swipeIsClass{
    if (_webView.canGoBack == YES) {
        return YES;
        
    }else{
        return NO;
        
    }
    //    if (_webView.canGoForward == YES) {
    //        return NO;
    //    }else{
    //        return YES;
    //    }
}
    //-(void)swipePoint:(CGPoint)point pan:(UIPanGestureRecognizer *)pan{
    //    //    NSLog(@"point:%f",point.x);
    //    if ([self.delegate respondsToSelector:@selector(gsPoint:pan:)]) {
    //        [self.delegate gsPoint:point pan:pan];
    //    }
    //}
    //-(void)swipeLeft{
    //
    //}
    //-(void)swipeRight{
    //
    //}
    
    static long const kGSJSValueKey    = 1100;
    static long const kGSJSContextKey  = 1000;
    
- (JSContext *)jsContext
    {
        return objc_getAssociatedObject(self, &kGSJSContextKey);
    }
    
- (JSValue *)jsValue
    {
        return objc_getAssociatedObject(self, &kGSJSValueKey);
    }
-(void)layoutSubviews{
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}
- (instancetype)initWithFrame:(CGRect)frame JSPerformer:(nonnull id)performer
    {
        if (self = [super initWithFrame:frame]) {
            _pointers = [NSPointerArray weakObjectsPointerArray];
            [_pointers addPointer:(__bridge void * _Nullable)(performer)];
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
//                        [self configureUIWebViewWithFrame:frame];
            [self configureWKWebViewWithFrame:frame];
        }else{
            [self configureUIWebViewWithFrame:frame];
            
        }
        return self;
    }
- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}
    
- (void)loadURLString:(NSString *)URLString {
//    [self cookieStr:URLString];
    [self loadURL:[NSURL URLWithString:URLString]];
    
}
    
- (void)loadHTMLString:(NSString *)HTMLString {
    [self loadHTMLString:HTMLString baseURL:nil];
}
    
- (void)loadRequest:(NSURLRequest *)request
    {
        _request = request;
    
        if ([_webView isKindOfClass:[WKWebView class]])
        {
            [(WKWebView *)_webView loadRequest:request];
        }else{
            [(UIWebView *)_webView loadRequest:request];
        }
        
        
    }
    
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL
    {
        _html = string;
        if ([_webView isKindOfClass:[WKWebView class]]){
            [(WKWebView *)_webView loadHTMLString:string baseURL:baseURL];
        }else{
            [(UIWebView *)_webView loadHTMLString:string baseURL:baseURL];
            
        }
    }

-(void )cookieStr:(NSString *)url{

    NSString * cookieStr =[DEFAULTS objectForKey:@"GS_Cookie"];
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:cookieStr forKey:NSHTTPCookieValue];
    [properties setValue:@"base_api_session" forKey:NSHTTPCookieName];
    [properties setValue:[[NSURL URLWithString:url] host] forKey:NSHTTPCookieDomain];
    [properties setValue:[[NSURL URLWithString:url] path] forKey:NSHTTPCookiePath];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (id)performer
    {
        return [_pointers pointerAtIndex:0];
    }
    
- (void)excuteJavaScript:(NSString *)javaScriptString completionHandler:(void(^)(id params, NSError * error))completionHandler
    {
        if ([_webView isKindOfClass:[WKWebView class]]) {
            [(WKWebView *)_webView evaluateJavaScript:javaScriptString completionHandler:^(id param, NSError * error){
                if (completionHandler) {
                    completionHandler(param,error);
                }
            }];
        }else{
            JSValue * value = [self.jsContext evaluateScript:javaScriptString];
            if (value && completionHandler) {
                completionHandler([value toObject],NULL);
            }
        }
    }
    
- (void)setDataDetectorTypes:(GSDataDetectorTypes)dataDetectorTypes
    {
        if ([_webView isKindOfClass:[UIWebView class]]){
            ((UIWebView *)_webView).dataDetectorTypes = (UIDataDetectorTypes)dataDetectorTypes;
        }else{
            if ([((WKWebView *)_webView).configuration respondsToSelector:@selector(setDataDetectorTypes:)]) {
                [((WKWebView *)_webView).configuration setDataDetectorTypes:(WKDataDetectorTypes)dataDetectorTypes];
            }
        }
    }
    
    /***********************************************************************************************************************/
    
#pragma mark - UIWebViewDelegate
    
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
    {
        //开始加载网页时展示出progressView
        self.progressView.hidden = NO;
        //开始加载网页的时候将progressView的Height恢复为1.5倍
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//        NSString * url = [NSString stringWithFormat:@"%@",request.URL];
//        NSString *str = @"itunes";
        NSString * about = @"about";
        
        if ([request.URL.scheme isEqualToString:about]) {
            return NO;
        }
    
        return [self delegate:webView shouldStartLoadWithRequest:request navigationType:(GSWebViewNavigationType)navigationType];
    }
-(BOOL)delegate:(UIWebView *)web shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(GSWebViewNavigationType)navigationType
    {
        //back delegate
        if([GSTool newIsHttp:request.URL.scheme]){
            //        NSLog(@"是吗");
            
            return [self.delegate gswebView:self shouldStartLoadWithRequest:request navigationType:(GSWebViewNavigationType)navigationType];
        }else{
            //        NSLog(@"不是吗");
            return [GSTool newIsHttp: request.URL.scheme];
        }
    }
    
- (void)webViewDidStartLoad:(UIWebView *)webView
    {
   
        NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        if ([self.delegate respondsToSelector:@selector(gswebViewDidStartLoad:url:Title:)]) {
            [self.delegate gswebViewDidStartLoad:self url:webView.request.URL.absoluteString Title:title];
        }
    }
    
    static NSString * const kJavaScriptContext = @"documentView.webView.mainFrame.javaScriptContext";
    static NSString * const kDocumentTitle = @"document.title";
    
    static NSString * const kWebKitCacheModelPreferenceKey = @"WebKitCacheModelPreferenceKey";
    static NSString * const kWebKitDiskImageCacheEnabled = @"WebKitDiskImageCacheEnabled";
    static NSString * const kWebKitOfflineWebApplicationCacheEnabled = @"WebKitOfflineWebApplicationCacheEnabled";
    
- (void)cleanWebCacheValues
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kWebKitCacheModelPreferenceKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kWebKitDiskImageCacheEnabled];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kWebKitOfflineWebApplicationCacheEnabled];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
- (void)generateTitle
    {
        _title = [(UIWebView *)_webView stringByEvaluatingJavaScriptFromString:kDocumentTitle];
    }
    
- (void)bindingCtxAndValue
    {
        JSContext * JSCtx = [(UIWebView *)_webView valueForKeyPath:kJavaScriptContext];
        JSValue * JSVlu = [JSCtx globalObject];
        objc_setAssociatedObject(self, &kGSJSValueKey, JSVlu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self,&kGSJSContextKey, JSCtx, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
- (void)webViewDidFinishLoad:(UIWebView *)webView;
    {
        //加载完成后隐藏progressView
        self.progressView.hidden = YES;
        [self generateTitle];
        [self bindingCtxAndValue];
        [self cleanWebCacheValues];
        
        if([self.script respondsToSelector:@selector(gswebViewRegisterObjCMethodNameForJavaScriptInteraction)]){
            __weak typeof(self) weakSelf = self;
            [[self.script gswebViewRegisterObjCMethodNameForJavaScriptInteraction] enumerateObjectsUsingBlock:
             ^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
                 __strong typeof(weakSelf) strongSelf = weakSelf;
                 strongSelf.jsContext[name] = ^(id body){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [strongSelf excuteJavaScriptWithMethodName:name parameter:body];
                     });
                 };
             }];
        }
        
//        NSString * userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        //    NSLog(@"userAgent\n %@",userAgent);
     
        if (webView.canGoBack) {
            _pan.isHideLeft = YES;
        }else{
            _pan.isHideLeft = NO;
        }
        if (webView.canGoForward) {
            _pan.isHideRight = YES;
        }else{
            _pan.isHideRight = NO;
        }
        
        if ([self.delegate respondsToSelector:@selector(gswebViewDidFinishLoad:url:Title:)]) {
            [self.delegate gswebViewDidFinishLoad:self url:webView.request.URL.absoluteString Title:_title];
        }
        //    [_webProgressLayer finishedLoadWithError:nil];
        //    [_webProgressLayer closeTimer];
        //    [self deallocProgress];
    }
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
    {
        NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        //加载完成后隐藏progressView
        self.progressView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(gswebView:url:Title:didFailLoadWithError:)]) {
            [self.delegate gswebView:self url:webView.request.URL.absoluteString Title:title didFailLoadWithError:error];
        }
        //    [_webProgressLayer finishedLoadWithError:nil];
        //    [_webProgressLayer closeTimer];
        //    [self deallocProgress];
    }
    
- (double)estimatedProgress
    {
        return ((WKWebView *)_webView).estimatedProgress;
    }
    
    /************************************************************************************************************************/
    
#pragma mark - WKWebView
    
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
    {
        UIViewController * currentVC = [self getTopViewController];
        if (currentVC) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.pageAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                completionHandler();
            }]];
            [currentVC presentViewController:alert animated:YES completion:NULL];
        }
    }
    
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
    {
        UIViewController * currentVC = [self getTopViewController];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.pageConfirmTitle message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(YES);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }]];
        [currentVC presentViewController:alert animated:YES completion:NULL];
        
    }
    //异常网址 跳转
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
    {
        WKFrameInfo *frameInfo = navigationAction.targetFrame;
        if (![frameInfo isMainFrame]) {
            [webView loadRequest:navigationAction.request];
        }
        
        return nil;
    }
    // 在发送请求之前，决定是否跳转
    
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
    {
        __kWeakSelf__;
        
        if ([self.delegate respondsToSelector:@selector(gswebView:shouldStartLoadWithRequest:navigationType:)]) {
            
            switch (navigationAction.navigationType) {
                case WKNavigationTypeLinkActivated: {
                    [weakSelf setCallphone:navigationAction Complete:^{
                        weakSelf.isNavigator = YES;
                         weakSelf.isNavigator = [weakSelf.delegate gswebView:weakSelf shouldStartLoadWithRequest:navigationAction.request navigationType:(GSWebViewNavigationType)(navigationAction.navigationType < 0? navigationAction.navigationType : 5)];
                    } failed:^{
                         weakSelf.isNavigator = NO;
                    }];
                    break;
                }
                case WKNavigationTypeFormSubmitted: {
                    [weakSelf setCallphone:navigationAction Complete:^{
                         weakSelf.isNavigator = YES;
                         weakSelf.isNavigator = [weakSelf.delegate gswebView:weakSelf shouldStartLoadWithRequest:navigationAction.request navigationType:(GSWebViewNavigationType)(navigationAction.navigationType < 0? navigationAction.navigationType : 5)];
                    } failed:^{
                         weakSelf.isNavigator = NO;
                    }];
                    break;
                }
                case WKNavigationTypeBackForward: {
                    
                    if ([weakSelf.delegate respondsToSelector:@selector(gsWKNavigationTypeBackForward)]) {
                        [weakSelf.delegate gsWKNavigationTypeBackForward];
                    }
                     weakSelf.isNavigator = YES;
                    break;
                    //            }
                }
                case WKNavigationTypeReload: {
                     weakSelf.isNavigator = YES;
                    break;
                }
                case WKNavigationTypeFormResubmitted: {
                     weakSelf.isNavigator = YES;
                    break;
                }
                case WKNavigationTypeOther: {
                    [weakSelf setCallphone:navigationAction Complete:^{
                         weakSelf.isNavigator = YES;
                         weakSelf.isNavigator = [weakSelf.delegate gswebView:weakSelf shouldStartLoadWithRequest:navigationAction.request navigationType:(GSWebViewNavigationType)(navigationAction.navigationType < 0? navigationAction.navigationType : 5)];
                    } failed:^{
                         weakSelf.isNavigator = NO;
                    }];
                    break;
                }
                default: {
                    break;
                }
            }
            
            
        }
        if (!weakSelf.isNavigator) {
            decisionHandler(WKNavigationActionPolicyCancel);
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
#pragma mark - 是否返回或者前进
    
-(BOOL)setReturnWkWeb:(WKWebView *)webView{
    
    if ([[GSStaticModel newModel].goIsBack isEqualToString:@"1"])
    {
        if ([webView.backForwardList.backItem.title isEqualToString:@""] || webView.backForwardList.backItem.title == nil)
        {
            //            webView.canGoBack = NO;
            return NO;
        }else{
            return YES;
        }
        
    }
    else if ([[GSStaticModel newModel].goIsBack isEqualToString:@"0"])
    {
        if ([webView.backForwardList.forwardItem.title isEqualToString:@""] || webView.backForwardList.forwardItem.title == nil) {
            //            webView.canGoForward = NO;
            return NO;
        }else{
            return YES;
        }
        
    }
    
    
    return NO;
}
    
#pragma mark - 添加功能
    
-(void)setCallphone:(WKNavigationAction *)navigationAction Complete:(void (^)())complete failed:(void (^)())failed{
    //    NSLog(@"push with request %@",navigationAction.request);
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString * urlStr = [URL absoluteString];
    GSLog(@"web_request: %@",urlStr);
    //    UIApplication *app = [UIApplication sharedApplication];
//    if([[URL absoluteString] containsString:@"https://open.weixin.qq.com"]){
//        failed();
//        return;
//    }
    //爱奇艺视频详情抓取
    if([urlStr containsString:@"/v_"]){
       
        if (![urlStr containsString:@"?uback=1"]) {
            NSString * loadUrl = [urlStr stringByAppendingString:@"?uback=1"];
            [self stopLoading];
            [self loadURLString:loadUrl];
            failed();
        }else{
            complete();
        }
       
        return ;
    }
    
    if ([scheme isEqualToString:@"iqiyi"]) {
        failed();
        return;
    }
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        // 这种拨打电话的写法，真机可显示效果，模拟器不显示
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [self newOpenURL:[NSURL URLWithString:callPhone]];
        complete();
        return ;
    }
    
    // 打开appstore
    if ([URL.absoluteString containsString:@"itunes.apple.com"]) {
//        complete();
            [self newOpenURL:URL];
            return;
        
        }
    if (_html == nil) {
        if([GSTool newisHttpOrHttps:URL.absoluteString] == NO){
            failed();
            return;
        }
        if ([URL.absoluteString isEqualToString:@"about:blank"]) {
            failed();
            return;
        }
    }
    complete();
}

    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
    {
        //开始加载网页时展示出progressView
        self.progressView.hidden = NO;
        //开始加载网页的时候将progressView的Height恢复为1.5倍
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        //防止progressView被网页挡住
        [self bringSubviewToFront:self.progressView];
        if ([self.delegate respondsToSelector:@selector(gswebViewDidStartLoad:url:Title:)]) {
            [self.delegate gswebViewDidStartLoad:self url:webView.URL.absoluteString Title:webView.title];
        }
        
    }
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
    
    
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
    {
        //加载完成后隐藏progressView
            self.progressView.hidden = YES;
        
        _title = webView.title;
        if (self.delegate && [self.script respondsToSelector:@selector(gswebViewRegisterObjCMethodNameForJavaScriptInteraction)]) {
            __weak typeof(self) weakSelf = self;
            [[self.script gswebViewRegisterObjCMethodNameForJavaScriptInteraction] enumerateObjectsUsingBlock:
             ^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
                 __strong typeof(weakSelf) strongSelf = weakSelf;
                 [webView.configuration.userContentController removeScriptMessageHandlerForName:name];
                 [webView.configuration.userContentController addScriptMessageHandler:strongSelf name:name];
             }];
        }
        if ([self.delegate respondsToSelector:@selector(gswebViewDidFinishLoad:url:Title:)]){
            [self.delegate gswebViewDidFinishLoad:self url:webView.URL.absoluteString Title:webView.title];
        }

//        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
//            NSLog(@"userAgent :%@", result);
//        }];
    }
    
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
    {
        //加载失败同样需要隐藏progressView
        self.progressView.hidden = YES;

    }
    // 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //    NSLog(@"页面加载超时");
    if ([self.delegate respondsToSelector:@selector(gswebView:url:Title:didFailLoadWithError:)]) {
        [self.delegate gswebView:self url:webView.URL.absoluteString Title:webView.title didFailLoadWithError:error];
    }
    
}
    //进程被终止时调用
    
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    //    NSLog(@"WKWebView 进程被终止时调用");
}
    //关闭webView时调用的方法
-(void)webViewDidClose:(WKWebView *)webView{
    //    NSLog(@"WKWebView 关闭webView时调用的方法");
    
}
    
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
    {
        [self excuteJavaScriptWithMethodName:message.name parameter:message.body];
    }
    
    /*
     *4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
     */
    
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%.2f,",self.webView.estimatedProgress);
        _progressView.progress = self.webView.estimatedProgress;
        if (_progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(id)valueForUndefinedKey:(NSString *)key{
    
    return nil;
    
}
#pragma mark -OpenUrl

-(void)newOpenURL:(NSURL *)url
{
    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
    
#pragma mark -creatUI
    
- (void)configureWKWebViewWithFrame:(CGRect)frame
    {
        
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        WKUserContentController* userContentController =[[WKUserContentController alloc]init];
        
        configuration.userContentController = userContentController;
        //    [configuration.userContentController addScriptMessageHandler:self name:@"getPasstheValueIDFA"];
        configuration.allowsInlineMediaPlayback = YES;
        //        self.allowsAirPlayForMediaPlayback = YES;
        //    configuration.preferences.minimumFontSize = 10;
        configuration.preferences.minimumFontSize = 9.0;
        WKProcessPool * process = [[WKProcessPool alloc]init];
        configuration.processPool = process;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.selectionGranularity = WKSelectionGranularityCharacter;
        //    //真机无声音解决方案
        //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //    BOOL ok;
        //    NSError *setCategoryError = nil;
        //    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        //    if (!ok) {
        //        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
        //    }
        
        
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0)
        {
            configuration.mediaPlaybackRequiresUserAction = NO;
            configuration.requiresUserActionForMediaPlayback = NO;
            configuration.applicationNameForUserAgent = [IphoneType defaultUserAgentString];
        }else{
            
            
        }
        
        WKWebView * web = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        web.UIDelegate = self;
        web.navigationDelegate = self;
        web.allowsBackForwardNavigationGestures = YES;
        web.opaque = false;
        _scrollView = web.scrollView;
        _webView = (GSWebView *)web;
        
        [self addSubview:_webView];
        [self addSubview:self.progressView];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
      
        
    }

    
- (void)configureUIWebViewWithFrame:(CGRect)frame
    {
        UIWebView * web = [[UIWebView alloc] initWithFrame:frame];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
        [NSClassFromString(@"WebCache") performSelector:@selector(setDisabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:0];
#pragma clang diagnostic pop
        web.delegate = self;
        _scrollView = web.scrollView;
        _webView = (GSWebView *)web;
        [self addSubview:_webView];
        [self addSubview:self.progressView];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        //真机无声音解决方案
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        BOOL ok;
        NSError *setCategoryError = nil;
        ok = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (!ok) {
            NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
        }
        
    }
    
- (UIViewController *)getTopViewController
    {
//        UIWindow * window;
//        if (@available(iOS 13.0, *)) {
//            window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//        }else{
//            window = [UIApplication sharedApplication].keyWindow;
//        }
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * win in windows) {
                if (win.windowLevel == UIWindowLevelNormal) {
                    window = win;
                    break;
                }
            }
        }
        UIView *frontView = [[window subviews] firstObject];
        id nextResponder = [frontView nextResponder];
        UIViewController * top = nil;
        if ([nextResponder isKindOfClass:[UIViewController class]])
        top = nextResponder;
        else
        top = window.rootViewController;
        return top;
    }

- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
@end

#pragma mark - Navigation

@implementation GSWebView (Navigation)
    
#pragma  mark - 添加左划右划手势
-(void)swipePoint:(CGPoint)point pan:(UIPanGestureRecognizer *)pan{
    //    NSLog(@"point:%f",point.x);
    //    if ([self.delegate respondsToSelector:@selector(gsPoint:pan:)]) {
    //        [self.delegate gsPoint:point pan:pan];
    //    }
}
-(void)swipeRight{
    [self GSGoForward];
}
    
-(void)swipeLeft{
    
    [self GSGoBack];
}
-(void)GSGoBack{
    //    NSLog(@"后退");
    if (self.canGoBack) {
        [self goBack];
    }
}
-(void)GSGoForward{
    // NSLog(@"前进");
    if (self.canGoForward) {
        [self goForward];
    }
}
-(void)GSStopLoaging{
    [self stopLoading];
    //    [_webProgressLayer finishedLoadWithError:nil];
    //    [self deallocProgress];
}
-(void)GSRelod{
    //    NSLog(@"刷新");
    //    [_webProgressLayer finishedLoadWithError:nil];
    //    [self deallocProgress];
    [self reload];
    //    [self.webProgressLayer startLoad];
    
}
    
    
- (BOOL)isLoading
    {
        if ([_webView isKindOfClass:[UIWebView class]])
        return [((UIWebView *)_webView) isLoading];
        return [((WKWebView *)_webView) isLoading];
    }
    
- (BOOL)canGoBack
    {
        if ([_webView isKindOfClass:[UIWebView class]])
        return [((UIWebView *)_webView) canGoBack];
        return [((WKWebView *)_webView) canGoBack];
    }
    
- (BOOL)canGoForward
    {
        if ([_webView isKindOfClass:[UIWebView class]])
        return [((UIWebView *)_webView) canGoForward];
        return [((WKWebView *)_webView) canGoForward];
    }
    
    
#define ExcuteMethodWith(name) \
[self excuteFuncWithName:name]
    
- (void)reload
    {
        ExcuteMethodWith(@"reload");
        
    }
    
- (void)stopLoading
    {
        ExcuteMethodWith(@"stopLoading");
        
    }
    
- (void)goBack
    {
        ExcuteMethodWith(@"goBack");
    }
    
- (void)goForward
    {
        ExcuteMethodWith(@"goForward");
    }
    
    @end

#pragma mark - GSPrivateMethod

@implementation GSWebView (GSPrivateMethod)
    
    typedef void (*GSFunctionPointWithParam)(id, SEL, id);
    typedef void (*GSFunctionPointNoParam)(id, SEL);
    
- (void)excuteJavaScriptWithMethodName:(NSString *)name parameter:(id)param
    {
        if (self.performer) {
            SEL selector;
            if ([param isKindOfClass:[NSString class]] && [param isEqualToString:@""])
            selector = NSSelectorFromString(name);
            else
            selector = NSSelectorFromString([name stringByAppendingString:@":"]);
            
            if ([self.performer respondsToSelector:selector]){
                IMP imp = [self.performer methodForSelector:selector];
                if (param){
                    GSFunctionPointWithParam f = (void *)imp;
                    f(self.performer, selector,param);
                }
                else{
                    GSFunctionPointNoParam f = (void *)imp;
                    f(self.performer, selector);
                }
            }
        }
    }
    
- (void)excuteFuncWithName:(NSString *)name
    {
        __kWeakSelf__;
        SEL selector = NSSelectorFromString(name);
        if ([_webView respondsToSelector:selector]) {
            dispatch_block_t block = ^(void){
                IMP imp = [weakSelf.webView methodForSelector:selector];
                GSFunctionPointNoParam pfunc = (void *)imp;
                pfunc(weakSelf.webView, selector);
            };
            if ([[NSThread currentThread] isMainThread]) {
                block();
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        }
    }


@end
