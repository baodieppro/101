//
//  NSTimer+gsAddition.h
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (gsAddition)
- (void)pauseTime;    // 暂停时间
- (void)webPageTime;  // 获取内容所在当前时间
- (void)webPageTimeWithTimeInterval:(NSTimeInterval)time;  // 当前时间 time 秒后的时间
@end

NS_ASSUME_NONNULL_END
