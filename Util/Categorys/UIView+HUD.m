//
//  UIView+HUD.m
//  CCQMEnglish
//
//  Created by Kean on 2019/10/29.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "UIView+HUD.h"
#import <unistd.h>
#import <objc/runtime.h>

#define kProgressHudFont [UIFont systemFontOfSize:12]

NSTimeInterval const hudShortDelay = 0.5;
NSTimeInterval const hudLongDelay = 1;
NSTimeInterval const hudSuperLongDelay = 1.5;

static void *hudKey = &hudKey;
static void *textHudKey = &textHudKey;
static void *indicatorHudKey = &indicatorHudKey;

@implementation UIView (HUD)
@dynamic hud;

- (MBProgressHUD *)hud
{
    return objc_getAssociatedObject(self, &hudKey);
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)textHud
{
    return objc_getAssociatedObject(self, &textHudKey);
}

- (void)setTextHud:(MBProgressHUD *)textHud
{
    objc_setAssociatedObject(self, &textHudKey, textHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)indicatorHud
{
    return objc_getAssociatedObject(self, &indicatorHudKey);
}

- (void)setIndicatorHud:(MBProgressHUD *)indicatorHud
{
    objc_setAssociatedObject(self, &indicatorHudKey, indicatorHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gs_showTextHud:(NSString *)title
{
    [self gs_showTextHud:title withOffset:CGPointZero];
}

- (void)gs_showTextHud:(NSString *)title withOffset:(CGPoint)offset
{
    [self gs_showTextHud:title withOffset:offset hideAfterTime:hudSuperLongDelay];
}

- (void)gs_showTextHud:(NSString *)title withOffset:(CGPoint)offset hideAfterTime:(CGFloat)time
{
    if(title.length == 0){
        return;
    }
    if(!self.textHud){
        self.textHud = [[MBProgressHUD alloc] initWithView:self];
        self.textHud.removeFromSuperViewOnHide = YES;
    }
    [self addSubview:self.textHud];
    
    self.textHud.mode = MBProgressHUDModeText;
    self.textHud.margin = 20.f;
    self.textHud.color = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    self.textHud.detailsLabelText = title;
    self.textHud.detailsLabelFont = kProgressHudFont;
    self.textHud.detailsLabelColor = [UIColor blackColor];
    self.textHud.xOffset = offset.x;
    self.textHud.yOffset = offset.y;
    [self.textHud show:YES];
    [self.textHud hide:YES afterDelay:time];
}

- (void)gs_showLoadingHud:(NSString *)title
{
    [self gs_showLoadingHud:title withOffset:CGPointZero];
}

- (void)gs_showLoadingHud:(NSString *)title withOffset:(CGPoint)offset
{
    NSString *info = title.length != 0 ? title : @"加载中";
    if(!self.hud){
        self.hud = [[MBProgressHUD alloc] initWithView:self];
        self.hud.removeFromSuperViewOnHide = YES;
    }
    [self addSubview:self.hud];
    
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.square = info.length <= 6;
    self.hud.color = [[UIColor whiteColor]colorWithAlphaComponent:0];
    self.hud.margin = 20.f;
    self.hud.labelText = info;
    self.hud.labelFont = kProgressHudFont;
    self.hud.xOffset = offset.x;
    self.hud.yOffset = offset.y;
    
    [self.hud show:YES];
}


- (void)gs_hideHudWithDelay
{
    [self gs_hideHudAfterDelay:hudShortDelay];
}

- (void)gs_hideHudAfterDelay:(NSTimeInterval)interval
{
    [self performSelector:@selector(gs_hideHudImmediately) withObject:nil afterDelay:interval];
}

- (void)gs_hideHudImmediately
{
    if(self.hud){
        [self.hud hide:YES];
    }
}


- (void)gs_startIndicatorLoading
{
    if(!self.indicatorHud){
        self.indicatorHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        self.indicatorHud.removeFromSuperViewOnHide = YES;
    }
}

- (void)gs_startIndicatorLoadingWithColor:(UIColor *)bgColor
{
    [self gs_startIndicatorLoading];
    self.indicatorHud.color = bgColor;
}

- (void)gs_stopIndicatorLoading
{
    if(self.indicatorHud){
        [self.indicatorHud hide:YES];
    }
}

@end
