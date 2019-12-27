//
//  GSAnimation.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/31.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSAnimationManager : NSObject
/**
 闪烁的动画
 */
+(CABasicAnimation *)opacityForever_Animation:(float)time;

/**
 移动动画
 */
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x;
+(CABasicAnimation *)move:(float)time fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue;

/**
 缩放动画
 */
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes;
/**
 组合动画
 */
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes;
/**
 路径动画
 */
+(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes;

/**
 旋转动画
 */
+(CABasicAnimation *)rotation:(float)dur;
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;
@end

NS_ASSUME_NONNULL_END
