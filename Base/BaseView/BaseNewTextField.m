//
//  BaseNewTextField.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/13.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseNewTextField.h"

@implementation BaseNewTextField

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
    [self addSubview:self.userNameLable];
    [self addSubview:self.bodyTextField];
    [self addSubview:self.rightImageView];
}
-(void)g_LayoutFrame{
    [_userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(20));
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(15*2), 0, __kNewSize(15*2)));
        make.height.mas_equalTo(__kNewSize(22*2));
    }];
    [_bodyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLable.mas_bottom).mas_offset(__kNewSize(20));
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(15*2), 0, __kNewSize(15*2)));
        make.height.mas_equalTo(__kNewSize(34*2));
    }];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bodyTextField);
        make.right.mas_equalTo(self.bodyTextField.mas_right).mas_offset(__kNewSize(-12*2));
    }];
}
#pragma mark - 阴影
-(void)setTextFieldShadow:(BOOL)textFieldShadow{
    _textFieldShadow = textFieldShadow;
    if (textFieldShadow == YES) {
        _bodyTextField.layer.cornerRadius = 5;
        _bodyTextField.layer.shadowRadius = 6;
        _bodyTextField.layer.shadowOpacity = 1;
        _bodyTextField.layer.shadowOffset = CGSizeMake(0,2);
        _bodyTextField.layer.shadowColor = [UIColor colorWithRed:231/255.0 green:234/255.0 blue:240/255.0 alpha:1.0].CGColor;
    }
}
#pragma mark - UI

-(UILabel *)userNameLable{
    if (_userNameLable == nil) {
        _userNameLable = [[UILabel alloc]init];
        _userNameLable.textAlignment = NSTextAlignmentLeft;
        _userNameLable.font = [UIFont systemFontOfSize:__kNewSize(16*2)];
        _userNameLable.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _userNameLable;
}
-(UITextField *)bodyTextField{
    if (_bodyTextField == nil) {
        _bodyTextField = [[UITextField alloc]init];
        _bodyTextField.textAlignment = NSTextAlignmentLeft;
        _bodyTextField.font = [UIFont systemFontOfSize:__kNewSize(16*2)];
        _bodyTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _bodyTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
       
    }
    return _bodyTextField;
}
-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
//        _rightImageView.image = [UIImage imageNamed:@"icon_addbaby_more"];
    }
    return _rightImageView;
}

@end
