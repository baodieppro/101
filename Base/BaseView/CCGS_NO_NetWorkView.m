//
//  CCGS_NO_NetWorkView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/16.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "CCGS_NO_NetWorkView.h"
@interface CCGS_NO_NetWorkView ()
{
    BOOL isVerticalOrHorizontal;
}
@property (nonatomic,strong) UIImageView * topImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *rloadButton;
@property (nonatomic,strong) UIButton *pushSetButton;

@end
@implementation CCGS_NO_NetWorkView

+(void)showNetWorkView:(UIView *)newView{
    CCGS_NO_NetWorkView * netView = [[CCGS_NO_NetWorkView alloc]init];
    [newView addSubview:netView];
}
+(void)reomveNewWorkView:(UIView*)newView{

}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self isOrientation];
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
    }
    return self;
}
-(void)isOrientation{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    NSLog(@"windowOrientation:%ld",orientation);
    if (orientation == UIInterfaceOrientationPortrait) {
        isVerticalOrHorizontal = YES;
    }
    
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        isVerticalOrHorizontal = NO;
    }
}
-(void)g_Init{
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}
-(void)g_CreateUI{
    [self addSubview:self.topImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rloadButton];
    [self addSubview:self.pushSetButton];
    if (isVerticalOrHorizontal == NO) {
        [self addSubview:self.backButton];
    }

}
-(void)g_LayoutFrame{
    if (isVerticalOrHorizontal == YES) {
    
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).mas_offset(__kNewSize(190*2));
            make.size.mas_equalTo(CGSizeMake(__kNewSize(140*2), __kNewSize(140*2)));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.topImageView.mas_bottom).mas_offset(__kNewSize(15));
            make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
            make.height.mas_equalTo(23);
        }];
        [_rloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(6);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
        [_pushSetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.rloadButton.mas_bottom).mas_offset(40);
            make.size.mas_equalTo(CGSizeMake(124, 44));
        }];
    }else{
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(__kNewSize(40));
            make.left.mas_equalTo(self).mas_offset(__kNewSize(40));
        }];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).mas_offset(60);
            make.size.mas_equalTo(CGSizeMake(140, 140));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.topImageView.mas_bottom).mas_offset(__kNewSize(15));
            make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
            make.height.mas_equalTo(23);
        }];
        [_rloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
        [_pushSetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.rloadButton.mas_bottom).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(124, 44));
        }];
    }
   
}

#pragma mark - UI
-(UIImageView *)topImageView{
    if (!_topImageView) {
        UIImageView * imageview = [[UIImageView alloc]init];
        imageview.image = [UIImage imageNamed:@"img_home_nonet"];
        imageview.backgroundColor = [UIColor clearColor];
//        imageview.layer.masksToBounds = YES;
//        imageview.layer.cornerRadius = 40;
        
        _topImageView = imageview;
    }
    return _topImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 对齐方式
        label.text = @"网络加载失败";
        label.textAlignment =  NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.numberOfLines = 2;
        _titleLabel = label;
    }
    return _titleLabel;
}
-(UIButton *)rloadButton{
    if (!_rloadButton) {
        _rloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rloadButton setTitle:@"请点击重试" forState:UIControlStateNormal];
        [_rloadButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _rloadButton.backgroundColor = [UIColor clearColor];
        _rloadButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rloadButton addTarget:self action:@selector(rloadClick) forControlEvents:UIControlEventTouchUpInside];
//        _leftButton.layer.cornerRadius = 44/2;
//        _leftButton.layer.borderWidth = 1;
//        _leftButton.layer.borderColor = [UIColor colorWithHexString:@"#FFD454"].CGColor;
    }
    return _rloadButton;
}
-(UIButton *)pushSetButton{
    if (!_pushSetButton) {
        _pushSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushSetButton setTitle:@"去设置" forState:UIControlStateNormal];
        [_pushSetButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _pushSetButton.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        [_pushSetButton addTarget:self action:@selector(pushSetClick) forControlEvents:UIControlEventTouchUpInside];
        _pushSetButton.layer.cornerRadius = 44/2;
    }
    return _pushSetButton;
}
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_subject_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}
#pragma mark - CLick
-(void)rloadClick{
    GSLog(@"刷新重试");
}
-(void)pushSetClick{
    [[GSLAlertView alertManager] createInitWithTitle:@"请在iPhone的设置页面中打开网络" message:@"请手动前往设置页面，谢谢" sureBtn:@"确定" cancleBtn:nil];
    [[GSLAlertView alertManager] showGSAlertView];
}

@end
