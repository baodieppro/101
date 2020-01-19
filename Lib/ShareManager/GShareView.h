//
//  GShareView.h
//  ToolscreenShot
//
//  Created by 巩小鹏 on 2018/9/17.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger
{
    //正常分享展示
    ShareViewType,
    
    //截屏分享展示
    ShareScreenshotsType
    
}
ShareViewPlatformType;


typedef enum : NSUInteger
{
    //QQ聊天页面
    QQ_ShareType,
    //qq空间
    Qzone_ShareType,
    //微信朋友圈
    WechatTimeLine_ShareType,
    //微信聊天
    WechatSession_ShareType,
    //Sina新浪
    Sina_ShareType,
    //失败
    error_ShareType
    
}
ShareClickType;

typedef  void (^ShareBlock)(ShareClickType shareClickType);

@interface GShareView : UIView

//=================================================================
@property (nonatomic,assign) BOOL isShow;//!<正在展示
@property (nonatomic,assign) BOOL isQQ;//!<QQ
@property (nonatomic,assign) BOOL isWX;//!<微信
@property (nonatomic,assign) BOOL isSina;//!<新浪
//=================================================================

@property (nonatomic, assign) ShareViewPlatformType shareType;//!<分享展示页样式
@property (nonatomic,strong) UIImageView * screenShotsImage;//截屏图片

@property (nonatomic,copy) ShareBlock  shareBlock;


+ (GShareView *)newShare;
- (void)show;

@end
