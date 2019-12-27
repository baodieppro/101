//
//  SearchView.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/25.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

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
    [self addSubview:self.searchTextField];
}
-(void)g_LayoutFrame{
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.centerY.mas_equalTo(self).mas_offset(__kNewSize(20));
        make.height.mas_equalTo(__kNewSize(62));
    }];
}

#pragma mark - 懒加载
-(UITextField *)searchTextField{
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.textAlignment = NSTextAlignmentLeft;
        _searchTextField.font = [UIFont systemFontOfSize:__kNewSize(13*2)];
        _searchTextField.textColor = [UIColor colorWithHexString:@"#777777"];
        _searchTextField.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kNewSize(54), __kNewSize(44))];
        [leftView addSubview:self.leftImageView];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.layer.cornerRadius = __kNewSize(62)/2;
        _searchTextField.keyboardType = UIKeyboardTypeDefault;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeAlways;

        //将多余的部分切掉
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.placeholder = @"请输入";
    }
    return _searchTextField;
}
-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(__kNewSize(10*2), __kNewSize(22)/2, __kNewSize(22),__kNewSize(22))];
        _leftImageView.image = [UIImage imageNamed:@"Search_pic"];
    }
    return _leftImageView;
}

@end
