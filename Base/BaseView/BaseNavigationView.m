//
//  BaseNavigationView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/18.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "BaseNavigationView.h"
@interface BaseNavigationView ()



@end
@implementation BaseNavigationView

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
-(void)setTopheight:(CGFloat)topheight{
    _topheight = topheight;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(topheight);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [_backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self).mas_offset(StatusBarHeight);
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(20);
        //        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
-(void)g_Init{
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,__kNavigationBarHeight__);

}
-(void)g_CreateUI{
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];

}
-(void)g_LayoutFrame{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(StatusBarHeight);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self).mas_offset(StatusBarHeight);
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(20);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
   
}
#pragma mark - UI

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor blackColor];
//        label.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 46/2;
//        label.text = @"选择课程";
        _titleLabel = label;
    }
    return _titleLabel;
}
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_pic"] forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
@end
