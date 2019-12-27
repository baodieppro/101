//
//  GSAnimation.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/31.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSAnimationManager.h"
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

@implementation GSAnimationManager

#pragma mark === 永久闪烁的动画 ======

+(CABasicAnimation *)opacityForever_Animation:(float)time

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    animation.autoreverses = YES;
    
    animation.duration = time;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
    
}



#pragma mark =====横向、纵向移动===========

+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    
    animation.toValue = x;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    
    animation.repeatCount = MAXFLOAT;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}
+(CABasicAnimation *)move:(float)time fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:fromValue];
    animation.toValue = [NSValue valueWithCGPoint:toValue];;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    
    animation.repeatCount = MAXFLOAT;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}


#pragma mark =====缩放+=============

+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = Multiple;
    
    animation.toValue = orginMultiple;
    
    animation.autoreverses = YES;
    
    animation.repeatCount = repertTimes;
    
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    return  animation;
    
}



#pragma mark =====组合动画+=============

+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes

{
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    
    animation.animations = animationAry;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;
    
    animation.repeatCount = repeatTimes;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}



#pragma mark =====路径动画+=============

+(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes

{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path = path;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.autoreverses = NO;
    
    animation.duration = time;
    
    animation.repeatCount = repeatTimes;
    
    return animation;
    
}



#pragma mark ====旋转动画======
+(CABasicAnimation *)rotation:(float)dur
{
   return  [self rotation:dur degree:0 direction:0 repeatCount:0];
}

+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount

{
    CABasicAnimation *animation ;
    if (degree != 0 && direction != 0) {
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];

        CATransform3D rotationTransform = CATransform3DMakeRotation(kRadianToDegrees(degree), 0, 0, direction);
        
        animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
        
        animation.autoreverses = NO;
        
        animation.cumulative = NO;
    }else{
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

        animation.toValue = @(M_PI*2);
    }

    animation.duration  =  dur;
    
  
    
    animation.fillMode = kCAFillModeForwards;
    if (repeatCount != 0) {
        animation.repeatCount = repeatCount;

    }else{
        animation.repeatCount = MAXFLOAT;

    }
    
    animation.removedOnCompletion = NO;
//    animation.delegate = self;
    
    return animation;
    
    
    
}

@end
