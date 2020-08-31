//
//  GSLoding.m
//  GSLoading
//
//  Created by 巩少鹏 on 2020/4/16.
//  Copyright © 2020 HaoCold. All rights reserved.
//

#import "GSLoading.h"
static NSInteger animationCount = 0;

@interface GSLoading()
@property (nonatomic,  strong) UILabel *coverLabel;
@property (nonatomic,  strong) UIView *coverMaskView;

@property (nonatomic,  strong) NSTimer *timer;
@end

@implementation GSLoading

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _loadingColor           = [UIColor whiteColor];
        _loadingBackgroundColor = [UIColor clearColor];
        _loadingWidth           = 30.0;
        _loadingDuration        = 3.0;
        _loadingInterval        = 1.0;
        _loadingCycleTimes      = 10;
        _loadingOnce = NO;
        [self addSubview:self.coverLabel];
        self.coverLabel.maskView = self.coverMaskView;
    }
    return self;
}

#pragma mark - override

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect bounds = self.coverMaskView.frame;
    bounds.size.height = frame.size.height;
    _coverMaskView.frame = bounds;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    _coverLabel.text = text;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _coverLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    _coverLabel.textAlignment = textAlignment;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [super setLineBreakMode:lineBreakMode];
    _coverLabel.lineBreakMode = lineBreakMode;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
    _coverLabel.numberOfLines = numberOfLines;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    [super setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
    _coverLabel.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

#pragma mark - private

- (void)setupForStyle
{
    if (_style == GSLoadingStyle_Normal) {
        _coverMaskView.backgroundColor = [UIColor whiteColor];
    }else if (_style == GSLoadingStyle_Slanted) {
        CGSize size = _coverMaskView.bounds.size;
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] set];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(size.width*0.5, 0)];
        [path addLineToPoint:CGPointMake(0, size.height)];
        [path addLineToPoint:CGPointMake(size.width*0.5, size.height)];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        [path addLineToPoint:CGPointMake(size.width*0.5, 0)];
        
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathFill);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _coverMaskView.backgroundColor = [UIColor clearColor];
        _coverMaskView.layer.contents = (id)[image CGImage];
    }
}

- (void)animation
{
    animationCount ++;
    __block CGRect frame = _coverMaskView.frame;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_loadingDuration delay:0.0 options:(UIViewAnimationOptions)_animationStyle animations:^{
        frame.origin.x = CGRectGetMaxX(weakSelf.coverLabel.frame);
        weakSelf.coverMaskView.frame = frame;
    } completion:^(BOOL finished) {
        if (weakSelf.loadingOnce) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }else{
            frame.origin.x = -CGRectGetWidth(weakSelf.coverMaskView.frame);
            weakSelf.coverMaskView.frame = frame;
        }
    }];
    if (animationCount == _loadingCycleTimes) {
        animationCount = 0;
         if([self.delegate respondsToSelector:@selector(myAnimationStop)]){
                   [self.delegate myAnimationStop];
            }
    }
}

#pragma mark - public

- (void)start
{
    if (!_timer) {
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (void)stop
{
    [_timer invalidate];
    _timer = nil;
   
}

#pragma mark - lazy
-(void)setLoadingColor:(UIColor *)loadingColor{
    _loadingColor = loadingColor;
    _coverLabel.textColor = loadingColor;
}
-(void)setLoadingBackgroundColor:(UIColor *)loadingBackgroundColor{
    _loadingBackgroundColor = loadingBackgroundColor;
       _coverLabel.backgroundColor = loadingBackgroundColor;
}
-(void)setLoadingWidth:(CGFloat)loadingWidth{
    _loadingWidth = loadingWidth;
    CGRect frame = self.coverMaskView.frame;
    frame.size.width = loadingWidth;
    frame.origin.x = -loadingWidth;
    _coverMaskView.frame = frame;
}

- (void)setStyle:(GSLoadingStyle)style{
    if (_style != style) {
        _style = style;
        [self setupForStyle];
    }
}

- (void)setloadingAlpha:(CGFloat)loadingAlpha{
    _loadingAlpha = loadingAlpha;
    _coverMaskView.alpha = loadingAlpha;
}

- (UILabel *)coverLabel{
    if (!_coverLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = self.bounds;
        label.textColor = _loadingColor;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        _coverLabel = label;
    }
    return _coverLabel;
}

- (UIView *)coverMaskView{
    if (!_coverMaskView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(-_loadingWidth, 0, _loadingWidth, CGRectGetHeight(self.bounds));
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = _loadingBackgroundColor;
        _coverMaskView = view;
    }
    return _coverMaskView;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_loadingDuration+_loadingInterval target:self selector:@selector(animation) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
