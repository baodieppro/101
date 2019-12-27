//
//  SearchViewController.h
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseVerticalViewController.h"
@protocol MySearchViewControllerDelegate <NSObject>

- (void)mySearchWithKeyWord:(NSString *_Nullable)keyword;

@end
NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : BaseVerticalViewController
@property(nonatomic, assign) id<MySearchViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
