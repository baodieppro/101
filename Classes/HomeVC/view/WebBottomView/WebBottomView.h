//
//  WebBottomView.h
//  GSDlna
//
//  Created by ios on 2019/12/18.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
typedef enum : NSUInteger
{
    //上一页
    GoBackStyleType = 0,
    //收藏
    FavoriteStyleType = 1,
    //下一页
    GoForwardStyleType = 2,
    //首页
    HomeStyleType = 3
}
WebBottomViewStyleType;

@protocol MyWebBottomViewDelegate <NSObject>

- (void)mySelectedIndexItmeWithClick:(WebBottomViewStyleType)Type;

@end

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebBottomView : BaseView
@property(nonatomic, assign) id<MyWebBottomViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
