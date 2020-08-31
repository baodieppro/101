//
//  HistoryViewController.h
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseViewController.h"
@protocol MyHistoryViewControllerDelegate <NSObject>

- (void)myHistoryRloadViewWithUrl:(NSString *_Nullable)url;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController : BaseViewController
@property(nonatomic, assign) id<MyHistoryViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
