//
//  DownloadCell.m
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell
- (void)setFrame:(CGRect)frame{
    //    frame.origin.x += __kNewSize(5*2);
    frame.origin.y += __kNewSize(5*2);
    frame.size.height -= __kNewSize(5*2);
    //    frame.size.width -= __kNewSize(30*2);
    [super setFrame:frame];
}
-(void)setDownLoadModel:(Download_FMDBDataModel *)downLoadModel{
    _downLoadModel = downLoadModel;
    _titleLabel.text = downLoadModel.title;
    if ([downLoadModel.isDown integerValue] == 1) {
        _urlLabel.text = @"100%";
        [_loadedView setProgress:1 animated:NO];
        _startButton.hidden = YES;
    }else{
        [_startButton setTitle:@"暂停" forState:UIControlStateNormal];
        _startButton.selected = NO;

    }

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
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.urlLabel];
    [self addSubview:self.startButton];
    [self addSubview:self.loadedView];

}
-(void)cell_LayoutFrame{
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(__kNewSize(0));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(0), __kNewSize(0)));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftImageView).mas_offset(-__kNewSize(15*2));
        make.left.mas_equalTo(self.leftImageView.mas_right).mas_offset(__kNewSize(10*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
        make.height.mas_equalTo(__kNewSize(48*2));
    }];
    [_urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftImageView.mas_bottom).mas_offset(__kNewSize(20*2));
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(15*2));
        make.height.mas_equalTo(__kNewSize(20*2));
    }];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-__kNewSize(15*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(50*2), __kNewSize(40*2)));
    }];
    
    [_loadedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(-6);
        make.left.right.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.height.mas_equalTo(4);
    }];
}

#pragma mark - CLick
-(void)startClick:(UIButton *)btn{
    if (btn.selected == YES) {
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        __kWeakSelf__;
        [DownLoadManager cannel:self.downLoadModel.downLoadUrl];
        [DownLoadManager start:self.downLoadModel.downLoadUrl Name:self.downLoadModel.title progressBlock:^(CGFloat progress) {
            NSLog(@"下载进度: %@",[NSString stringWithFormat:@"%.00f%%",progress * 100]);
            weakSelf.urlLabel.text = [NSString stringWithFormat:@"%.00f%%",progress * 100];
            [weakSelf.loadedView setProgress:progress animated:YES];
        }];
    }else{
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [DownLoadManager cannel:self.downLoadModel.downLoadUrl];
    }
    btn.selected = !btn.selected;
}
#pragma mark - 懒加载
-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
    }
    return _leftImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#515C6F"];
        _titleLabel = label;
    }
    return _titleLabel;
}
-(UILabel *)urlLabel{
    if (!_urlLabel) {
        UILabel * label = [[UILabel alloc]  init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        label.textColor = [UIColor colorWithHexString:@"#515C6F"];
        _urlLabel = label;
    }
    return _urlLabel;
}
-(UIButton *)startButton{
    if (_startButton == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(32)];
        [button setTitle:@"开始" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        button.layer.cornerRadius =5;
        button.backgroundColor = [UIColor redColor];
        button.selected = YES;
        [button addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        _startButton = button;
    }
    return _startButton;
}
//缓冲条
- (UIProgressView *) loadedView{
    if (!_loadedView){
        _loadedView = [[UIProgressView alloc] init];
        _loadedView.progressViewStyle = UIProgressViewStyleDefault;
        _loadedView.trackTintColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        _loadedView.progressTintColor = [[UIColor orangeColor]colorWithAlphaComponent:1];
    }
    return _loadedView;
}
@end
