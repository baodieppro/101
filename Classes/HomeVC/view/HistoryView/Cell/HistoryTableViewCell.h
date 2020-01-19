//
//  CommodityTableViewCell.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryItmeModel;
NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * goodsImageView;//!<商品图片
@property (nonatomic,strong) UIImageView * selectImageView;//!<选择按钮
@property (nonatomic,strong) UILabel * goodsNameLabel;//!<商品名称
@property (nonatomic,strong) UILabel * goodsPriceLabel;//!<商品价格
@property (nonatomic,strong) UILabel * goodsStockLabel;//!<商品库存和销量
@property (nonatomic,strong) UIButton * goodsStatusButton;//!<商品状态 （上架或下架）
@property (nonatomic,strong) UIButton * goodsShareButton;//!<分享商品
@property (nonatomic,strong) UILabel * splitLine;//!<分割线

@property (nonatomic,strong) HistoryItmeModel * itmeModel;//!<数据映射

@property (nonatomic, assign) BOOL editSelected;//!<编辑
@property (nonatomic, assign) BOOL isLefOrRight;//!<左边还是右边


@end

NS_ASSUME_NONNULL_END
