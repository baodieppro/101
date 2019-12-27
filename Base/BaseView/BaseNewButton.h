//
//  BaseNewButton.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/8.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger
{
    //无图片
    ImgaeNotStyleType = 0,
    //图片在左边
    ImageLeftStyleType = 1,
    //图片在右
    ImgaeRightStyleType = 2,
    //图片在上
    ImgaeTopStyleType = 3,
  
    
}
NewButtonStyleType;

@interface BaseNewButton : UIControl

@property (nonatomic , strong) UIImageView * imageView;
@property (nonatomic , strong) UILabel * titleLabel;
@property (nonatomic , strong) UILabel * sub_titleLabel;

@property (nonatomic ,assign) NewButtonStyleType nbStyleType;

@property (nonatomic ,assign) CGFloat titleFontSize;
@property (nonatomic ,assign) CGFloat subtitleFontSize;
@property (nonatomic ,assign) CGFloat imageRadius;//!<图片圆角
@property (nonatomic ,assign) CGFloat imagLeft;//图片距左间距


@property (nonatomic ,strong) UIColor * colorTitleText;
@property (nonatomic ,strong) UIColor * colorSubTitleText;

-(instancetype)initWithFrame:(CGRect)frame StyleType:(NewButtonStyleType) styleType;

@end

NS_ASSUME_NONNULL_END
