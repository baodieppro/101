//
//  SetViewCell.m
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/29.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "SetViewCell.h"
#import "MySwitch.h"

@interface SetViewCell ()<MySwitchDelegate>
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) MySwitch * switchBtn;

@end
@implementation SetViewCell
-(void)setConfigModel:(SetPlistModel *)configModel{
    _configModel = configModel;
    _titleLabel.text = configModel.title;
    _switchBtn.OnStatus = ![configModel.isSel boolValue];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cell_AddUI];
        [self cell_LayoutFrame];
        
    }
    return self;
}
-(void)cell_AddUI{

    [self addSubview:self.titleLabel];
    [self addSubview:self.switchBtn];
//    __kWeakSelf__
//     _switchBtn.myBlock = ^(BOOL OnStatus) {
//         [weakSelf switchAction];
//     };
}
-(void)cell_LayoutFrame{
    __kWeakSelf__
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.mas_left).mas_offset(20);
        
    }];
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf.mas_right).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(__kNewSize(60), __kNewSize(30)));
    }];
}
#pragma mark - 懒加载
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(30)];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.text = @"";
        _titleLabel = label;
    }
    return _titleLabel;
}
-(MySwitch *)switchBtn{
    if (!_switchBtn) {
       _switchBtn = [[MySwitch alloc] initWithFrame:CGRectMake(0, 0, __kNewSize(62), __kNewSize(30)) withGap:0];
//        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"Settings_icon_toggle_on"]];
        [_switchBtn setLeftBlockImage:[UIImage imageNamed:@"Settings_icon_toggle_off"]];
        [_switchBtn setRightBlockImage:[UIImage imageNamed:@"Settings_icon_toggle_on"]];
        _switchBtn.selectedLeftColor = [UIColor colorWithHexString:@"#CCCCCC"];
        _switchBtn.selectedRightColor = [UIColor colorWithHexString:@"#F1720F"];
        _switchBtn.delegate = self;
    }
    return _switchBtn;
}
- (void)onStatusDelegate{
    if ([self.delegate respondsToSelector:@selector(mySelectClickWithModel:)]) {
        [self.delegate mySelectClickWithModel:_configModel];
    }
}

@end
