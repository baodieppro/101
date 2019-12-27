//
//  WebViewController.h
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : BaseViewController
@property(nonatomic,strong) NSString *titleNavi;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *html;
@end

NS_ASSUME_NONNULL_END
