//
//  ToolscreenShot.m
//  ToolscreenShot
//
//  Created by 巩小鹏 on 2018/9/4.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import "ToolscreenShot.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "SecurityStrategy.h"
#import "UIImage+ImageCornerRadius.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "GShareView.h"

@interface ToolscreenShot ()
{
    UIImage * imageSS;
}


@end

@implementation ToolscreenShot

+(instancetype)screenShot{
    static ToolscreenShot *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                      if (manager==nil)
                      {
                          manager=[[ToolscreenShot alloc]init];
                      }
                  });
    return manager;
}



-(void)screenShotsShareview:(UIView *)window
                        url:(NSString *)url
                   complete:(void (^)(UIImage * image))complete
{
    //截屏, 获取所截图片（imageWithScreenshot在后面实现）
    UIImage *imageScreenshot;
    //        image = [UIImage snapshotScreenInView:window];
    
    
    if (window != nil) {
        imageScreenshot =  [SecurityStrategy gsImagerview:window];
        
    }else{
        imageScreenshot =  [SecurityStrategy gsImager];
        
    }
    
    if (url != nil ) {
        [GSQRCodeTool setQRRequest:url image:^(UIImage *imageQr) {
            self->imageSS = [UIImage addImage:imageQr toImage:imageScreenshot];
        
        }];
        
        
    }else{
        //调用显示分享的页面
        imageSS = imageScreenshot;
        
    }
    
    
    complete(imageSS);
}

-(void)screenShotsShare:(NSString *)url complete:(void (^)(UIImage * image))complete
{
    [self screenShotsShareview:nil url:url complete:complete];
    
}

#pragma mark - 添加监听
-(void)addScreenShotNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenShot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
#pragma mark - 移除监听
-(void)removeScreenShotNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
}
#pragma mark - 截屏代码
-(void)screenShot{
    NSLog(@"截屏");
//    [self screenShotsShare:@"试试看吧" complete:^(UIImage * image) {
////        [GShareView newShare].shareType = ShareScreenshotsType;
////        [GShareView newShare].screenShotsImage.image = image;
////        [[GShareView newShare] show];
//    }];
    UIImage * img = [self imageWithScreenshot];
    UIImage * image = [UIImage addImage:[GSQRCodeTool SG_generateWithLogoQRCodeData:self.qrCodeStr logoImageName:@"" logoScaleToSuperView:2.0] toImage:img];
    NSArray * arr = @[image];
    [ShareTool shareWithItem:arr MySelf:[self getCurrentVC] completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed) {
        GSLog(@"activityType %@",activityType);
        if (completed == YES) {
            GSLog(@"分享成功");
        }else{
            GSLog(@"取消分享");
        }
    }];
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
