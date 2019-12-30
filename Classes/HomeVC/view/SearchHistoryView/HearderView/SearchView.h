//
//  SearchView.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/25.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchView : BaseView
@property (nonatomic,strong) UIButton * videoBtn;//!<视频弹窗按钮

@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UITextField * searchTextField;

#pragma mark - 是否显示视频窗口按钮
-(void)playVideoButtonIs:(BOOL)isHidVideo;
@end

NS_ASSUME_NONNULL_END
