//
//  GSTextLoading.m
//  SonDelivery
//
//  Created by 巩少鹏 on 2020/4/16.
//  Copyright © 2020 巩少鹏. All rights reserved.
//

#import "GSTextLoading.h"
#import "GSLoading.h"
@interface GSTextLoading ()<MyGSLoadingDelegate>
@property (nonatomic,  strong) GSLoading *shimmer;
@end
@implementation GSTextLoading
+(void)showGSLoadingView:(UIView *)newView{
    GSTextLoading * loading = [[GSTextLoading alloc]init];
    newView.tag = 199211;
    [newView addSubview:loading];
//    [newView insertSubview:loading atIndex:0];
    [newView bringSubviewToFront:loading];
    [loading startLoading];
//    [[IphoneType keyWindow] addSubview:netView];
}
+(void)reomveGSLoadingView:(UIView*)newView{
    GSTextLoading * loading =  (GSTextLoading *)[newView viewWithTag:199211];
    GSLog(@"%@",loading);
     [loading stopLoading];
//    GSTextLoading * netView =  (GSTextLoading *)[newView viewWithTag:1008612];
////    [netView removeFromSuperview];
//    netView.hidden = YES;
}
static GSTextLoading *manager=nil;

+(instancetype)loadingManager{
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                  if (manager==nil)
                  {
                      manager=[[GSTextLoading alloc]init];
                      
                  }
                  });
    return manager;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self set_init];
        [self set_UI];
        [self set_Frame];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self set_init];
        [self set_UI];
        [self set_Frame];
    }
    return self;
}
-(void)set_init{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.userInteractionEnabled = NO;
}
-(void)set_UI{
    [self addSubview:self.shimmer];
}
-(void)set_Frame{
//    [_shimmer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake( [[UIScreen mainScreen] bounds].size.width, 30));
//    }];
}
#pragma mark - 懒加载
-(GSLoading *)shimmer{
    if (!_shimmer) {
        GSLoading *shimmer = [[GSLoading alloc] init];
        shimmer.frame = CGRectMake(0, 0, 120, 30);
        shimmer.text = @"GS浏览器";
        shimmer.textAlignment = NSTextAlignmentCenter;
        shimmer.numberOfLines = 0;
        shimmer.font = [UIFont boldSystemFontOfSize:25];
        shimmer.backgroundColor = [UIColor clearColor];
        shimmer.textColor = [UIColor whiteColor];
        shimmer.loadingWidth = 30;
        shimmer.loadingColor = [UIColor blackColor];
        shimmer.loadingBackgroundColor = [UIColor clearColor];
        shimmer.style = GSLoadingStyle_Slanted;
        shimmer.animationStyle = GSLoadingAnimationStyle_EaseInOut;
        shimmer.loadingDuration = 0.8;
        shimmer.delegate = self;
        shimmer.loadingAlpha = 1 ;
            
        _shimmer = shimmer;
    }
    return _shimmer;
}
-(void)setText:(NSString *)text{
    _shimmer.text = text;
    [self startLoading];
}
#pragma mark - 代理
-(void)myAnimationStop{
    [self stopLoading];
}
#pragma mark - 共公方法
-(void)startLoading{
    self.shimmer.layer.position = self.center;
    [self.shimmer start];
    [[self keyWindow] addSubview:self];
}
-(void)stopLoading{
    [self.shimmer stop];
    [self removeFromSuperview];
}
#pragma mark -  私有方法
-(UIWindow *)keyWindow{
     UIWindow* window = nil;
     
//            if (@available(iOS 13.0, *))
//            {
//                for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
//                {
//                    if (windowScene.activationState == UISceneActivationStateForegroundActive)
//                    {
//                        window = windowScene.windows.lastObject;
//
//                        break;
//                    }
//                }
//            }else{
                window = [UIApplication sharedApplication].keyWindow;
//            }
    return window;
}
@end
