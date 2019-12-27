//
//  GSTableView.h
//  爷爷网
//
//  Created by 巩小鹏 on 2019/5/26.
//  Copyright © 2019 GrandqaNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSTableView;
@protocol GSTableViewDelegate <NSObject>
@required

- (NSInteger)gs_tableView:(GSTableView *_Nullable)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *_Nullable)gs_tableView:(GSTableView *_Nullable)tableView cellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;


@optional
- (CGFloat)gs_tableView:(GSTableView *_Nullable)tableView heightForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;
-(void)gs_tableView:(GSTableView *_Nullable)tableView didSelectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;
- (UITableViewCell *_Nullable)gs_tableView:(GSTableView *_Nullable)tableView cellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath LastCellIndex:(NSIndexPath *_Nullable)LastCellIndex;
- (NSInteger)gs_numberOfSectionsInTableView:(GSTableView *_Nonnull)tableView;
- (CGFloat)gs_tableView:(GSTableView *_Nullable)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)gs_tableView:(GSTableView *_Nullable)tableView heightForFooterInSection:(NSInteger)section;
-(UIView *_Nullable)gs_tableView:(GSTableView *_Nullable)tableView viewForHeaderInSection:(NSInteger)section;
- (void)gs_tableView:(GSTableView *_Nullable)tableView willDisplayCell:(UITableViewCell *_Nullable)cell forRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

@end
NS_ASSUME_NONNULL_BEGIN
@interface GSTableView : UITableView

@property(nonatomic, assign) id<GSTableViewDelegate> GSDelegate;

-(void)layerbottom:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
