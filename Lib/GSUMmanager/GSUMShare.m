//
//  GSUMShare.m
//  DSBrowser
//
//  Created by 巩小鹏 on 2016/11/24.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import "GSUMShare.h"
#import "GSUMConfigInstance.h"

@interface GSUMShare ()

@end
@implementation GSUMShare

+(void)newGSUMShare{
    
    //打开调试日志
    [UMConfigure setLogEnabled:YES];
    
    //设置友盟appkey
    [UMConfigure initWithAppkey:@"5e0aa9b30cafb2c6c3000733" channel:@"App Store"];

    //各平台的详细配置
    //设置微信的appId和appKey
      [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbc7797edc23e3e89" appSecret:@"95ca110db8156add176c6a71ad15d701" redirectURL:@"http://mobile.umeng.com/social"];
    
    [GSUMConfigInstance newGSUMConfigInstance];
}

// 在需要进行获取用户信息的UIViewController中加入如下代码

//微信登录
+ (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {

        } else {

            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);

            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);

            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);

         
        }
    }];
////    [[GSUMShare new] sendAuthRequest];
}


#pragma mark - 分享逻辑
//分享文本
+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//分享图片
+ (void)shareImageToPlatformType:(UMSocialPlatformType)platformType ShareImage:(id)shareImage
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon_singsingEnglish"];
    [shareObject setShareImage:shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//分享图片和文字
+ (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:@"http://dev.umeng.com/images/tab2_1.png"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//网页分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType titleShare:(NSString *)titleShare urlShare:(NSString *)urlShare
{
    if ([titleShare isEqualToString:@""]) {
        titleShare =@"本次分享来自于唱唱启蒙英语";
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象r
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleShare descr:titleShare thumImage:[UIImage imageNamed:@"icon_singsingEnglish"]];
    //设置网页地址
    shareObject.webpageUrl = urlShare;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//音乐分享
+ (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建音乐内容对象
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon_singsingEnglish"]];
    //设置音乐网页播放地址
    shareObject.musicUrl = @"http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect";
    //            shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}

//视频分享
+ (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon_singsingEnglish"]];
    //设置视频网页播放地址
    shareObject.videoUrl = @"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html";
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
//分享微信小程序
+ (void)shareMiniwithPath:(NSString *)path
                 userName:(NSString *)userName
          miniProgramType:(NSInteger)miniProgramType
                 msgTitle:(NSString *)title
              description:(NSString *)description
                thumImage:(NSString *)thumImage
{
    id img ;
    if (thumImage) {
        if([thumImage rangeOfString:@"http"].location !=NSNotFound || [thumImage rangeOfString:@"https"].location !=NSNotFound){
            img = thumImage;
        }else{
            img = [UIImage imageNamed:thumImage];
        }
    }else{
        img = [UIImage imageNamed:@"Logo"];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:description thumImage:img];
    shareObject.webpageUrl = @"http://www.qq.com";// 兼容低版本的网页链接
    shareObject.userName = userName;
    shareObject.path = path;
    messageObject.shareObject = shareObject;
//    shareObject.hdImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Logo" ofType:@"png"]];
    shareObject.miniProgramType = miniProgramType; // 可选体验版和开发板
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:[self gs_getCurrentViewController] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}

+ (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    
    
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功！"];
//        [GSUMConfigInstance newGSevent:@"shareSuccess"];
    }
    else{
        if (error) {
            switch ((NSInteger)error.code) {
                case 2000:
                {
                    result = @"未知错误";
                }
                    break;
                case 2001:
                {
                    result = @"url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持";
                }
                    break;
                case 2002:
                {
                    result = @"授权失败";
                }
                    break;
                case 2003:
                {
                    result = @"分享失败";
                }
                    break;
                case 2004:
                {
                    result = @"请求用户信息失败";
                }
                    break;
                case 2005:
                {
                    result = @"分享内容为空";
                }
                    break;
                case 2006:
                {
                    result = @"分享内容不支持";
                }
                    break;
                case 2007:
                {
                    result = @"schemaurl fail";
                }
                    break;
                case 2008:
                {
                    result = @"应用未安装";
                }
                    break;
                case 2009:
                {
                    result = @"取消操作";
                }
                    break;
                case 2010:
                {
                    result = @"网络异常";
                }
                    break;
                case 2011:
                {
                    result = @"第三方错误";
                }
                    break;
                case 2013:
                {
                    result = @"对应的 UMSocialPlatformProvider的方法没有实现";
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            result = [NSString stringWithFormat:@"分享失败！"];
        }
    }
    NSString *version= [UIDevice currentDevice].systemVersion;
    
    if(version.doubleValue >=9.0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享" message:result preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [[self gs_getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
  
   
    
    
}

+ (UIViewController *)gs_getCurrentViewController{
    
    UIViewController* currentViewController = [self gs_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}
+ (UIViewController *)gs_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
@end
