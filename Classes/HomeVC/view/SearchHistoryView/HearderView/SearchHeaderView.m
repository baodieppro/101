//
//  SearchHeaderView.m
//  YYWMerchantSide
//
//  Created by ios on 2019/11/18.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "SearchHeaderView.h"

@interface SearchHeaderView ()
@property (nonatomic,strong) CAGradientLayer *gradient;
@end

@implementation SearchHeaderView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        [self setGSLayer];
        [self acceptanceNote];
    }
    return self;
}

- (void)setUpUI
{
    
    [self addSubview:self.searchButton];
    
//    [self.layer insertSublayer:self.gradient atIndex:0];
 
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, __kNewSize(0), 0, __kNewSize(0)));
        make.centerY.mas_equalTo(self).mas_offset(__kNewSize(20));
        make.height.mas_equalTo(__kNewSize(62));
    }];
   
}
-(void)setGSLayer{
    _gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor]colorWithAlphaComponent:0.4].CGColor,(id)[UIColor clearColor].CGColor,nil];
}
-(void)setGSLayerHide{
    
    _gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor clearColor].CGColor,nil];
}
#pragma mark - 接受通知
- (void)acceptanceNote
{
//    __kWeakSelf__;
//    [[NSNotificationCenter defaultCenter]addObserverForName:SHOWTOPTOOLVIEW object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        weakSelf.backgroundColor = [UIColor whiteColor];
//        _searchButton.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//        [weakSelf setGSLayerHide];
//    }];
//
//    [[NSNotificationCenter defaultCenter]addObserverForName:HIDETOPTOOLVIEW object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        weakSelf.backgroundColor = [UIColor clearColor];
//        _searchButton.backgroundColor = [[UIColor colorWithHexString:@"#ffffff"]colorWithAlphaComponent:0.85];
//        [weakSelf setGSLayer];
//    }];
}

-(BaseNewButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[BaseNewButton alloc]initWithFrame:CGRectZero StyleType:ImageLeftStyleType];
        _searchButton.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        _searchButton.imageView.image = [UIImage imageNamed:@"Search_pic"];
        _searchButton.sub_titleLabel.text = @"请输入";
        _searchButton.colorSubTitleText = [UIColor colorWithHexString:@"#777777"];
//        _searchButton.imageView.backgroundColor = [UIColor clearColor];
        _searchButton.subtitleFontSize = __kNewSize(13*2);
        _searchButton.imagLeft = __kNewSize(15);
        
//        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_searchButton setTitle:@"请输入" forState:0];
//        [_searchButton setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:0];
//        _searchButton.backgroundColor = [[UIColor colorWithHexString:@"#ffffff"]colorWithAlphaComponent:0.85];
//        _searchButton.titleLabel.font = UIFontOfSize(13);
//        [_searchButton setImage:[UIImage imageNamed:@"Search_pic"] forState:0];
//        [_searchButton adjustsImageWhenHighlighted];
//         _searchButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * 10, 0, 0);
//        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        //        _searchButton.frame = CGRectMake(__kNewSize(20), 28, __kScreenWidth__-__kNewSize(40), __kNewSize(56));
        _searchButton.layer.cornerRadius = __kNewSize(62)/2;
        
        
        //将多余的部分切掉
        _searchButton.layer.masksToBounds = YES;
    }
    return _searchButton;
}
-(CAGradientLayer *)gradient{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        
        _gradient.startPoint = CGPointMake(0, 0);
        
        _gradient.endPoint = CGPointMake(0, 1);
        
        _gradient.frame =CGRectMake(0, 0, __kScreenWidth__, __kNavigationBarHeight__);
        
        _gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor]colorWithAlphaComponent:0.4].CGColor,(id)[UIColor clearColor].CGColor,nil];
        
    }
    return _gradient;
}


@end
