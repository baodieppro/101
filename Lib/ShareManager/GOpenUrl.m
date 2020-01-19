//
//  GOpenUrl.m
//  ToolscreenShot
//
//  Created by 巩小鹏 on 2018/9/17.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import "GOpenUrl.h"
#import "AppDelegate.h"

@implementation GOpenUrl


+(BOOL)isAppOpenStr:(NSString *)str
{
    return [self isAppOpenURL:[NSURL URLWithString:str]];
}

+(BOOL)newOpenStr:(NSString *)str
{
    return  [self newOpenURL:[NSURL URLWithString:str]];
}

+(BOOL)isAppOpenURL:(NSURL *)url
{
    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
        return YES;
    }
    return NO;
}

+(BOOL)newOpenURL:(NSURL *)url
{
    if( [self isAppOpenURL:url] ) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
        return YES;
    }else{
        return NO;
    }
}
@end
