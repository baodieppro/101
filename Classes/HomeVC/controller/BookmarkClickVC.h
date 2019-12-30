//
//  BookmarkClickVC.h
//  GSDlna
//
//  Created by ios on 2019/12/18.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "SubViewController.h"
@protocol MyBookmarkVCDelegate <NSObject>

- (void)myBookmarkVCRloadViewWithUrl:(NSString *_Nullable)url;

@end
NS_ASSUME_NONNULL_BEGIN

@interface BookmarkClickVC : SubViewController
@property(nonatomic, assign) id<MyBookmarkVCDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
