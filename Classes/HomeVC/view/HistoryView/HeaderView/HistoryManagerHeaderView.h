//
//  CommodityManagerHeaderView.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseView.h"
@protocol MyHistoryManagerHeaderViewDelegate <NSObject>

- (void)mydidSelectAtIndexPath:(NSInteger)index itme:(NSString *_Nullable)itme;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HistoryManagerHeaderView : BaseView
@property(nonatomic, assign) id<MyHistoryManagerHeaderViewDelegate>delegate;

@property (nonatomic,strong) UIButton * leftButton;//!<左边的按钮
@property (nonatomic,strong) UIButton * rightButton;//!<右边的按钮

-(void)setButtonStyle:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
