//
//  DLNABottomView.m
//  GSPlay
//
//  Created by Roger on 2019/9/11.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import "DLNABottomView.h"
@interface DLNABottomView ()
@property (nonatomic,strong) UILabel * titleLable;//!<
@property (nonatomic,strong) UILabel * oneLable;//!<
@property (nonatomic,strong) UILabel * twoLable;//!<
@end
@implementation DLNABottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self d_Init];
        [self d_createUI];
        [self d_layoutFrame];
    }
    return self;
}

-(void)d_Init{
    
}
-(void)d_createUI{
    [self addSubview:self.titleLable];
    [self addSubview:self.oneLable];
    [self addSubview:self.twoLable];
}
-(void)d_layoutFrame{
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(15*2));
        make.left.mas_equalTo(self).mas_offset(0);
    }];
    [_oneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLable.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(self.titleLable);
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(30*2));
        make.height.mas_equalTo(__kNewSize(30*2));
    }];
    [_twoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oneLable.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.titleLable);
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(30*2));
        make.height.mas_equalTo(__kNewSize(30*2));
    }];
}
#pragma mark - UI
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.font = [UIFont systemFontOfSize:__kNewSize(13*2)];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.text =@"投屏帮助";
    }
    return _titleLable;
}
- (UILabel *)oneLable
{
    if (!_oneLable) {
        _oneLable = [[UILabel alloc] init];
        _oneLable.textColor = [UIColor whiteColor];
        _oneLable.font = [UIFont systemFontOfSize:__kNewSize(13*2)];
//        _oneLable.textAlignment = NSTextAlignmentLeft;
        _oneLable.numberOfLines = 2;
        _oneLable.text = @"1.将手机/Ipad和智能电视/盒子保持同网络连接";
    }
    return _oneLable;
}
- (UILabel *)twoLable
{
    if (!_twoLable) {
        _twoLable = [[UILabel alloc] init];
        _twoLable.textColor = [UIColor whiteColor];
        _twoLable.font = [UIFont systemFontOfSize:__kNewSize(13*2)];
//        _twoLable.textAlignment = NSTextAlignmentLeft;
        _twoLable.numberOfLines = 2;
        _twoLable.text = @"2.点击TV按钮，搜索到设备后选择电视完成投屏";
    }
    return _twoLable;
}
@end
