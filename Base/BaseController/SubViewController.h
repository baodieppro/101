//
//  SubViewController.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/21.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubViewController : BaseViewController
@property (nonatomic,strong) NSString * naviTitle;
@property (nonatomic, strong) UIButton *backButton;//!<返回按钮

-(void)backVC_Click;

@end

NS_ASSUME_NONNULL_END
