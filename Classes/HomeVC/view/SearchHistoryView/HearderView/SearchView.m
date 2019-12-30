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
    [self addSubview:self.videoBtn];
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
- (UIButton *)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBtn setTitle:@"小窗" forState:UIControlStateNormal];
        [_videoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _videoBtn.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        _videoBtn.titleEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
        UIImage *image = [UIImage imageNamed:@"window_small"];
        UIImageView *iconView = [[UIImageView alloc]initWithImage:image];
        iconView.frame = CGRectMake(__kNewSize(10), __kNewSize((50-30)/2), __kNewSize(30), __kNewSize(30));
        [_videoBtn addSubview:iconView];
        _videoBtn.layer.masksToBounds = YES;
        _videoBtn.layer.cornerRadius = 2.0f;
        _videoBtn.layer.borderWidth = __kNewSize(1);
        CGColorRef colorref = [UIColor colorWithHexString:@"#ffffff"].CGColor;
        [_videoBtn.layer setBorderColor:colorref];
        _videoBtn.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(24)];
     
        _videoBtn.hidden = YES;
    }
    return _videoBtn;
}
#pragma mark - 是否显示视频窗口按钮
-(void)playVideoButtonIs:(BOOL)isHidVideo{
    //yes：显示浮窗按钮
    if (isHidVideo == YES) {
        _videoBtn.hidden = NO;
        [_videoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).mas_offset(__kNewSize(20));
            make.left.equalTo(self).mas_offset(__kNewSize(20));
            make.size.mas_equalTo(CGSizeMake(__kNewSize(100), __kNewSize(50)));
        }];
        [_searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(130), 0, 0));
            make.centerY.mas_equalTo(self).mas_offset(__kNewSize(20));
            make.height.mas_equalTo(__kNewSize(62));
        }];
       
        
    }else{
        _videoBtn.hidden = YES;
        [_searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.centerY.mas_equalTo(self).mas_offset(__kNewSize(20));
            make.height.mas_equalTo(__kNewSize(62));
        }];
        
    }
}

@end
