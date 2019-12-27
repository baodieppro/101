//
//  BaseCenterTipsView.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/29.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseCenterTipsView.h"

@implementation BaseCenterTipsView
+(void)showTipsCenterView:(UIView *)view title:(NSString *)title imageName:(NSString *)img;
{
    BaseCenterTipsView * isTipsView = (BaseCenterTipsView *)[view viewWithTag:1000001];
    if (!isTipsView) {
        BaseCenterTipsView * tipsView = [[BaseCenterTipsView alloc] init];
        tipsView.titleLabel.text = title;
        tipsView.imageView.image = [UIImage imageNamed:img];
        tipsView.tag = 1000001;
        tipsView.frame = CGRectMake(0, (view.frame.size.height - __kScreenWidth__)/2, __kScreenWidth__, __kScreenWidth__);
        [view addSubview:tipsView];
    }
}
+(void)removeTipsView:(UIView *)view{
    BaseCenterTipsView * tipsView = (BaseCenterTipsView *)[view viewWithTag:1000001];
    [tipsView removeFromSuperview];
    tipsView = nil;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
    }
    return self;
}

-(void)g_Init{

}
-(void)g_CreateUI{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}
-(void)g_LayoutFrame{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(20*2));
        make.centerX.mas_equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(__kNewSize(20*2));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(24*2));
    }];
}

#pragma mark - 懒加载
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:__kNewSize(17*2)];
        label.textColor = [UIColor colorWithHexString:@"#C4C4C4"];
        _titleLabel = label;
    }
    return _titleLabel;
}

@end
