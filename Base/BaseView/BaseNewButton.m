//
//  BaseNewButton.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/8.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseNewButton.h"
@interface BaseNewButton ()



@end
@implementation BaseNewButton


-(instancetype)initWithFrame:(CGRect)frame StyleType:(NewButtonStyleType) styleType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nbStyleType = styleType;
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
    }
    return self;
}

-(void)g_Init{

}
-(void)g_CreateUI{
    if(self.nbStyleType == ImgaeNotStyleType){
        [self addSubview:self.titleLabel];
    }else{
        [self addSubview:self.imageView];
    }
    [self addSubview:self.sub_titleLabel];

}
-(void)g_LayoutFrame{
    switch (self.nbStyleType) {
        case ImgaeNotStyleType:
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self);
                make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 6, 0, 6));
                make.height.mas_equalTo(__kNewSize(25*2));
            }];
            
            [_sub_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(__kNewSize(6));
                make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 6, 0, 6));
                make.height.mas_equalTo(__kNewSize(25*2));
            }];
            
        }
            break;
        case ImgaeTopStyleType:
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self);
                make.centerX.mas_equalTo(self);
            }];
            [_sub_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(0);
                make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 6, 0, 6));
                make.height.mas_equalTo(__kNewSize(12*2));
            }];
        }
            break;
        case ImageLeftStyleType:
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(self);
                
            }];
            [_sub_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(self.imageView.mas_right).mas_offset(__kNewSize(6*2));
//                make.right.mas_equalTo(self.mas_right).mas_offset(__kNewSize(-15));
                make.height.mas_equalTo(__kNewSize(25*2));
            }];
        }
            break;
        case ImgaeRightStyleType:
        {
            [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(self);
                
            }];
            [_sub_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(self.imageView.mas_left).mas_offset(-__kNewSize(6*2));
                make.height.mas_equalTo(__kNewSize(25*2));
            }];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - set 配置

-(void)setTitleFontSize:(CGFloat)titleFontSize{
    _titleFontSize = titleFontSize;
    _titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
}
-(void)setSubtitleFontSize:(CGFloat)subtitleFontSize{
    _subtitleFontSize = subtitleFontSize;
    _sub_titleLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
}
-(void)setColorTitleText:(UIColor *)colorTitleText{
    _colorTitleText = colorTitleText;
    _titleLabel.textColor = colorTitleText;
}
-(void)setColorSubTitleText:(UIColor *)colorSubTitleText{
    _colorSubTitleText = colorSubTitleText;
    _sub_titleLabel.textColor = colorSubTitleText;
}
-(void)setImageRadius:(CGFloat)imageRadius{
    _imageRadius = imageRadius;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = imageRadius/2;
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(imageRadius, imageRadius));
    }];
}
-(void)setImagLeft:(CGFloat)imagLeft{
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(imagLeft);
    }];
}
#pragma mark - 懒加载

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [self newLabel];
    }
    return _titleLabel;
}

-(UILabel *)sub_titleLabel{
    if (!_sub_titleLabel) {
        _sub_titleLabel = [self newLabel];
    }
    return _sub_titleLabel;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView * imageview = [[UIImageView alloc]init];
//        imageview.backgroundColor = [UIColor redColor];
        imageview.userInteractionEnabled = NO;
        _imageView = imageview;
    }
    return _imageView;
}

-(UILabel *)newLabel{
    UILabel * label = [[UILabel alloc]  init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:__kNewSize(18*2)];
    return label;
}



@end






