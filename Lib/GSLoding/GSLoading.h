//
//  GSLoading.h
//  GSLoading
//
//  Created by 巩少鹏 on 2020/4/16.
//  Copyright © 2020 HaoCold. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GSLoadingStyle) {
    GSLoadingStyle_Unknow,
    GSLoadingStyle_Normal,
    GSLoadingStyle_Slanted,
};

typedef NS_ENUM(NSUInteger, GSLoadingAnimationStyle) {
    GSLoadingAnimationStyle_EaseInOut = UIViewAnimationOptionCurveEaseInOut,
    GSLoadingAnimationStyle_EaseIn    = UIViewAnimationOptionCurveEaseIn,
    GSLoadingAnimationStyle_EaseOut   = UIViewAnimationOptionCurveEaseOut,
    GSLoadingAnimationStyle_Linear    = UIViewAnimationOptionCurveLinear,
};

@protocol MyGSLoadingDelegate <NSObject>
-(void)myAnimationStop;

@end
@interface GSLoading : UILabel
@property(nonatomic, assign) id<MyGSLoadingDelegate>delegate;

/// Default is white.
@property (nonatomic,  strong) UIColor                  *loadingColor;
/// Default is black.
@property (nonatomic,  strong) UIColor                  *loadingBackgroundColor;
/// Default is 30.
@property (nonatomic,  assign) CGFloat                  loadingWidth;
/// Default is 3.
@property (nonatomic,  assign) CGFloat                  loadingDuration;
/// Default is 1.
@property (nonatomic,  assign) CGFloat                  loadingInterval;
/// Default is NO.
@property (nonatomic,  assign) BOOL                     loadingOnce;
/// Default is 1.
@property (nonatomic,  assign) CGFloat                  loadingAlpha;
/// 循环次数 Default is 3.
@property (nonatomic,  assign) CGFloat                  loadingCycleTimes;
/// GSLoadingStyle_Normal
@property (nonatomic,  assign) GSLoadingStyle           style;
/// GSLoadingAnimationStyle_EaseInOut
@property (nonatomic,  assign) GSLoadingAnimationStyle  animationStyle;

- (void)start;
- (void)stop;


@end

NS_ASSUME_NONNULL_END
