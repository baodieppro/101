//
//  BaseNavigationBar.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationBar : UIView
@property (nonatomic,strong) NSArray* leftBarButtons;
@property (nonatomic,strong) NSArray* rightBarButtons;
@property (nonatomic,strong) UIView* centerView;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,strong) UILabel* subTitleLabel;
@property (nonatomic,assign) BOOL isHidden;
- (void)setBarHidden:(BOOL)isHidden;
@end

NS_ASSUME_NONNULL_END
