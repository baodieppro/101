//
//  DlnaTableViewCell.m
//  GSPlay
//
//  Created by Roger on 2019/9/11.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import "DlnaTableViewCell.h"

@implementation DlnaTableViewCell

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self d_Init];
        [self d_createUI];
        [self d_layoutFrame];
    }
    return self;
}
-(void)d_Init{
    self.layer.cornerRadius = 40/2;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.35];
}
-(void)d_createUI{
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLable];
}
-(void)d_layoutFrame{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(16);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(14);
        make.size.mas_equalTo(CGSizeMake(202, 20));
    }];
}
#pragma mark - UI
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"icon_tv_s2l"];
//        _iconImageView.layer.masksToBounds = YES;
//        _iconImageView.layer.cornerRadius = 20;
//        _iconImageView.layer.borderWidth = 1;
//        _iconImageView.layer.borderColor=[UIColor whiteColor].CGColor;
//        _iconImageView.backgroundColor = [UIColor redColor];
    }
    return _iconImageView;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.font = [UIFont systemFontOfSize:13];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLable;
}

@end
