//
//  CommodityManagerHeaderView.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/22.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "HistoryManagerHeaderView.h"
@interface HistoryManagerHeaderView ()
@property (nonatomic,assign) CGFloat btnWidth;
@end
@implementation HistoryManagerHeaderView

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
    self.btnWidth = (__kScreenWidth__-__kNewSize((80*2)*2))/2;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}
-(void)g_CreateUI{
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}
-(void)g_LayoutFrame{
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.btnWidth);
        make.height.mas_equalTo(self);
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(self.btnWidth);
        make.height.mas_equalTo(self);
    }];
}
#pragma mark - Click
-(void)leftClick:(UIButton *)btn{
    [self isSelectAtIndex:btn.selected];
}
-(void)rightClick:(UIButton *)btn{
    [self isSelectAtIndex:btn.selected];
}
-(void)isSelectAtIndex:(BOOL)isSelected{
    if (isSelected== YES) {
        //在售中
        [self myDelegateDidSelectAtIndexPath:0 itme:@"浏览历史"];
    }else{
        //仓库中
        [self myDelegateDidSelectAtIndexPath:1 itme:@"视频历史"];
    }
    [self setButtonStyle:isSelected];
//    _leftButton.selected = isSelected;
//    _rightButton.selected = !isSelected;
}
-(void)setButtonStyle:(BOOL)isSelected{
    if (isSelected== YES) {
        _leftButton.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        _rightButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"#3F88F4"] forState:UIControlStateNormal];
        
    }else{
        _leftButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _rightButton.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"#3F88F4"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    //    _leftButton.selected = isSelected;
    //    _rightButton.selected = !isSelected;
}
#pragma mark - 代理
-(void)myDelegateDidSelectAtIndexPath:(NSInteger)index itme:(NSString *_Nullable)itme{
    if ([self.delegate respondsToSelector:@selector(mydidSelectAtIndexPath:itme:)]) {
        [self.delegate mydidSelectAtIndexPath:index itme:itme];
    }
}
#pragma mark - UI
-(UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [_leftButton setTitle:@"浏览历史" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        _leftButton.layer.cornerRadius =46/2;
        [_leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.backgroundColor = [UIColor colorWithHexString:@"#3F88F4"];
        //        _leftButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        //        _leftButton.enabled = NO;
        //        [_leftButton setImage:[UIImage imageNamed:@"login_Login_Button"] forState:UIControlStateNormal];
        _leftButton.selected = YES;
    }
    return _leftButton;
}
-(UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [_rightButton setTitle:@"视频历史" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"#3F88F4"] forState:UIControlStateNormal];
        //        _rightButton.layer.cornerRadius =46/2;
        [_rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        //        _rightButton.backgroundColor = [UIColor colorWithHexString:@"#b4b4b4"];
        //        _rightButton.enabled = NO;
        //        [_rightButton setImage:[UIImage imageNamed:@"login_Login_Button"] forState:UIControlStateNormal];
        _rightButton.selected = NO;
    }
    return _rightButton;
}

@end
