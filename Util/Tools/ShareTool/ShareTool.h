//
//  ShareTool.h
//  简易心理
//
//  Created by 巩小鹏 on 2017/6/1.
//  Copyright © 2017年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShareTool : NSObject
+ (void)shareWithTitle:(NSString *)title
           description:(NSString *)description
                   url:(NSString *)url
                 image:(UIImage *)image
                MySelf:(id)mySelf
     completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler;
//分享内容 
+ (void)itmeTitle:(NSString *)title Icon:(NSString *)icon placeholderImage:(NSString *)image Url:(NSString *)url Complete:(void (^)(NSArray * itme))complete error:(void (^)(NSString * errorStr))error;;


+ (void)shareWithItem:(NSArray *)item MySelf:(id)mySelf completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler;

@end
