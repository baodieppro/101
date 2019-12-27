//
//  CCWeChatpopView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/21.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 成功或失败
 */
typedef NS_ENUM(NSInteger, GSPopType) {
    GSPopDefaultType = 0,               //!<默认
    GSPopSuccessType ,               ///<!<成功
    GSPopErrorType ,               ///!<失败

};
typedef void(^BindWeChatComplete)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface CCWeChatpopView : UIView

@property (nonatomic,strong) UIImageView * iconImageView;//!<
@property (nonatomic,strong) UILabel * titleLabel;//!<
@property (nonatomic,strong) UILabel * sub_titleLabel;//!<
@property (nonatomic,strong) UIButton * bindWeChatButton;//!<绑定微信
@property (nonatomic,strong) UIButton * loginButton;//!<切换账号

@property (nonatomic, assign) GSPopType popType;//!<
/** 绑定微信 */
@property (nonatomic,copy) BindWeChatComplete bindWeChatComplete; //!<0:绑定微信 1:去登陆

@property (nonatomic,strong) NSString * errorMag;//!<

+(void)createrView:(GSPopType)type errorMag:(NSString *)errormsg Complete:(void (^)(NSInteger clickType))complete;

-(instancetype)initWithFrame:(CGRect)frame;

/**
 显示弹框
 */
- (void)showPop;

/**
 移除弹框
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
