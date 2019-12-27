//
//  LetfCollectionViewCell.h
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyLeftCollectionViewCellDelegate <NSObject>

- (void)mySelected_Under_IndexItmeWithClick:(HistoryItmeModel *_Nullable)model;

- (void)myDelete_itmeListCount:(NSInteger)deleteCount;


@end
NS_ASSUME_NONNULL_BEGIN

@interface LeftCollectionViewCell : UICollectionViewCell
@property(nonatomic, assign) id<MyLeftCollectionViewCellDelegate>delegate;

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, assign) BOOL editSelected;//!<编辑
@property (nonatomic, assign) BOOL allSelected;//!<选择全部

-(void)reloadView;
-(void)delete_HitoryDataLoadView;

@end

NS_ASSUME_NONNULL_END
