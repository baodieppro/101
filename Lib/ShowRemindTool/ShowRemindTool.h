//
//  NetworkError.h
//  MQBrowser
//
//  Created by 巩小鹏 on 2017/2/13.
//  Copyright © 2017年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <ImageIO/ImageIO.h>
#import "MBProgressHUD.h"

@interface ShowRemindTool : NSObject


#define DefaultAnimationTime 1.8

+ (void)showHUDWithTitle:(NSString *)title withView:(UIView *)view;
+(MBProgressHUD *)showHUDWithLoadingWithTitle:(NSString *)title withView:(UIView *)view animated:(BOOL)animated;

//菊花loading
+ (void)initMBProgressHUD:(UIView *)view;
+ (void)hiddenHUDLoadingForView:(UIView *)view animated:(BOOL)animated;
+ (void)hiddenAllHUDForView:(UIView *)view animated:(BOOL)animated;

+(void)newPlayHUD:(UIView *)view text:(NSString *)text;

+(void)gifPlayView:(UIView *)view TagView:(NSInteger)tag isHide:(BOOL)isHide;
+(void)hideHUD:(UIView *)view;
+(void)newBackImage:(UIView *)view Index:(NSInteger)index isHide:(BOOL)isHide;

//弹出警告框
+(void)showTitle:(NSString *)title message:(NSString *)message titleButton:(NSString *)titleBth;


@end
