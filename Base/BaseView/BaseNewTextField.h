//
//  BaseNewTextField.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/13.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseNewTextField : BaseView
/**
 *  标题名
 */
@property (nonatomic,strong) UILabel *userNameLable;
/**
 *  右侧箭头
 */
@property (nonatomic,strong) UIImageView * rightImageView;
/**
 *  右侧内容
 */
@property (nonatomic,strong) UITextField * bodyTextField;

@property (nonatomic,assign) BOOL  textFieldShadow; //!< yes: 打开阴影 No：关闭

@end

NS_ASSUME_NONNULL_END
