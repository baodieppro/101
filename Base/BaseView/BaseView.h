//
//  BaseView.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView
- (UIViewController *)getCurrentVC;
-(void)presentViewController:(UIViewController *)vc isAnimated:(BOOL)animated;
-(void)pushViewController:(UIViewController *)vc isAnimated:(BOOL)animated;
-(void)pushBaseNavigationController:(UIViewController *)vc isAnimated:(BOOL)animated;
-(void)pushViewControllerName:(NSString *)vcName isAnimated:(BOOL)animated;
-(void)presentViewControllerName:(NSString *)vcName isAnimated:(BOOL)animated;

-(void)popToRootViewControllerAnimated:(BOOL)isAnimated;
-(void)popViewControllerAnimated:(BOOL)isAnimated;
-(void)popToViewController:(NSString *)vcName animated:(BOOL)animated;
#pragma mark - dismissVC
-(void)dismissVC;
-(void)dismissRooVC:(NSString *)vcName;
-(void)dismissRooVC;
@end

NS_ASSUME_NONNULL_END
