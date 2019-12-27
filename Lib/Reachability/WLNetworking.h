//
//  WLNetworking.h
//   
//
//  Created by ikuaishou on 15/11/25.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
//#import "HYBNetworking.h"

typedef NS_ENUM(NSInteger, WLNetworkReachabilityStatus) {
    WLNetworkReachabilityStatusUnknown          = -1,//未知
    WLNetworkReachabilityStatusNotReachable     = 0,//无网络
    WLNetworkReachabilityStatusReachableViaWWAN = 1,//蜂窝网络
    WLNetworkReachabilityStatusReachableViaWiFi = 2,//wifi
    
    WLNetworkReachabilityStatusReachableViaWWAN2G = 3,//2G
    WLNetworkReachabilityStatusReachableViaWWAN3G = 4,//3G
    WLNetworkReachabilityStatusReachableViaWWAN4G = 5,//4G
};


// 请勿直接使用AFHTTPRequestOperation,以减少对第三方的依赖
//typedef AFHTTPRequestOperation WLRequestOperation;

/**
 *  请求成功的回调
 *
 *  @param response 服务端返回的数据类型，通常是字典
 */
typedef void(^ WLResponseSuccess)(id response);

/**
 *  请求失败的回调
 *
 *  @param error 错误信息
 */
typedef void(^ WLResponseFail)(NSError *error);



@interface WLNetworking : NSObject



/**
 *  监控网络状态
 *
 *  @param statusBlock
 */
+ (void)monitoringReachabilityStatus:(void (^)(WLNetworkReachabilityStatus)) statusBlock;

+ (WLNetworkReachabilityStatus)networkStatus;

/**
 *  关闭监控网络状态
 */
+ (void)stopMonitoring;
///*!
// *
// *  用于指定网络请求接口的基础url
// *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
// *  于多个服务器，可以调用更新
// *
// *  @param baseUrl 网络接口的基础url
// */
//+ (void)updateBaseUrl:(NSString *)baseUrl;
//
///*!
// *
// *  对外公开可获取当前所设置的网络接口基础url
// *
// *  @return 当前基础url
// */
//+ (NSString *)baseUrl;
//
//
///**
// *  GET请求接口，若不指定baseurl，可传完整的url
// *
// *  @param url     接口路径，如/path/getArticleList
// *  @param success 接口成功请求到数据的回调
// *  @param fail    接口请求数据失败的回调
// *
// *  @return 返回的对象中有可取消请求的API
// */
//+ (WLRequestOperation *)getWithUrl:(NSString *)url
//                           success:(WLResponseSuccess)success
//                              fail:(WLResponseFail)fail;
//
///**
// *  GET请求接口，若不指定baseurl，可传完整的url
// *
// *  @param url     接口路径，如/path/getArticleList
// *  @param params  接口中所需要的拼接参数，如@{"categoryid" : @(12)}
// *  @param success 接口成功请求到数据的回调
// *  @param fail    接口请求数据失败的回调
// *
// *  @return 返回的对象中有可取消请求的API
// */
//+ (WLRequestOperation *)getWithUrl:(NSString *)url
//                            params:(NSDictionary *)params
//                           success:(WLResponseSuccess)success
//                              fail:(WLResponseFail)fail;
//
///**
// *  POST请求接口，若不指定baseurl，可传完整的url
// *
// *  @param url     接口路径，如/path/getArticleList
// *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
// *  @param success 接口成功请求到数据的回调
// *  @param fail    接口请求数据失败的回调
// *
// *  @return 返回的对象中有可取消请求的API
// */
//+ (WLRequestOperation *)postWithUrl:(NSString *)url
//                            params:(NSDictionary *)params
//                           success:(WLResponseSuccess)success
//                              fail:(WLResponseFail)fail;
//
///**
// *  图片上传接口，若不指定baseurl，可传完整的url
// *
// *  @param image    图片对象
// *  @param url      上传图片的接口路径，如/path/images/
// *  @param filename 给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
// *  @param name     与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
// *  @param success  上传成功的回调
// *  @param fail     上传失败的回调
// *
// *  @return 返回类型有取消请求的api
// */
//+ (WLRequestOperation *)uploadWithImage:(UIImage *)image
//                                    url:(NSString *)url
//                               filename:(NSString *)filename
//                                   name:(NSString *)name
//                             parameters:(NSDictionary *)parameters
//                                success:(WLResponseSuccess)success
//                                   fail:(WLResponseFail)fail;
//
//+ (WLRequestOperation *)uploadWithImage:(UIImage *)image
//uploadWithImage:(UIImage *)imageOne
//uploadWithImage:(UIImage *)imageTwo
//                                    url:(NSString *)url
//                               filename:(NSString *)filename
//                                   name:(NSString *)name
//                             parameters:(NSDictionary *)parameters
//                                success:(WLResponseSuccess)success
//                                   fail:(WLResponseFail)fail;
//
//+ (WLRequestOperation *)uploadWithVideo:(NSURL *)VideoUrl
//                                    url:(NSString *)url
//                               filename:(NSString *)filename
//                                   name:(NSString *)name
//                             parameters:(NSDictionary *)parameters
//                                success:(WLResponseSuccess)success
//                                   fail:(WLResponseFail)fail;
//
//
///**
// *  上传数据
// *
// *  @param requestBody requestBody
// *  @param url         url
// *  @param success     上传成功的回调
// *  @param fail        上传失败的回调
// */
//
//+ (void)updataWithString:(NSString *)requestBody
//                     url:(NSString *)url
//                 success:(WLResponseSuccess)success
//                    fail:(WLResponseFail)fail;

@end
