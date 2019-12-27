//
//  BaseTabBarController.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger ,BaseTabBarControllerType){
    YYWTabBarControllerHome = 0,  //首页
    YYWTabBarControllerLoans = 1,  //贷款
    YYWTabBarControllerInformation = 2, //资讯
    YYWTabBarControllerMyCenter = 3, //我的
};
NS_ASSUME_NONNULL_BEGIN
@interface BaseTabBarController : UITabBarController
/* 控制器type */
@property (assign , nonatomic)BaseTabBarControllerType tabVcType;
@end

NS_ASSUME_NONNULL_END
