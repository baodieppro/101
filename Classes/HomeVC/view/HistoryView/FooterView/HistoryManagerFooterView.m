//
//  HistoryManagerFooterView.m
//  GSDlna
//
//  Created by ios on 2019/12/12.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "HistoryManagerFooterView.h"

@implementation HistoryManagerFooterView

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
}
-(void)g_CreateUI{
    [self addSubview:self.selectedBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numberLabel];
    [self addSubview:self.completeBtn];
}
-(void)g_LayoutFrame{
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.left.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(17*2), __kNewSize(17*2)));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.left.mas_equalTo(self.selectedBtn.mas_right).mas_offset(__kNewSize(10*2));
        make.height.mas_equalTo(__kNewSize(19*2));
    }];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(__kNewSize(5*2));
        make.height.mas_equalTo(__kNewSize(19*2));
    }];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(10*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
        make.height.mas_equalTo(__kNewSize(30*2));
        make.width.mas_equalTo(__kNewSize(70*2));
    }];
}
#pragma mark - Delegate
-(void)myAllSelectedIs:(BOOL)isAll{
    if ([self.delegate respondsToSelector:@selector(mySelectAllClick:)]) {
        [self.delegate mySelectAllClick:isAll];
    }
}
#pragma mark - Click
-(void)selectedBtnClick:(UIButton *)btn
{
    if (btn.selected == NO) {
        [_selectedBtn setImage:[UIImage imageNamed:@"login_Choice-mol"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"login_Choice-sel"] forState:UIControlStateNormal];
    }
    [self myAllSelectedIs:btn.selected];
    btn.selected = !btn.selected;
}
-(void)deleteAllClick{
    if ([self.delegate respondsToSelector:@selector(myDeleteWithSelectAllClick)]) {
        [self.delegate myDeleteWithSelectAllClick];
    }
}

#pragma mark - 懒加载
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#3B3B3B"];
        label.text = @"已选";
        _titleLabel = label;
    }
    return _titleLabel;
}
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#FF7070"];
        label.text = @"0";
        _numberLabel = label;
    }
    return _numberLabel;
}
-(UIButton *)selectedBtn{
    if (_selectedBtn == nil) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"login_Choice-mol"] forState:UIControlStateNormal];
        //        _selectedBtn.userInteractionEnabled = NO;
        _selectedBtn.selected = YES;
        [_selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}

-(UIButton *)completeBtn{
    if (_completeBtn == nil) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        _completeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_completeBtn setTitle:@"全部删除" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor colorWithHexString:@"#707070"] forState:UIControlStateNormal];
        _completeBtn.layer.cornerRadius =2;
        _completeBtn.layer.borderWidth = 1;
        _completeBtn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        [_completeBtn addTarget:self action:@selector(deleteAllClick) forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.backgroundColor = [UIColor clearColor];
        //        _completeBtn.enabled = YES;
        //        [_completeBtn setImage:[UIImage imageNamed:@"login_Login_Button"] forState:UIControlStateNormal];
        
    }
    return _completeBtn;
}

@end
