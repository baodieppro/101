//
//  CCWeChatpopView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/21.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "CCWeChatpopView.h"
#import "GSAddpopupsView.h"
@interface CCWeChatpopView ()
@property (nonatomic,strong) GSAddpopupsView * gsAddpopupsView;

@end
@implementation CCWeChatpopView

-(void)setPopType:(GSPopType)popType{
    _popType = popType;
}
- (void)showPop{
    [self g_CreateUI:self.popType];
    [self g_LayoutFrame:self.popType];
    [self setPopStyleType:self.popType];
    [self.gsAddpopupsView pop];
}
-(void)dismiss{
    [self.gsAddpopupsView dismiss];
    [self removeFromSuperview];
}



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
    }
    return self;
}

-(void)g_Init{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 30;
}
-(void)g_CreateUI{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sub_titleLabel];
    [self addSubview:self.bindWeChatButton];
    [self addSubview:self.loginButton];
}
-(void)g_LayoutFrame{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_top).mas_offset(0);

    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(4);
        make.centerX.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.mas_equalTo(30);
    }];
    [_sub_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(12);
        make.centerX.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.mas_equalTo(30);
    }];
    [_bindWeChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sub_titleLabel.mas_bottom).mas_offset(6);
        make.centerX.mas_equalTo(self);
    }];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bindWeChatButton.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self);
    }];
    
}

-(void)g_CreateUI:(GSPopType)type{
    switch (type) {
        case GSPopDefaultType:
        {

        }
            break;
        case GSPopSuccessType:
        {
            [self.bindWeChatButton removeFromSuperview];
//            self.frame = CGRectMake((__kScreenWidth__ - __kSize(280))/2, (__kScreenHeight__ - __kSize(160))/2, __kSize(280), __kSize(160));
        }
            break;
        case GSPopErrorType:
        {
            if (!kStringIsEmpty(self.errorMag)) {
                self.sub_titleLabel.text = self.errorMag;
            }else{
                [self.sub_titleLabel removeFromSuperview];
            }

        }
            break;
        default:
            break;
    }
   
}
-(void)g_LayoutFrame:(GSPopType)type{
   
    switch (type) {
        case GSPopDefaultType:
        {
           
        }
            break;
        case GSPopSuccessType:
        {
            [_sub_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(12);
                make.centerX.mas_equalTo(self);
                make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
                make.height.mas_equalTo(20);
            }];
        }
            break;
        case GSPopErrorType:
        {
            if (!kStringIsEmpty(self.errorMag)) {
                [_bindWeChatButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.sub_titleLabel.mas_bottom).mas_offset(6);
                    make.centerX.mas_equalTo(self);
                }];
                
            }else{
                [_bindWeChatButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
                    make.centerX.mas_equalTo(self);
                }];
                
            }
            
        }
            break;
        default:
            break;
    }
   
    
}
-(void)setPopStyleType:(GSPopType)type{
    switch (type) {
        case GSPopDefaultType:
        {
//            _iconImageView.alpha = 0;
        }
            break;
        case GSPopSuccessType:
        {
            _iconImageView.image = [UIImage imageNamed:@"img_popup_smile"];
            _titleLabel.text = @"恭喜你授权成功";
            _sub_titleLabel.text = @"恭喜你授权成功";
        }
            break;
        case GSPopErrorType:
        {
            _iconImageView.image = [UIImage imageNamed:@"img_popup_sad"];
            _titleLabel.text = @"授权失败，请重新授权";

        }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.image = [UIImage imageNamed:@"img_popup_wechat"];
        //        _iconImageView.clipsToBounds = YES;
        //        _iconImageView.layer.cornerRadius = 15;
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
//        label.text = @"完成微信授权即可";
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 1.0;
        label.font = [UIFont systemFontOfSize:22];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UILabel *)sub_titleLabel
{
    if (!_sub_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 2;
//        label.text = @"完成微信授权即可";
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 1.0;
        label.font = [UIFont systemFontOfSize:12];
        _sub_titleLabel = label;
    }
    return _sub_titleLabel;
}
-(UIButton *)bindWeChatButton{
    if (!_bindWeChatButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_popup_wechat"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bindWeChatClick) forControlEvents:UIControlEventTouchUpInside];
        _bindWeChatButton = button;
    }
    return _bindWeChatButton;
}
-(UIButton *)loginButton{
    if (!_loginButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_popup_switch"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton = button;
    }
    return _loginButton;
}
-(GSAddpopupsView *)gsAddpopupsView{
    if (!_gsAddpopupsView) {
        _gsAddpopupsView = [[GSAddpopupsView alloc] initWithCustomView:self popStyle:GSAnimationPopStyleScale dismissStyle:GSAnimationDismissStyleScale newStyle:GSAnimationPopStyleTapYes];
        _gsAddpopupsView.popBGAlpha = 0.5f;
        _gsAddpopupsView.isClickBGDismiss = YES;
    }
    return _gsAddpopupsView;
}
#pragma mark Click
-(void)bindWeChatClick{
    [self dismiss];
    if (self.bindWeChatComplete) {
        self.bindWeChatComplete(0);
    }
}
-(void)loginClick{
    [self dismiss];
    if (self.bindWeChatComplete) {
        self.bindWeChatComplete(1);
    }
}
#pragma mark -
+(void)createrView:(GSPopType)type errorMag:(nonnull NSString *)errormsg Complete:(nonnull void (^)(NSInteger))complete{
    CCWeChatpopView * weChat = [[CCWeChatpopView alloc] initWithFrame:CGRectMake((__kScreenWidth__ - __kSize(280))/2, (__kScreenHeight__ - __kSize(246))/2, __kSize(280), __kSize(246))];
    [weChat setPopType:type];
    weChat.errorMag = errormsg;
    [weChat showPop];
    weChat.bindWeChatComplete = ^(NSInteger index) {
        complete(index);
    };
    
}
@end
