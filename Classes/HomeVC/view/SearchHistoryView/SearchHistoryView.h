//
//  SearchHistoryView.h
//  GSDlna
//
//  Created by ios on 2019/12/12.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"
@protocol MySearchHistoryViewDelegate <NSObject>

- (void)mySelectedIndexItmeWithClick:(NSString *_Nullable)keyword;

@end
NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryView : BaseView
@property(nonatomic, assign) id<MySearchHistoryViewDelegate>delegate;

@property (nonatomic,strong) UIButton  * cancelBtn;//!<取消
@property (nonatomic,strong) UIButton  * removeSearchAllBtn;//!<清空历史

@end

NS_ASSUME_NONNULL_END
