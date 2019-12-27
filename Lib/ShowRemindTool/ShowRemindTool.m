//
//  NetworkError.m
//  MQBrowser
//
//  Created by 巩小鹏 on 2017/2/13.
//  Copyright © 2017年 巩小鹏. All rights reserved.
//

#import "ShowRemindTool.h"
//#import "UIImage+GIF.h"
@interface ShowRemindTool ()
{
    NSInteger _countTime;
}

@end
@implementation ShowRemindTool



+(void)showHUDWithTitle:(NSString *)title withView:(UIView *)view
{
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    UIWindow *window = [windows objectAtIndex:0];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    [window addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
//    hud.label.text = title;
//    hud.label.font = [UIFont boldSystemFontOfSize:15];

    hud.detailsLabel.text = title;

//    [window bringSubviewToFront:hud];
    hud.yOffset = -(__kNewSize(300));

    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(DefaultAnimationTime);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
    
}

+(void)showHUDWithTitle:(NSString *)title withView:(UIView *)view complete:(void (^)())completion
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [window addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.font = [UIFont boldSystemFontOfSize:15];
    [window bringSubviewToFront:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(DefaultAnimationTime);
    } completionBlock:^{
        [hud removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    
}

+(MBProgressHUD *)showHUDWithLoadingWithTitle:(NSString *)title withView:(UIView *)view animated:(BOOL)animated
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    
    //    hud.dimBackground = YES;
    hud.label.text = title;
    
    return hud;
    
}

+(void)hiddenHUDLoadingForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+(void)hiddenAllHUDForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}
+(void)newPlayHUD:(UIView *)view text:(NSString *)text
{
   MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.yOffset = -(__kNewSize(300));
    HUD.mode = MBProgressHUDModeIndeterminate;//圆环作为进度条
    //4,设置提示信息 信息颜色，字体
    HUD.label.text = text;
    HUD.label.textColor = [UIColor blackColor];
    HUD.label.font = [UIFont systemFontOfSize:13];
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES afterDelay:10.0];

}


+(void)gifPlayView:(UIView *)view TagView:(NSInteger)tag isHide:(BOOL)isHide
{
//    if (isHide == NO) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
////        UIImage  *image=[UIImage sd_animatedGIFNamed:@"loading_4"];
//        UIImage *   image = [UIImage sd_imageWithGIFData:UIImageJPEGRepresentation([UIImage imageNamed:@"loading_4"], 1.0)];
//        UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
//        gifview.image=image;
//        hud.bezelView.color=[UIColor clearColor];//默认颜色太深了
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.label.text = @"加载中...";
//        hud.customView=gifview;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.tag = 66544+tag;
//        [hud hideAnimated:YES afterDelay:12.0];
//    }else{
//        MBProgressHUD *hud = (MBProgressHUD *)[view viewWithTag:66544+tag];
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hideAnimated:YES];
//    }
   //
//    [hud hideAnimated:YES];
}

+(void)hideHUD:(UIView *)view
{
  [MBProgressHUD hideHUDForView:view animated:YES];
}
//设置加载圈
+ (void)initMBProgressHUD:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1];
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    hud.square = YES;//等宽高
    hud.margin = 30;//修改该值，可以修改加载框大小
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = @"数据加载中...";
    hud.label.textColor = [UIColor whiteColor];
    [hud showAnimated:YES];
    
    [view addSubview:hud];
}


+(void)newBackImage:(UIView *)view Index:(NSInteger)index isHide:(BOOL)isHide
{
    
       if (isHide == NO) {
         UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_noun"]];
        
        imgView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__-__kNewSize(80));
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        imgView.tag = 99981+index;
        imgView.userInteractionEnabled = YES;
        [view addSubview:imgView];
    
    }else{
        
        [UIView animateWithDuration:0.4 animations:^{
            UIImageView *remoView = (UIImageView *)[view viewWithTag:99981+index];
            remoView.alpha = 0;
            [remoView removeFromSuperview];
            remoView = nil;
        }];
       
    }
    

}









// 弹出警告框
+ (void)showTitle:(NSString *)title
          message:(NSString *)message
      titleButton:(NSString *)titleBth
{
    UIAlertView *alertView   = [[UIAlertView alloc]
                                initWithTitle:title
                                message:message
                                delegate:nil
                                cancelButtonTitle:nil
                                otherButtonTitles:titleBth, nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    [alertView show];
}







@end
