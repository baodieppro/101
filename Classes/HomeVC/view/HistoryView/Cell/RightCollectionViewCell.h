//
//  RightCollectionViewCell.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyRightCollectionViewCellDelegate <NSObject>

- (void)mySelected_On_IndexItmeWithClick:(PlayCacheModel *_Nullable)model;
- (void)myDelete_itmeListCount:(NSInteger)deleteCount;

@end
NS_ASSUME_NONNULL_BEGIN

@interface RightCollectionViewCell : UICollectionViewCell
@property(nonatomic, assign) id<MyRightCollectionViewCellDelegate>delegate;

@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, assign) BOOL editSelected;//!<编辑
@property (nonatomic, assign) BOOL allSelected;//!<选择全部

-(void)reloadView;
-(void)delete_HitoryDataLoadView;

@end

NS_ASSUME_NONNULL_END
