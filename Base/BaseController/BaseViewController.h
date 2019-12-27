//
//  BaseViewController.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "BaseNavigationBar.h"

typedef enum : NSUInteger
{
    //popController
    popControllerType,
    //ToController
    UserCenterControllerType,
    //RootController
    RootControllerType,
}
popViewControllerType;
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
    
@property (nonatomic, assign) popViewControllerType popVCType;//!<Pop返回

@property (nonatomic,strong) BaseNavigationBar * _Nullable  baseNavigationBar;
@property (nonatomic, strong) BaseView * myView;//最底层的view
@property (nonatomic, strong) UIView* xian;//!<线
//导航栏名称
@property (nonatomic, strong) NSString * navigationTitle;//!<导航栏名称


- (void)createRightBarButtonWithTitle:(NSString *)titleName WithSelector:(SEL)selector;
- (void)createRightBarButtonWithImageName:(NSString *)imageName WithSelector:(SEL)selector;
- (void)createLeftBarButtonWithImageName:(NSString *)imageName WithSelector:(SEL)selector;

- (void)dismissRooVC;
- (void)dismissVC;
- (void)dismissVCsubtype:(NSString *)type;
- (void)dismissRooVC:(NSString *)vcName;

/*
 指定跳转的VC
 */
-(void)indexVCpop:(NSInteger)index;

/*
添加通知
*/
- (void)addNotification;
- (void)removeNotification;

- (void)loadDataNotification:(NSNotification *)notification;
- (void)endNotWorkNotification:(NSNotification *)notification;
- (void)statusNotWorkNotification:(NSNotification *)notification;


@end

NS_ASSUME_NONNULL_END
