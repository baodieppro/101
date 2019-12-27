//
//  GSActionSheet.h
//  爷爷网
//
//  Created by 巩小鹏 on 2019/5/16.
//  Copyright © 2019 GrandqaNet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GSActionSheet;

@protocol GSActionSheetDelegate <NSObject>
@optional

/**
 User click action sheet item
 
 @param actionSheet GSActionSheet object
 @param actionIndex action sheet index
 */
- (void)GSActionSheet:(GSActionSheet *)actionSheet actionAtIndex:(NSInteger)actionIndex;

/**
 User click action sheet cancel
 
 @param actionSheet GSActionSheet object
 */
- (void)GSActionSheetCanceld:(GSActionSheet *)actionSheet;

@end

@interface GSActionSheet : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<GSActionSheetDelegate> delegate;
@property (nonatomic, copy) NSString *actionSheetTitle;

/**
 The Action sheet initialization method
 
 @param title action sheet title
 @param delegate delegate
 @param actionTitles sheets
 @return GSActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title
                 withDelegate:(id)delegate
                 actionTitles:(NSString *)actionTitles, ...NS_REQUIRES_NIL_TERMINATION;

/**
 Add action with title to sheet
 
 @param title title
 @return the number of title index in sheet
 */
- (NSInteger)addActionWithTitle:(NSString *)title;

/**
 Show action sheet at parent view
 
 @param parentView the UIViewController's view
 */
- (void)showInView:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
