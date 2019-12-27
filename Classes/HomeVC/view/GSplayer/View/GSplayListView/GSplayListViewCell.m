//
//  GSplayListViewCell.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/15.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSplayListViewCell.h"
@interface GSplayListViewCell ()
@property (nonatomic,strong) UILabel * currentLabel;//!<当前
@property (nonatomic,strong) UIImageView * centerImageView;//!<
@property (nonatomic,strong) UIImageView * iconImageView;//!<
@property (nonatomic,strong) UILabel * progressLabel;//!<当前进度
@property (nonatomic,strong) UILabel * titleLabel;//!<素材名称

@end
@implementation GSplayListViewCell

static NSString *cellID = @"GSplayListViewCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    GSplayListViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell  = [[GSplayListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.selected = NO;
        //        self.userInteractionEnabled = NO;
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)g_Init{
    
}
-(void)g_CreateUI{
    [self addSubview:self.centerImageView];
    [_centerImageView addSubview:self.currentLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.progressLabel];
    [self addSubview:self.titleLabel];
}
-(void)g_LayoutFrame{
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.size.mas_equalTo(CGSizeMake(130, 74));
    }];
    [_currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerImageView);
        make.left.mas_equalTo(self.centerImageView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerImageView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.mas_equalTo(18);
    }];
}
#pragma mark -填充数据
-(void)setCurrentLabelAlpha_PlayListIndex:(NSInteger)alpha{
    _currentLabel.alpha = alpha;
}

#pragma mark - UI
-(UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init];
        _centerImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _centerImageView.layer.cornerRadius = 10;
        _centerImageView.layer.masksToBounds = YES;
        _centerImageView.image = [UIImage imageNamed:@"img_popup_pretermit"];
    }
    return _centerImageView;
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"素材名称";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:12];
        // 文字颜色
        label.textColor = [UIColor whiteColor];
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = __kNewSize(22);
//        label.layer.borderWidth =1.0f;
//        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleLabel =label;
    }
    return _titleLabel;
}
-(UILabel *)currentLabel{
    if (!_currentLabel) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        // 内容
        label.text = @"当前";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:12];
        // 文字颜色
        label.textColor = [UIColor colorWithHexString:@"#673A1B"];
        label.alpha = 0;
//        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        _currentLabel = label;
    }
    return _currentLabel;
}
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"0%";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:12];
        // 文字颜色
        label.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _progressLabel = label;
    }
    return _progressLabel;
}

@end
