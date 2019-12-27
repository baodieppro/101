//
//  PlayViewController.h
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseHorizontalViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayViewController : BaseHorizontalViewController
@property (nonatomic,assign) PlayStyleType playStyle;
@property (nonatomic,strong) NSString * playUrl;
@property (nonatomic,strong) NSString * topName;

@end

NS_ASSUME_NONNULL_END
