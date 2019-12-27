//
//  SearchHistoryCell.h
//  GSDlna
//
//  Created by ios on 2019/12/12.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryCell : UITableViewCell
@property (nonatomic,strong) UIButton * historyShang;//!<传值到搜索框
@property (nonatomic,strong) UILabel * historyTitleLabel;//!<搜索历史内容
@property (nonatomic,strong) UIImageView * historyImage;//!<搜索历史内容
/**
 *  底部线
 */
@property (nonatomic,strong) UIView * xianSearchCell;
@property (nonatomic,strong) SearchHistoryItmeModel * itmeModel;

@end

NS_ASSUME_NONNULL_END
