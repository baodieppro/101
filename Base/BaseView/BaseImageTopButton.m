//
//  BaseImageTopButton.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/24.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "BaseImageTopButton.h"

@implementation BaseImageTopButton

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
    
}
-(void)g_CreateUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
}
-(void)g_LayoutFrame{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(20));
        make.centerX.mas_equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(2);
        make.centerX.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
   
}
-(void)titleTopOffset:(CGFloat)offset{
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(offset);
        make.centerX.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UI
-(UIImageView *)imageView{
    if (!_imageView){
        UIImageView *imageview = [[UIImageView alloc]init];
//        imageview.image = [UIImage imageNamed:@"icon_subject_more"];
        imageview.userInteractionEnabled = NO;
        _imageView = imageview;
    }
    return _imageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:__kNewSize(11*2)];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel = label;
    }
    return _titleLabel;
}


@end
