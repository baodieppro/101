//
//  HistoryView.h
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"
@protocol MyHistoryViewDelegate <NSObject>

- (void)mySelectAtIndexPath:(NSInteger)index itme:(NSString *_Nullable)itme;
- (void)mySelectAtIndexPathItmeUrl:(NSString *_Nullable)url;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HistoryView : BaseView
@property(nonatomic, assign) id<MyHistoryViewDelegate>delegate;
@property(nonatomic, strong) UIViewController * tagViewController;

@end

NS_ASSUME_NONNULL_END
