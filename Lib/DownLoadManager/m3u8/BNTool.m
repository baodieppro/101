//
//  BNTool.m
//  m3u8Demo
//
//  Created by zengbailiang on 2019/8/17.
//  Copyright © 2019 Bennie. All rights reserved.
//

#import "BNTool.h"
#import "NSString+m3u8.h"

@implementation BNTool
+ (NSString *)uuidWithUrl:(NSString *)Url
{
    return [Url md5];
}
//验证Url
+(NSString *)m3u8Url:(NSString *)urlStr{
    NSString *m3u8Str = nil;
    
    NSError *error = nil;
    m3u8Str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] usedEncoding:0 error:&error];
    if (error)
    {
        return urlStr;
    }
    //m3u8下载地址解析例子：
    if([m3u8Str containsString:@"EXT-X-STREAM-INF"]){
      
        urlStr = [BNTool setParsingWithM3u8Url:urlStr m3u8Str:m3u8Str];

        m3u8Str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] usedEncoding:0 error:&error];
    }
    if (m3u8Str.length == 0)
    {
        NSLog(@"原始m3u8文件内容为空");
        return urlStr;
    }
    return urlStr;
    
}
 //m3u8下载地址解析例子：
+ (NSString *)setParsingWithM3u8Url:(NSString *)urlStr m3u8Str:(NSString *)m3u8Str{
    NSString *  dUrl  ;
    NSString * downLoadM3U8Url ;
    if([m3u8Str containsString:@"EXT-X-STREAM-INF"]){
        m3u8Str = [m3u8Str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if([m3u8Str containsString:@"1000k"]){
            dUrl = [m3u8Str subStringFrom:@"1000k" to:@".m3u8"];
            downLoadM3U8Url = [BNTool newisHttpOrHttps:[NSString stringWithFormat:@"1000k%@.m3u8",dUrl] orUrl:urlStr];
        }else{
            dUrl = [m3u8Str subStringFrom:@"/" to:@".m3u8"];
            downLoadM3U8Url = [BNTool newisHttpOrHttps:[NSString stringWithFormat:@"%@.m3u8",dUrl] orUrl:urlStr];
        }
    }
       return  downLoadM3U8Url;
        
}

+(NSString *)newisHttpOrHttps:(NSString *)url orUrl:(NSString *)orUrl
{
    if([url rangeOfString:@"http"].location !=NSNotFound || [url rangeOfString:@"https"].location !=NSNotFound){
        
        return url;
    }else{
        //切割参数 暂时用com
        NSString * base_url;
        NSString * new_url ;
        
        if([url containsString:@".m3u8"]){
            if([url containsString:@"index.m3u8"]){
                base_url = [[orUrl subStringTo:@"/index.m3u8"] removeSpaceAndNewline];
                new_url = [NSString stringWithFormat:@"%@/%@",base_url,url];
                
            }else{
                base_url = [[orUrl subStringTo:@"com"] removeSpaceAndNewline];
                new_url = [NSString stringWithFormat:@"%@com/%@",base_url,url];
            }
        }
        else if ([url containsString:@".ts"]) {
            if ([orUrl containsString:@"hls"]&&[url containsString:@"hls"]) {
                base_url = [[orUrl subStringTo:@"com"] removeSpaceAndNewline];
                new_url = [NSString stringWithFormat:@"%@com%@",base_url,url];
            }else{
                if ([orUrl containsString:@".m3u8"]) {
                    NSArray *array = [orUrl componentsSeparatedByString:@"/"];
                    base_url = [[orUrl subStringTo:array.lastObject] removeSpaceAndNewline];
                    new_url = [NSString stringWithFormat:@"%@%@",base_url,url];
                }else{
                    base_url = [[orUrl subStringTo:@"com"] removeSpaceAndNewline];
                    new_url = [NSString stringWithFormat:@"%@com%@",base_url,url];
                }
            }
        }
        else
        {
            base_url = [[orUrl subStringTo:@"com"] removeSpaceAndNewline];
            new_url = [NSString stringWithFormat:@"%@com%@",base_url,url];
        }
        
        return new_url;
    }
    return url;
}
@end
