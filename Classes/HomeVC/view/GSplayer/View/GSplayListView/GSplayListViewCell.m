//
//  GSplayListViewCell.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/15.
//  Copyright © 2019 Roger. All rights reserved.
//
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

#import "GSplayListViewCell.h"
#import "BNTool.h"

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
-(void)setCurrentLabelTitle:(NSString *)text{
    _titleLabel.text = text;
}
-(void)setModel:(PlayCacheModel *)model{
    _titleLabel.text = model.title;
//    _centerImageView.image = [self firstFrameWithVideoURL:[NSURL URLWithString:[BNTool m3u8Url:model.url]] size:_centerImageView.size];
    _centerImageView.image = [self getVideoPreViewImage:model.url];
//    _centerImageView.image = [self thumbnailImageForVideo:[NSURL URLWithString:model.url] atTime:10];

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
// 获取视频第一帧
#pragma mark ---- 获取图片第一帧
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}
- (UIImage*) getVideoPreViewImage:(NSString *)path
{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
//    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:asset];

//    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//
//    assetGen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
//    CGImageRelease(image);
//    return videoImage?:[UIImage imageNamed:@"img_popup_pretermit"];
//    return [self getPixelBufferForItem:playerItem];
    
    //本地视频

//       AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];

       //网络视频

       AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:path] options:nil];

      

       AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];

       assetGen.appliesPreferredTrackTransform = YES;

       CMTime time = CMTimeMakeWithSeconds(0.0, 600);

       NSError *error = nil;

       CMTime actualTime;

       CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];

       UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];

       CGImageRelease(image);

       if (videoImage == nil) {

           videoImage = [UIImage imageNamed:@"img_popup_pretermit.png"];

       }

       return videoImage;

}

//获取m3u8视频帧画面
- (UIImage *)getPixelBufferForItem:(AVPlayerItem *)playerItem{

    AVPlayerItemVideoOutput *output = [[AVPlayerItemVideoOutput alloc] init];
    [playerItem addOutput:output];
    CVPixelBufferRef ref =[output copyPixelBufferForItemTime:CMTimeMake(10, 60) itemTimeForDisplay:nil];
    UIImage *image = [self CVImageToUIImage:ref];
    return image;
}
//CVPixelBufferRef转UIImage
- (UIImage *)CVImageToUIImage:(CVPixelBufferRef)imageBuffer{
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;

}
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];

    NSParameterAssert(asset);

    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];

     assetImageGenerator.appliesPreferredTrackTransform = YES;

    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

      CGImageRef thumbnailImageRef = NULL;

    CFTimeInterval thumbnailImageTime = time;

    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    if(!thumbnailImageRef)
    NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    return thumbnailImage;

}

@end
