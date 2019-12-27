//
//  WebBottomView.m
//  GSDlna
//
//  Created by ios on 2019/12/18.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "WebBottomView.h"
#import "BaseNewButton.h"

@interface WebBottomView ()
@property (strong , nonatomic)UIView *topXian;//!<线
@property (strong , nonatomic)BaseNewButton *goBackButton;//!<上一页
@property (strong , nonatomic)BaseNewButton *goForwardButton;//!<下一页
@property (strong , nonatomic)BaseNewButton *bookMarkButton;//!<书签
@property (strong , nonatomic)BaseNewButton *homeButton;//!<首页

@end

@implementation WebBottomView
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
    self.frame = CGRectMake(0, 0, __kScreenWidth__, __TabBarH__);
    self.backgroundColor = [UIColor whiteColor];
}
-(void)g_CreateUI{
    [self addSubview:self.topXian];
    [self addSubview:self.goBackButton];
    [self addSubview:self.bookMarkButton];
    [self addSubview:self.goForwardButton];
    [self addSubview:self.homeButton];
}
-(void)g_LayoutFrame{
    
    CGFloat itmeCount = 4;
    CGFloat spaceWidth = 10;
    CGFloat itmeWidth = (__kScreenWidth__-(spaceWidth*(itmeCount+1)))/itmeCount;
    
    [_topXian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(1);
    }];
    [_goBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(4));
        make.left.mas_equalTo(self).mas_offset(spaceWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(itmeWidth);
    }];
    [_goForwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(4));
        make.left.mas_equalTo(self.goBackButton.mas_right).mas_offset(spaceWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(itmeWidth);

    }];
    [_bookMarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(4));
        make.left.mas_equalTo(self.goForwardButton.mas_right).mas_offset(spaceWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(itmeWidth);

    }];
    [_homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(4));
        make.right.mas_equalTo(self).mas_offset(-spaceWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(itmeWidth);

    }];
    
}
#pragma mark - 懒加载
-(UIView *)topXian{
    if (!_topXian) {
        _topXian = [[UIView alloc]init];
        _topXian.backgroundColor = [UIColor colorWithHexString:@"#777777"];
    }
    return _topXian;
}
-(BaseNewButton *)goBackButton{
    if (!_goBackButton) {
        _goBackButton = [[BaseNewButton alloc]initWithFrame:CGRectZero StyleType:ImgaeTopStyleType];
        _goBackButton.backgroundColor = [UIColor clearColor];
        _goBackButton.imageView.image = [UIImage imageNamed:@"home_1"];
        _goBackButton.sub_titleLabel.text = @"上一页";
        _goBackButton.colorSubTitleText = [UIColor colorWithHexString:@"#777777"];
        //        _searchButton.imageView.backgroundColor = [UIColor clearColor];
        _goBackButton.subtitleFontSize = __kNewSize(8*2);
//        _goBackButton.imagLeft = __kNewSize(15);
        [_goBackButton addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBackButton;
}
-(BaseNewButton *)bookMarkButton{
    if (!_bookMarkButton) {
        _bookMarkButton = [[BaseNewButton alloc]initWithFrame:CGRectZero StyleType:ImgaeTopStyleType];
        _bookMarkButton.backgroundColor = [UIColor clearColor];
        _bookMarkButton.imageView.image = [UIImage imageNamed:@"home_3"];
        _bookMarkButton.sub_titleLabel.text = @"菜单";
        _bookMarkButton.colorSubTitleText = [UIColor colorWithHexString:@"#777777"];
        //        _searchButton.imageView.backgroundColor = [UIColor clearColor];
        _bookMarkButton.subtitleFontSize = __kNewSize(8*2);
        //        _goBackButton.imagLeft = __kNewSize(15);
         [_bookMarkButton addTarget:self action:@selector(favoriteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookMarkButton;
}
-(BaseNewButton *)homeButton{
    if (!_homeButton) {
        _homeButton = [[BaseNewButton alloc]initWithFrame:CGRectZero StyleType:ImgaeTopStyleType];
        _homeButton.backgroundColor = [UIColor clearColor];
        _homeButton.imageView.image = [UIImage imageNamed:@"home_4"];
        _homeButton.sub_titleLabel.text = @"首页";
        _homeButton.colorSubTitleText = [UIColor colorWithHexString:@"#777777"];
        //        _searchButton.imageView.backgroundColor = [UIColor clearColor];
        _homeButton.subtitleFontSize = __kNewSize(8*2);
        //        _goBackButton.imagLeft = __kNewSize(15);
        [_homeButton addTarget:self action:@selector(homeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeButton;
}
-(BaseNewButton *)goForwardButton{
    if (!_goForwardButton) {
        _goForwardButton = [[BaseNewButton alloc]initWithFrame:CGRectZero StyleType:ImgaeTopStyleType];
        _goForwardButton.backgroundColor = [UIColor clearColor];
        _goForwardButton.imageView.image = [UIImage imageNamed:@"home_2_2"];
        _goForwardButton.sub_titleLabel.text = @"下一页";
        _goForwardButton.colorSubTitleText = [UIColor colorWithHexString:@"#777777"];
        //        _searchButton.imageView.backgroundColor = [UIColor clearColor];
        _goForwardButton.subtitleFontSize = __kNewSize(8*2);
        //        _goBackButton.imagLeft = __kNewSize(15);
         [_goForwardButton addTarget:self action:@selector(forwardClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goForwardButton;
}
#pragma mark - Click
-(void)gobackClick{
    [self setDelegate_Click:GoBackStyleType];
}
-(void)favoriteClick{
    [self setDelegate_Click:FavoriteStyleType];
}
-(void)forwardClick{
    [self setDelegate_Click:GoForwardStyleType];
}
-(void)homeClick{
    [self setDelegate_Click:HomeStyleType];
}
#pragma mark - 代理实现
-(void)setDelegate_Click:(WebBottomViewStyleType)Type
{
    if ([self.delegate respondsToSelector:@selector(mySelectedIndexItmeWithClick:)]) {
        [self.delegate mySelectedIndexItmeWithClick:Type];
    }
}
#pragma mark - 公共方法

@end
