//
//  HybridNSURLProtocol.m
//  WKWebVIewHybridDemo
//
//  Created by shuoyu liu on 2017/1/16.
//  Copyright © 2017年 shuoyu liu. All rights reserved.
//

#import "HybridNSURLProtocol.h"
#import <UIKit/UIKit.h>
static NSString*const sourUrl  = @"https://m.baidu.com/static/index/plus/plus_logo.png";
static NSString*const sourIconUrl  = @"http://m.baidu.com/static/search/baiduapp_icon.png";
static NSString*const localUrl = @"http://mecrm.qa.medlinker.net/public/image?id=57026794&certType=workCertPicUrl&time=1484625241";

static NSString* const KHybridNSURLProtocolHKey = @"KHybridNSURLProtocol";
@interface HybridNSURLProtocol ()<NSURLSessionDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;

@end


@implementation HybridNSURLProtocol
//捕获视频播放地址
+(void)playWithUrl:(NSString *)url{
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
                if (!kStringIsEmpty(array[1])) {
                    [self postNotificationObject:@{@"play":array[1]}];
                }
            }else{
                GSLog(@"后缀是.m3u8,但捕获规则未加\n%@",url);
                [self postNotificationObject:@{@"play":url}];
            }
        }
        else
        {
            GSLog(@"包含有m3u8的url，但后缀不是.m3u8\n%@",url);
        }
        
    }
}
+(void)postNotificationObject:(NSDictionary *)dict{
     [[NSNotificationCenter defaultCenter] postNotificationName:NEED_M3U8_Capture_NOTIFICATION object:dict];
}
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
   
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
         [self playWithUrl:request.URL.absoluteString];
        if ([NSURLProtocol propertyForKey:KHybridNSURLProtocolHKey inRequest:request])
            return NO;
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    
    //request截取重定向
    if ([request.URL.absoluteString isEqualToString:sourUrl])
    {
        NSURL* url1 = [NSURL URLWithString:localUrl];
        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
    }
    
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:KHybridNSURLProtocolHKey inRequest:mutableReqeust];
      NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
//    if ([mutableReqeust.URL.absoluteString containsString:@"http://msg.qy.net"]) {
//        NSArray *array;
//        if ([mutableReqeust.URL.absoluteString containsString:@"qtcurl="]){
//            array = [mutableReqeust.URL.absoluteString componentsSeparatedByString:@"qtcurl="];
//        }
//        //判断是否捕获到地址
//        if (array.count >= 2) {
//            GSLog(@"捕获奇艺VIP地址：%@",array[1]);
//            NSString * strUrl = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSString * strUrl1  = [NSString stringWithFormat:@"http://jx.618g.com/?url=%@",strUrl];
//            GSLog(@"转译奇艺VIP地址：%@",strUrl1);
//            [self stopLoading];
//            self.task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl1]]];
//            [self.task resume];
//
//        }
//    }else{
    
        self.task = [session dataTaskWithRequest:self.request];
        [self.task resume];
//    }
    if ([mutableReqeust.URL.absoluteString containsString:@"iqiyi://"]) {
        GSLog(@"抓广告 %@",mutableReqeust.URL.absoluteString);
        [self stopLoading];
    }
  
}
- (void)stopLoading
{
    if (self.task != nil)
    {
        [self.task  cancel];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSData *data1;
    NSString * string;
    if(data){
        NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        GSLog(@"捕获_html：%@",result);
        //屏蔽广告
        if ([result containsString:@"https://xn--"]||[result containsString:@"var ads ="] ||[result containsString:@"window[a]"]) {
            string=[result stringByReplacingOccurrencesOfString:@"https://xn--"withString:@"gs"];
            string=[result stringByReplacingOccurrencesOfString:@"var ads ="withString:@"gs"];
            NSLog(@"replaceStr=%@",string);
            string=[result stringByReplacingOccurrencesOfString:@"isPC() == 0"withString:@"gs"];
            data1 =[string dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    [[self client] URLProtocol:self didLoadData:data1?:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<a>" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"</a>" intoString:&text];
        //替换字符
        if ([html containsString:@"https://vip."]||[html containsString:@"http://tz."]) {
            html=[html stringByReplacingOccurrencesOfString:@"https://vip."withString:@"gs"];
            html=[html stringByReplacingOccurrencesOfString:@"https://tz."withString:@"gs"];
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",html] withString:@"gs"];
        }else{
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
       
    }
    
    return html;
}

@end
