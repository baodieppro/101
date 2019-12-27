//
//  SearchHistoryCell.m
//  GSDlna
//
//  Created by ios on 2019/12/12.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell
-(void)setItmeModel:(SearchHistoryItmeModel *)itmeModel{
    _historyTitleLabel.text = itmeModel.keyword;
    if([GSRegular justURlSite:itmeModel.keyword] == YES){
        _historyImage.image = [UIImage imageNamed:@"ico_web"];
    }else{
        _historyImage.image = [UIImage imageNamed:@"ico_glass"];
    }
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
    [self addSubview:self.historyImage];
    [self addSubview:self.historyTitleLabel];
    [self addSubview:self.historyShang];
    [self addSubview:self.xianSearchCell];
}
-(void)cell_LayoutFrame{
    [_historyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(20*2), __kNewSize(20*2)));
    }];
    [_historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.historyImage.mas_right).mas_offset(__kNewSize(10*2));
        make.right.mas_equalTo(self.historyShang.mas_left).mas_offset(__kNewSize(15*2));
        make.height.mas_equalTo(__kNewSize(48*2));
    }];
    [_historyShang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(__kNewSize(15));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(120), __kNewSize(122)));
    }];
    [_xianSearchCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(15), 0, __kNewSize(15)));
        make.height.mas_equalTo(__kNewSize(2));
    }];
}
#pragma mark - 懒加载
-(UIButton *)historyShang{
    
    if (!_historyShang) {
        _historyShang = [UIButton buttonWithType:UIButtonTypeSystem];
//        _historyShang.layer.cornerRadius =  __kNewSize(24)/2;
        //        _historyShang.tag = indexPath.row+10000;
        [_historyShang setImage:[[UIImage imageNamed:@"ico_spread"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    }
    
    return _historyShang;
}

-(UIImageView *)historyImage{
    if (!_historyImage) {
        _historyImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _historyImage.image = [UIImage imageNamed:@"ico_web"];
    }
    return _historyImage;
}
-(UILabel *)historyTitleLabel{
    if (!_historyTitleLabel) {
        _historyTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _historyTitleLabel.font = [UIFont systemFontOfSize:__kNewSize(28)];
        _historyTitleLabel.textColor = [UIColor blackColor];
        //        _historyTitleLabel.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        _historyTitleLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _historyTitleLabel;
}

-(UIView *)xianSearchCell{
    if (!_xianSearchCell) {
        _xianSearchCell = [[UIView alloc]init];
//        _xianSearchCell.frame = CGRectMake(__kNewSize(30), self.frame.size.height-__kNewSize(1), __kScreenWidth__, __kNewSize(1));
        //        _xianSearchCell.jsonTheme.backgroundColor(@"ident9");
        _xianSearchCell.backgroundColor = [UIColor colorWithHexString:@"#c6c6c6"];
        
    }
    return _xianSearchCell;
}
@end
