//
//  UIView+HUD.h
//  CCQMEnglish
//
//  Created by Kean on 2019/10/29.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

extern NSTimeInterval const hudShortDelay;
extern NSTimeInterval const hudLongDelay;
extern NSTimeInterval const hudSuperLongDelay;

@interface UIView (HUD)
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)MBProgressHUD *textHud;
@property(nonatomic,strong)MBProgressHUD *indicatorHud;

/** 展示文本提示 默认在中心位置上*/
- (void)gs_showTextHud:(NSString *)title;

/** 展示文本提示在指定位置上*/
- (void)gs_showTextHud:(NSString *)title withOffset:(CGPoint)offset;

/** 展示文本提示在指定位置上 在指定时间后去掉*/
- (void)gs_showTextHud:(NSString *)title withOffset:(CGPoint)offset hideAfterTime:(CGFloat)time;

/** 展示加载进度hud，默认在中心位置上*/
- (void)gs_showLoadingHud:(NSString *)title;

/** 展示加载进度hud在指定位置上*/
- (void)gs_showLoadingHud:(NSString *)title withOffset:(CGPoint)offset;

/** 去掉所有hud，带着延迟*/
- (void)gs_hideHudWithDelay;

/** 去掉所有hud，自定义延迟时间*/
- (void)gs_hideHudAfterDelay:(NSTimeInterval)interval;

/** 立即去掉所有hud*/
- (void)gs_hideHudImmediately;

/** 显示一个indicator*/
- (void)gs_startIndicatorLoading;

/** 显示一个indicator 自定义背景色*/
- (void)gs_startIndicatorLoadingWithColor:(UIColor *)bgColor;

/** 停止indicator*/
- (void)gs_stopIndicatorLoading;

@end
