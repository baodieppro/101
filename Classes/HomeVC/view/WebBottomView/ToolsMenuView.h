//
//  ToolsMenuView.h
//  GSDlna
//
//  Created by ios on 2019/12/26.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"

@protocol MyToolsMenuViewDelegate <NSObject>

- (void)myToolsMenuSelectedIndexItmeWithClick:(NSInteger)Type;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ToolsMenuView : BaseView
@property(nonatomic, assign) id<MyToolsMenuViewDelegate>delegate;

+ (ToolsMenuView *)menu;

-(void)show;
-(void)dismiss;
-(void)isFavorite:(BOOL)isF;

@end

NS_ASSUME_NONNULL_END
