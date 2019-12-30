//
//  Config.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#ifndef Config_h
#define Config_h

//=========================================================================================================
/******************      LOG          *************/

#ifdef DEBUG
#define GSLog(format,...) printf("\n[%s] %s [第%d行] %s\n",__TIME__,__FUNCTION__,__LINE__,[[NSString stringWithFormat:format,## __VA_ARGS__] UTF8String]);
#else
#define GSLog(format, ...)
#endif
//=========================================================================================================
/******************      常用系统方法          *************/
#define __kAppDelegate__ ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define __keyWindow__ ((UIWindow*)[UIApplication sharedApplication].keyWindow)

#define iPhoneX_New (__kScreenHeight__ > 812.0 ? YES :NO )

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

//获取当前版本号
#define BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//通知
#define NOTIFCATIONCENTER ((NSNotificationCenter *)[NSNotificationCenter defaultCenter])

//获取Window
#define SCREEN_KEY_WINDOW [UIApplication sharedApplication].keyWindow

//获取UIApplication
#define APPDELE ((AppDelegate *)([UIApplication sharedApplication].delegate))

//userDefaults
#define DEFAULTS ((NSUserDefaults *)[NSUserDefaults standardUserDefaults])

//userDefaults取值
#define USER_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

//userDefaults存值
#define USER_SETOBJ(obj,key) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];\
[[NSUserDefaults standardUserDefaults]synchronize]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \|| [_object isKindOfClass:[NSNull class]] \|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


//=========================================================================================================
//判断是不是ipad
#define ISIPAD [[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad
/******************      适配          *************/
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define SafeBottomMargin (iPhoneX ? 34.f : 0.f) //下边安全距离

//#define StatusBarHeight (__kScreenHeight__ >= 812.0 ? 44 :20)
#define iPhoneX (StatusBarHeight == 44)
#define __kNavigationBarHeight__ (StatusBarHeight + 44.0f)

#define __TabBarH__ (iPhoneX ? 83 : 49)
#define ToolbarHeight self.navigationController.toolbar.frame.size.height

#define __kScreenHeight__ [[UIScreen mainScreen] bounds].size.height
#define __kScreenWidth__ [[UIScreen mainScreen] bounds].size.width
//屏幕系数（iPhone）
#define ScreenWidthCoefficient   (__kScreenWidth__ / 375)
#define ScreenHeightCoefficient  (__kScreenHeight__ / 667)

//#define __kNavigationBarHeight__  NavigationBarHeight
#define __kContentHeight__ (__kScreenHeight__-__kNavigationBarHeight__-__kTabBarHeight__)
#define __kOriginalHeight__ (__kScreenHeight__-__kNavigationBarHeight__)
#define __kTabBarFrame__ CGRectMake(0, __kScreenHeight__-__kTabBarHeight__, __kScreenWidth__, __kTabBarHeight__)
#define __kTabBarHeight__ __TabBarH__

//=========================================================================================================
/******************      Font          *************/

#define UIFontOfSize(__PARA)    [UIFont systemFontOfSize:__PARA]
#define UIBoldFontOfSize(__PARA)    [UIFont boldSystemFontOfSize:__PARA]
#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];
//=========================================================================================================
/******************      TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"
//===========================================================================================================

#define __kWeakSelf__ __weak typeof(self) weakSelf = self;
#define __kStrongSelf__ __strong typeof(self) srongSelf = weakSelf;

//===========================================================================================================
//取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y
//===========================================================================================================

#define rgbaColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define rgbColor(n) rgbaColor(n,n,n,1)
#define GlobalBGColor [UIColor colorWithHexString:@"#F0F4F7"]

#endif /* Config_h */
