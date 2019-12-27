//
//  GSLoadingView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/12.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSLoadingView.h"
@interface GSLoadingView ()
@property (nonatomic, strong) UIImageView *activityIndicator;
@end
@implementation GSLoadingView
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
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    self.hidden = YES;
}
-(void)g_CreateUI{
    
}
-(void)g_LayoutFrame{
    
}
#pragma mark - 懒加载
- (UIImageView *)activityIndicator
{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_tv_loading1"]];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_activityIndicator];
        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.height.mas_equalTo(__kNewSize(150*2));
        }];
    }
    return _activityIndicator;
}

// 模拟官方 重写setter方法 控件隐藏时暂停动画
- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;
    if (hidesWhenStopped) {
        self.activityIndicator.hidden = YES;
        [self stopAnimating];
    } else {
        self.activityIndicator.hidden = NO;
        [self startAnimating];
    }
}

// 开始动画
- (void)startAnimating
{
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    anim.fromValue = [NSNumber numberWithFloat:.0f];
//    anim.toValue = [NSNumber numberWithFloat:M_PI * 2];
//    anim.duration = 1.f;
//    anim.autoreverses = NO;
//    anim.fillMode = kCAFillModeForwards;
//    anim.repeatCount = MAXFLOAT;
//    [self.activityIndicator.layer addAnimation:anim forKey:nil];
    
    if(self.activityIndicator.hidden == NO){
        [_activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.height.mas_equalTo(__kNewSize(150*2));
        }];
        self.hidden = NO;
        self.alpha = 1;
        self.activityIndicator.hidden = NO;
        self.activityIndicator.center = self.center;
        UIImageView *imageView = self.activityIndicator;
        
        NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:2];
        for (int i = 0; i<2; i++) {
            NSString *imageStr = [NSString stringWithFormat:@"img_tv_loading%d",i + 1];
            UIImage *image = [UIImage imageNamed:imageStr];
            [imageArr addObject:image];
        }
        imageView.animationImages = imageArr;
        imageView.animationDuration = 0.2f;
        [imageView startAnimating];
    }
    
}

// 动画结束
- (void)stopAnimating
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.hidden = YES;
    self.alpha = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
//        make.width.height.mas_equalTo(50);
    }];
}

@end
