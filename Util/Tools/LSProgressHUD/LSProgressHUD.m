

//
//  LSProgressHUD.m
//  WCGradientLayerExample
//
//  Created by 刘松 on 16/9/13.
//  Copyright © 2016年 huangwenchen. All rights reserved.
//

#import "LSGraintCircleLayer.h"
#import "LSProgressHUD.h"

#define LSProgressHUDCircle 46
#define LSProgressHUDLeftMargin 15
#define LSProgressHUDMiddleMargin 10
#define LSProgressHUDTopMargin 10

@interface LSProgressHUD ()

@property(nonatomic, weak) LSGraintCircleLayer *circleLayer;
@property(nonatomic, weak) UILabel *messageLabel;
@property(nonatomic, weak) UIView *contentView;


@end

@implementation LSProgressHUD

- (instancetype)initWithFrame:(CGRect)frame

{
  if (self = [super initWithFrame:frame]) {
    [self setupViews];
  }
  return self;
}
- (void)setupViews {

    self.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.2];
  UIView *contentView = [[UIView alloc] init];
  contentView.backgroundColor = [UIColor whiteColor];
  contentView.layer.cornerRadius = 5;
  contentView.clipsToBounds = YES;
  [self addSubview:contentView];
  self.contentView = contentView;

  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
  label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines=0;
  [contentView addSubview:label];
  self.messageLabel = label;

  LSGraintCircleLayer *layer = [[LSGraintCircleLayer alloc]
      initGraintCircleWithBounds:CGRectMake(0, 0, LSProgressHUDCircle,
                                            LSProgressHUDCircle)
                        Position:CGPointMake(0, 0)
                       FromColor:[UIColor colorWithWhite:1.000 alpha:0.318]
                         ToColor:[UIColor colorWithRed:0.122
                                                 green:0.702
                                                  blue:0.820
                                                 alpha:1.000]
                       LineWidth:3.0];
  [contentView.layer addSublayer:layer];
  self.circleLayer = layer;
}

+ (instancetype)show {
  return [self showWithMessage:nil];
}

+ (instancetype)showWithMessage:(NSString *)message time:(NSInteger)time{
    UIView *view = self.newWindow;
    __kWeakSelf__;
    [self startTimerWithDelay:time passOneSeconds:^(int currentTime) {
        
    } stop:^{
        [weakSelf hide];
    }];

    return [self createViewToView:view message:message];
}


+ (instancetype)showWithMessage:(NSString *)message {
  UIView *view = self.newWindow;

  return [self createViewToView:view message:message];
}
+ (instancetype)createViewToView:(UIView *)view message:(NSString *)message {
  LSProgressHUD *contentView = [[self alloc] init];
  [view addSubview:contentView];
  return [contentView setViewsMessageAndFrame:message toView:view];
}
- (instancetype)setViewsMessageAndFrame:(NSString *)message
                                 toView:(UIView *)view {

  self.frame = view.bounds;
  CGFloat contentWidth;
  CGFloat labelWidth = 56;
  CGFloat labelHeight=0;
  CGPoint circlePoint;
  self.messageLabel.text = message;

  if (message.length > 0) {
    labelHeight =
        [message boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{
                             NSFontAttributeName : self.messageLabel.font
                           }
                              context:nil]
            .size.height;
      contentWidth = MAX(LSProgressHUDCircle + LSProgressHUDLeftMargin * 2,
                         LSProgressHUDCircle + LSProgressHUDTopMargin * 2+LSProgressHUDMiddleMargin+labelHeight);
      circlePoint = CGPointMake(contentWidth / 2,
                                LSProgressHUDCircle / 2 + LSProgressHUDTopMargin);
  } else {
    contentWidth = MAX(LSProgressHUDCircle + LSProgressHUDLeftMargin * 2,
                       LSProgressHUDCircle + LSProgressHUDTopMargin * 2);
    circlePoint = CGPointMake(contentWidth / 2,contentWidth / 2);
  }
  self.contentView.frame = CGRectMake(0, 0, contentWidth, contentWidth);

  self.circleLayer.position = circlePoint;
  self.messageLabel.frame = CGRectMake((contentWidth - labelWidth) / 2,
                                       LSProgressHUDTopMargin + LSProgressHUDCircle +
                                           LSProgressHUDMiddleMargin,
                                       labelWidth, labelHeight);
  self.contentView.center = view.center;
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI /6 ];
    rotationAnimation.duration = 0.1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [self.circleLayer addAnimation:rotationAnimation forKey:@"ss"];
    
//    self.messageLabel.backgroundColor=[UIColor colorWithRed:0.414 green:0.667 blue:0.667 alpha:1.000];

  return self;
}
+(instancetype)showToView:(UIView *)view message:(NSString *)message
{
    return  [self createViewToView:view message:message];
}
+(void)hideForView:(UIView *)view
{
    [self hideFromView:view];
}
- (void)updateProgress {
  self.circleLayer.transform =
      CATransform3DRotate(self.circleLayer.transform, M_PI / 6, 0, 0, 1);
}
+ (void)hide {
  UIView *view = self.newWindow;
  [self hideFromView:view];
}
+ (void)hideFromView:(UIView *)view {
  NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
  for (UIView *subview in subviewsEnum) {
    if ([subview isKindOfClass:self]) {
      [subview removeFromSuperview];
        break;
    }
  }
}
+ (void)startTimerWithDelay:(NSInteger)delayTime passOneSeconds:(void(^)(int currentTime))oneSecondsPassBlock stop:(void(^)())stopBlock{
    
   // 倒计时时间自定
    
    __block int timeout = delayTime;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //这里调用结束的Blcok
                
                if(stopBlock){
                    
                    stopBlock();
                    
                }
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //倒计时中,每过一秒调用过去1s的block
                
                if(oneSecondsPassBlock){
                    
                    oneSecondsPassBlock(timeout);
                    
                }
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}
+(UIWindow *)newWindow{
    UIWindow * rootWindow;
//    if (@available(iOS 13.0, *)) {
//        rootWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    }else{
        rootWindow = [UIApplication sharedApplication].keyWindow;
//    }
    return rootWindow;
}
@end
