//
//  AppDelegate+Action.h
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/14.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Action)
/**
 模态跳转
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
/**
 push
 */
- (void)pushViewController:(UIViewController *)vc animated:(BOOL)flag;

//初始化app
-(void)initAppdelegate:(NSDictionary *)launchOptions newSelf:(id)newSelf;

- (void)setUpRootVC;

//添加全局通知
-(void)newAllNotification;

//检测app状态
-(void)appstoreUpdateVersion;

///检查网络
- (void)checkNetwork;
@end

NS_ASSUME_NONNULL_END
