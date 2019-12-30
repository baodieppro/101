//
//  BookmarkClickView.h
//  GSDlna
//
//  Created by ios on 2019/12/18.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"
@protocol MyBookmarkClickViewDelegate <NSObject>

- (void)mySelectedIndexItmeWithUrl:(NSString *_Nullable)url;

@end
NS_ASSUME_NONNULL_BEGIN

@interface BookmarkClickView : BaseView
@property(nonatomic, assign) id<MyBookmarkClickViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
