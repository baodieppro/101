//
//  BookmarkViewCell.h
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookmarkViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * titleLabel;//!<名字
@property (nonatomic,strong) UILabel * urlLabel;//!<url
@property (nonatomic,strong) UIImageView * rightImageView;//!<默认

@property (nonatomic,strong) BookMarkCacheModel * itmeModel;//!<数据映射

@end

NS_ASSUME_NONNULL_END
