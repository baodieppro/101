//
//  DownloadView.h
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadView : BaseView
-(void)gs_ViewDidAppear;
@property(nonatomic, strong) UIViewController * tagViewController;

@end

NS_ASSUME_NONNULL_END
