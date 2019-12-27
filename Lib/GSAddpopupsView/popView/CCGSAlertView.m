//
//  CCGSAlertView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "CCGSAlertView.h"

@implementation CCGSAlertView

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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 30;
}
-(void)g_CreateUI{
    [self addSubview:self.titleLable];
    [self addSubview:self.subtitleLable];
    [self addSubview:self.determineButton];
    [self addSubview:self.cancelButton];
}
-(void)g_LayoutFrame{
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(__kNewSize(20*2), __kNewSize(20*2), 0, __kNewSize(20*2)));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(25*2));
    }];
    [_subtitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(__kNewSize(60*2), __kNewSize(20*2), 0, __kNewSize(20*2)));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(25*2));
    }];
    [_determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleLable.mas_bottom).mas_offset(__kNewSize(20*2));
        make.left.mas_equalTo(self.mas_left).mas_offset(__kNewSize(35*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(90*2), __kNewSize(44*2)));
    }];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleLable.mas_bottom).mas_offset(__kNewSize(20*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(35*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(90*2), __kNewSize(44*2)));
    }];
}
#pragma mark - 公共方法
-(void)customInitWithTitle:(NSString *)title subTitle:(NSString *)subtitle Complete:(void (^)(NSInteger))complete;
{
    self.titleLable.text = title;
    self.subtitleLable.text = subtitle;
    self.blockAlert = ^(NSInteger code) {
        complete(code);
    };
}

#pragma mark -Click
-(void)determineClick{
    if (self.blockAlert) {
        self.blockAlert(1);
    }
}
-(void)cancelClick{
    if (self.blockAlert) {
        self.blockAlert(0);
    }
}
#pragma mark - UI
-(UILabel *)titleLable{
    if (!_titleLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"标题";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont boldSystemFontOfSize:__kNewSize(18*2)];
        // 文字颜色
        label.textColor = [UIColor blackColor];
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 22;
//        label.layer.borderWidth =1.0f;
//        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleLable = label;
    }
    return _titleLable;
}
-(UILabel *)subtitleLable{
    if (!_subtitleLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"副标题";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        // 文字颜色
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 22;
//        label.layer.borderWidth =1.0f;
//        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _subtitleLable = label;
    }
    return _subtitleLable;
}
-(UIButton *)determineButton{
    if (!_determineButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:255/255.0 green:212/255.0 blue:84/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = __kNewSize(44*2)/2;
        button.layer.borderWidth =1.0f;
        button.layer.borderColor = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:84/255.0 alpha:1.0].CGColor;
        [button addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
        _determineButton = button;
    }
    return _determineButton;
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:84/255.0 alpha:1.0];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = __kNewSize(44*2)/2;
        [button addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

@end
