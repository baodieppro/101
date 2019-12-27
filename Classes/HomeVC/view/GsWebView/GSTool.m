//
//  WEBTool.m
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "GSTool.h"

@implementation GSTool
    
+(BOOL)newIsHttp:(NSString *)schemeUrl
    {
        BOOL _isGood = false;
        NSArray *arrScheme = @[@"http",@"https",@"thunder"];
        NSInteger _itme = arrScheme.count;
        for (NSInteger i = 1; i <= _itme; i++) {
            //        if ([arrScheme[i] rangeOfString:schemeUrl].location != NSNotFound) {
            //            return YES;
            //        }
            if ([schemeUrl isEqualToString:arrScheme[i-1]]) {
                _isGood =  YES;
                break;
            }else{
                _isGood = NO;
            }
        }
        return _isGood;
    }
    
+(BOOL)newisHttpOrHttps:(NSString *)url
{
    if([url rangeOfString:@"http"].location !=NSNotFound || [url rangeOfString:@"https"].location !=NSNotFound){
        
        return YES;
        
        
    }else{
        NSString * str = [NSString stringWithFormat:@"http://%@",url];
        if ([GSTool justURlSite:str]) {
            
            return YES;
        }
        
    }
    return NO;
}
+ (BOOL) justURlSite:(NSString *)urlSite
    {
        if(urlSite == nil) {
            return NO;
        }
        NSString *url;
        if (urlSite.length>4 && [[urlSite substringToIndex:4] isEqualToString:@"www."]) {
            url = [NSString stringWithFormat:@"https://%@",urlSite];
        }else{
            url = urlSite;
        }
        NSString *urlSiteRegex = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-,!+#]*)?";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlSiteRegex];
        return [passWordPredicate evaluateWithObject:url];
    }
+(NSString *)urlWithIsUrl:(NSString *)url{
    if ([self justURlSite:url] == YES) {
        //如果是url
        if([url rangeOfString:@"http"].location != NSNotFound || [url rangeOfString:@"https"].location != NSNotFound){
            return url;
        }else{
            if (url.length>4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
                 return [NSString stringWithFormat:@"https://%@",url];
            }
        }
    }else{
        //如果不是url
        return [NSString stringWithFormat:@"https://m.baidu.com/s?word=%@",[NSString UrlEncodeUTF8String:url]];
    }
    return url;
}
@end
