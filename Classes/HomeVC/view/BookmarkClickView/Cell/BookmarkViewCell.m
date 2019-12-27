//
//  BookmarkViewCell.m
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BookmarkViewCell.h"

@implementation BookmarkViewCell
-(void)setItmeModel:(BookMarkCacheModel *)itmeModel{
    _titleLabel.text = itmeModel.title;
    _urlLabel.text = itmeModel.url;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cell_AddUI];
        [self cell_LayoutFrame];
        
    }
    return self;
}
-(void)cell_AddUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.urlLabel];
}
-(void)cell_LayoutFrame{
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.top.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(20, 20, 0, 20));
        make.height.mas_equalTo(__kNewSize(48*2));
    }];
    [_urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(__kNewSize(10*2));
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(__kNewSize(20*2));
    }];
}
#pragma 懒加载
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#515C6F"];
        label.text = @"美特斯邦威运动鞋男鞋经典复刻款新品上市夏季      ";
        _titleLabel = label;
    }
    return _titleLabel;
}
-(UILabel *)urlLabel{
    if (!_urlLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#FF7070"];
        _urlLabel = label;
    }
    return _urlLabel;
}

@end
