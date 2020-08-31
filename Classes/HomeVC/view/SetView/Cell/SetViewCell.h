//
//  SetViewCell.h
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/29.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MySetViewCellDelegate <NSObject>

- (void)mySelectClickWithModel:(SetPlistModel *)model;

@end
@interface SetViewCell : UITableViewCell
@property(nonatomic, assign) id<MySetViewCellDelegate>delegate;

@property (nonatomic, strong) SetPlistModel * configModel;

@end

NS_ASSUME_NONNULL_END
