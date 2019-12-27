//
//  GSNewButton.m
//  GSPlay
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//
#define __kWeakSelf__ __weak typeof(self) weakSelf = self;

#import "GSNewButton.h"

@implementation GSNewButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self m_UI];
        [self m_frame];
    }
    return self;
}

-(void)m_initWithIcon:(NSString *)img titleM:(NSString *)title color:(NSString *)colorStr
{
    _iconMB.image = [UIImage imageNamed:img];
    _titleMB.text = title;
    if (colorStr != nil) {
//        _titleMB.textColor = [UIColor colorWithHexString:colorStr];
    }
}

-(void)m_UI{
    
    [self addSubview:self.iconMB];
    [self addSubview:self.titleMB];
    
}

-(void)m_frame{
    __kWeakSelf__;
    [_iconMB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.centerX.mas_equalTo(weakSelf).mas_offset((-30));
        make.size.mas_equalTo(CGSizeMake((60),(60)));
    }];
    [_titleMB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.iconMB.mas_right).mas_offset((20));
        
    }];
}
#pragma mark - 初始化UI

-(UIImageView *)iconMB{
    if (!_iconMB) {
        _iconMB = [[UIImageView alloc]init];
        //        _iconMB.userInteractionEnabled = YES;
        _iconMB.layer.masksToBounds = YES;
        _iconMB.layer.cornerRadius = 2;
//        _iconMB.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
    return _iconMB;
}
-(UILabel *)titleMB{
    if (_titleMB == nil) {
        _titleMB = [[UILabel alloc]init];
        _titleMB.font =[UIFont systemFontOfSize:12];
        _titleMB.textAlignment = NSTextAlignmentCenter;
//        _titleMB.textColor = [UIColor colorWithHexString:@"#363636"];
        //        _titleMB.userInteractionEnabled = YES;
        
    }
    return _titleMB;
}
@end
