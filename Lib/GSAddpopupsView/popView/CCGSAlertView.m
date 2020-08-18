//
//  CCGSAlertView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "CCGSAlertView.h"
#import "GSAddpopupsView.h"

typedef void(^completeAlert)(NSInteger code);//1:确定 0:取消

@interface CCGSAlertView ()

@property (nonatomic,strong) GSAddpopupsView * gsAddpopupsView;
@property (nonatomic,strong) UILabel * titleLable;
@property (nonatomic,strong) UILabel * subtitleLable;
@property (nonatomic,strong) UIButton * determineButton;
@property (nonatomic,strong) UIButton * cancelButton;
@property(nonatomic, strong) completeAlert blockAlert;

@end
@implementation CCGSAlertView

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
    
    self.frame = CGRectMake((__kScreenWidth__ - __kNewSize(290*2))/2, (__kScreenHeight__ - __kNewSize(174*2))/2, __kNewSize(290*2), __kNewSize(174*2));
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor whiteColor];
}
-(void)g_CreateUI{
    [self addSubview:self.titleLable];
    [self addSubview:self.subtitleLable];
    [self addSubview:self.determineButton];
    [self addSubview:self.cancelButton];
}
-(void)g_LayoutFrame{
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(__kNewSize(20*2), __kNewSize(15*2), 0, __kNewSize(15*2)));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(25*2));
    }];
    [_subtitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLable.mas_bottom).mas_offset(__kNewSize(4*2));
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(15*2), 0, __kNewSize(15*2)));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(60*2));
    }];
    [_determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-__kNewSize(20*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(100*2), __kNewSize(36*2)));
    }];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-__kNewSize(20*2));
        make.left.mas_equalTo(self.mas_left).mas_offset(__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(100*2), __kNewSize(36*2)));
    }];
}
#pragma mark - 公共方法
-(void)customInitWithTitle:(NSString *)title
                  subTitle:(NSString *)subtitle
                   sureBtn:(NSString *)sureTitle
                 cancleBtn:(NSString *)cancleTitle
                  Complete:(void (^)(NSInteger))complete
{
    if (title) {
        self.titleLable.text = title;

    }else{
        self.titleLable.hidden = YES;

    }
    if (subtitle) {
        self.subtitleLable.text = subtitle;

    }else{
        self.subtitleLable.hidden = YES;

    }
    if (sureTitle) {
        [_determineButton setTitle:sureTitle forState:UIControlStateNormal];

    }
    if (cancleTitle) {
        [_cancelButton setTitle:cancleTitle forState:UIControlStateNormal];
    }
    self.blockAlert = ^(NSInteger code) {
        complete(code);
    };
}

#pragma mark -Click
-(void)determineClick{
    if (self.blockAlert) {
        self.blockAlert(1);
    }
    [self dismiss];
}
-(void)cancelClick{
    if (self.blockAlert) {
        self.blockAlert(0);
    }
    [self dismiss];
}
#pragma mark - UI
-(GSAddpopupsView *)gsAddpopupsView{
    if (!_gsAddpopupsView) {
        _gsAddpopupsView = [[GSAddpopupsView alloc] initWithCustomView:self popStyle:GSAnimationPopStyleScale dismissStyle:GSAnimationDismissStyleScale newStyle:GSAnimationPopStyleTapYes];
        _gsAddpopupsView.popBGAlpha = 0.5f;
        _gsAddpopupsView.isClickBGDismiss = YES;
    }
    return _gsAddpopupsView;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"标题";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont boldSystemFontOfSize:__kNewSize(18*2)];
        // 文字颜色
        label.textColor = [UIColor blackColor];
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 22;
//        label.layer.borderWidth =1.0f;
//        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleLable = label;
    }
    return _titleLable;
}
-(UILabel *)subtitleLable{
    if (!_subtitleLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 4;
        // 内容
        label.text = @"副标题";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        // 文字颜色
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 22;
//        label.layer.borderWidth =1.0f;
//        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _subtitleLable = label;
    }
    return _subtitleLable;
}
-(UIButton *)determineButton{
    if (!_determineButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:7/255.0 green:189/255.0 blue:68/255.0 alpha:1.0];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
//        button.layer.borderWidth =1.0f;
//        button.layer.borderColor = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:84/255.0 alpha:1.0].CGColor;
        [button addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
        _determineButton = button;
    }
    return _determineButton;
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:7/255.0 green:189/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
        button.layer.borderWidth =1.0f;
        button.layer.borderColor = [UIColor colorWithRed:7/255.0 green:189/255.0 blue:68/255.0 alpha:1.0].CGColor;
        [button addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}
#pragma mark - 公共方法
- (void)showPop{
    [self.gsAddpopupsView pop];
}
-(void)dismiss{
    [self.gsAddpopupsView dismiss];
    [self removeFromSuperview];
}
+(void)show{
    CCGSAlertView * popview = [[CCGSAlertView alloc] init];
    [popview showPop];
}
#pragma mark - 公共方法
+(void)initWithTitle:(NSString *)title
            subTitle:(NSString *)subtitle
            sureBtn:(NSString *)sureTitle
            cancleBtn:(NSString *)cancleTitle
            Complete:(void (^)(NSInteger))complete;
{
    CCGSAlertView * popview = [[CCGSAlertView alloc] init];
    [popview customInitWithTitle:title subTitle:subtitle sureBtn:sureTitle cancleBtn:cancleTitle Complete:complete];
    [popview showPop];

}
@end
