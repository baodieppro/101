//
//  GSCoverPictureNode.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/12.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSCoverPictureNode.h"

@implementation GSCoverPictureNode
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self c_UI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self c_layoutFrame];
    
}
-(void)c_UI{
    [self addSubview:self.pictImage];
}
-(void)c_layoutFrame{
    [_pictImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    _pictImage.layer.cornerRadius = self.bounds.size.height/2;

}

#pragma mark - UI
-(UIImageView *)pictImage{
    if (!_pictImage) {
        _pictImage = [[UIImageView alloc]init];
//        _pictImage.image = [UIImage imageNamed:__new_welcome_2__];
        _pictImage.userInteractionEnabled = YES;
        _pictImage.layer.masksToBounds = YES;
        _pictImage.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
    return _pictImage;
}
#pragma mark - 音频旋转动画
- (void)startAnimating {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 15;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI*2);
    [self.pictImage.layer addAnimation:animation forKey:@"rotationAnimation"];
    
}
// 动画结束
- (void)stopAnimating
{
    [self.pictImage.layer removeAllAnimations];
}
@end
