//
//  CommodityTableViewCell.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "HistoryTableViewCell.h"
@implementation HistoryTableViewCell

-(void)setItmeModel:(HistoryItmeModel *)itmeModel{
    _itmeModel = itmeModel;
    _goodsNameLabel.text = itmeModel.h_name;
    _goodsPriceLabel.text = itmeModel.h_url;
    [self selectedBtnClick:itmeModel.isSeleted];
}

-(void)selectedBtnClick:(BOOL)selected
{
    if (selected == NO) {
        _selectImageView.image = [UIImage imageNamed:@"login_Choice-mol"];
    }else{
        _selectImageView.image = [UIImage imageNamed:@"login_Choice-sel"];
    }
}
-(void)setEditSelected:(BOOL)editSelected{
    _selectImageView.hidden = !editSelected;
}
- (void)setFrame:(CGRect)frame{
//    frame.origin.x += __kNewSize(5*2);
    frame.origin.y += __kNewSize(5*2);
    frame.size.height -= __kNewSize(5*2);
//    frame.size.width -= __kNewSize(30*2);
    [super setFrame:frame];
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
    [self addSubview:self.goodsImageView];
    [self addSubview:self.goodsNameLabel];
    [self addSubview:self.goodsPriceLabel];
//    [self addSubview:self.goodsStockLabel];
//    [self addSubview:self.splitLine];
    [self addSubview:self.selectImageView];
//    [self addSubview:self.goodsStatusButton];
//    [self addSubview:self.goodsShareButton];
//    self.selectImageView.hidden = YES;
}
-(void)cell_LayoutFrame{
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(30*2), __kNewSize(30*2)));
    }];
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.goodsImageView).mas_offset(-__kNewSize(15*2));
        make.left.mas_equalTo(self.goodsImageView.mas_right).mas_offset(__kNewSize(10*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
        make.height.mas_equalTo(__kNewSize(48*2));
    }];
    [_goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.goodsImageView.mas_bottom).mas_offset(__kNewSize(10*2));
        make.left.mas_equalTo(self.goodsNameLabel);
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
        make.height.mas_equalTo(__kNewSize(20*2));
    }];
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(17*2), __kNewSize(17*2)));
    }];
//    [_goodsStockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.goodsPriceLabel.mas_bottom);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
//        make.height.mas_equalTo(__kNewSize(16*2));
//    }];
//    [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.goodsImageView.mas_bottom).mas_offset(__kNewSize(10*2));
//        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(15*2), 0, __kNewSize(15*2)));
//        make.height.mas_equalTo(1);
//    }];
   
//    [_goodsStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.splitLine.mas_bottom).mas_offset(__kNewSize(10*2));
//        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
//        make.width.mas_equalTo(__kNewSize(70*2));
//        make.height.mas_equalTo(__kNewSize(30*2));
//    }];
//    [_goodsShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.goodsStatusButton);
//        make.right.mas_equalTo(self.goodsStatusButton.mas_left).mas_offset(-__kNewSize(10*2));
//        make.width.mas_equalTo(__kNewSize(70*2));
//        make.height.mas_equalTo(__kNewSize(30*2));
//    }];
}
#pragma mark - 懒加载
-(UIImageView *)goodsImageView{
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.layer.masksToBounds = YES;
        _goodsImageView.layer.cornerRadius = 2;
        _goodsImageView.backgroundColor = [UIColor redColor];
    }
    return _goodsImageView;
}
-(UILabel *)goodsNameLabel{
    if (!_goodsNameLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#515C6F"];
        label.text = @"美特斯邦威运动鞋男鞋经典复刻款新品上市夏季      ";
        _goodsNameLabel = label;
    }
    return _goodsNameLabel;
}
-(UILabel *)goodsPriceLabel{
    if (!_goodsPriceLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#FF7070"];
        _goodsPriceLabel = label;
    }
    return _goodsPriceLabel;
}
-(UILabel *)goodsStockLabel{
    if (!_goodsStockLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(12*2)];
        label.textColor = [UIColor colorWithHexString:@"#A8ADB7"];
        label.text = @"库存：560 / 总销量：63";
        _goodsStockLabel = label;
    }
    return _goodsStockLabel;
}
-(UILabel *)splitLine{
    if (!_splitLine) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor colorWithHexString:@"#DBD8D8"];
        _splitLine = label;
    }
    return _splitLine;
}
-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.image = [UIImage imageNamed:@"login_Choice-mol"];
    }
    return _selectImageView;
}
-(UIButton *)goodsStatusButton{
    if (!_goodsStatusButton) {
       UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(12*2)];
        [button setTitle:@"  上架  " forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#707070"] forState:UIControlStateNormal];
        button.layer.cornerRadius =2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        //        [button addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        _goodsStatusButton = button;
    }
    return _goodsStatusButton;
}
-(UIButton *)goodsShareButton{
    if (!_goodsShareButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(12*2)];
        [button setTitle:@"  分享  " forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#707070"] forState:UIControlStateNormal];
        button.layer.cornerRadius =2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        //        [button addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        _goodsShareButton = button;
    }
    return _goodsShareButton;
}
@end
