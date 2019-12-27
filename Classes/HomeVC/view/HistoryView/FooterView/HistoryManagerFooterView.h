//
//  HistoryManagerFooterView.h
//  GSDlna
//
//  Created by ios on 2019/12/12.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"
@protocol MyHistoryManagerFooterViewDelegate <NSObject>

- (void)mySelectAllClick:(BOOL)isAll;

- (void)myDeleteWithSelectAllClick;


@end
NS_ASSUME_NONNULL_BEGIN

@interface HistoryManagerFooterView : BaseView
@property(nonatomic, assign) id<MyHistoryManagerFooterViewDelegate>delegate;

@property (nonatomic,strong) UILabel * titleLabel;//!<已选
@property (nonatomic,strong) UILabel * numberLabel;//!<已选数量
@property (nonatomic,strong) UIButton * selectedBtn;//!<选择按钮
@property (nonatomic,strong) UIButton * completeBtn;//!<全部删除
@end

NS_ASSUME_NONNULL_END
