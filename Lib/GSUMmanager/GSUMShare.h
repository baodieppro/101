//
//  GSUMShare.h
//  DSBrowser
//
//  Created by 巩小鹏 on 2016/11/24.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMConfigure.h>
//#import "WXApi.h"

@interface GSUMShare : NSObject 
//注册UM分享
+(void)newGSUMShare;
//微信登录
+ (void)getAuthWithUserInfoFromWechat;
//分享图片
+ (void)shareImageToPlatformType:(UMSocialPlatformType)platformType ShareImage:(id)shareImage;
//分享微信小程序
+ (void)shareMiniwithPath:(NSString *)path
                 userName:(NSString *)userName
          miniProgramType:(NSInteger)miniProgramType
                 msgTitle:(NSString *)title
              description:(NSString *)description
                thumImage:(NSString *)thumImage;
//分享error
+ (void)alertWithError:(NSError *)error;

@end
