//
//  BaseCenterTipsView.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/29.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN
@interface BaseCenterTipsView : BaseView
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * titleLabel;

+(void)showTipsCenterView:(UIView *)view title:(NSString *)title imageName:(NSString *)img;
+(void)removeTipsView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
