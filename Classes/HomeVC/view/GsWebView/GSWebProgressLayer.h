//
//  GSWebProgressLayer.h
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSWebProgressLayer : CAShapeLayer
    // 开始加载
- (void)startLoad;
    // 完成加载
- (void)finishedLoadWithError:(NSError *)error;
    // 关闭时间
- (void)closeTimer;
    
- (void)wkWebViewPathChanged:(CGFloat)estimatedProgress;
@end

NS_ASSUME_NONNULL_END
