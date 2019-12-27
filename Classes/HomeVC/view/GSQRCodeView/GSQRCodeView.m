//
//  GSQRCodeView.m
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "GSQRCodeView.h"

#import <AVFoundation/AVFoundation.h>
//#import "UIImage+BlurGlass.h"

@interface GSQRCodeView ()<AVCaptureMetadataOutputObjectsDelegate,CAAnimationDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
    
    BOOL isRequesting;
    BOOL _isOpenFlash;
}

@property (nonatomic,weak) UIView *leftView;
@property (nonatomic,weak) UIView *rightView;
@property (nonatomic,weak) UIView *upView;
@property (nonatomic,weak) UIView *downView;
@property (nonatomic,weak) UIImageView *centerView; //扫描框
@property (nonatomic,weak) UIImageView *line; //扫描线

@property (nonatomic,strong) NSString *scanMessage; //扫描内容

@property (nonatomic,strong) UILabel * promptLable; //提醒语

@property (nonatomic,strong) UIImageView *backgroundImg; //背景图
@property (nonatomic,strong) UIImageView *photogroundImg; //背景图
@property (nonatomic,strong) UIImageView *flashgroundImg; //背景图

@property (nonatomic,strong) NSString *backImag; //返回背景图
@property (nonatomic,strong) NSString *photoImag; //相册背景图
@property (nonatomic,strong) NSString *flashImag; //闪光灯背景图

@property (nonatomic,strong) UIControl *back; //返回
@property (nonatomic,strong) UIControl *photo; //相册
@property (nonatomic,strong) UIControl *flash; //闪光灯

@end



@implementation GSQRCodeView


- (instancetype)init{
    
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

/**
 * 不管调用的init还是initWithFrame,都会来到这里
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self =[super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  初始化
 */
- (void)setUp{
    [self newSet];
    [self instanceDevice];
}

/**
 *  初始化配置
 */
-(void)newSet{
    _isOpenFlash = NO;
    self.backImag = @"scan_3";
    self.photoImag = @"scan_1";
    self.flashImag = @"scan_2";
    
}
/**
 *  设置扫码框的宽
 */
-(void)setScanW:(int)scanW{
    
    _scanW = scanW;
    
    [self layoutSubviews];
}


/**
 *  配置相机属性
 */
- (void)instanceDevice{
    
    line_tag = 10000 + 1116; //0-99 为系统所用
    
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if (input) {
        
        [session addInput:input];
    }
    if (output) {
        
        [session addOutput:output];
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }

    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    [self startRunning];
}

/**
 *  监听扫码状态-修改扫描动画
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}


/**
 *  获取扫码结果
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        [self stopRunning];
        __kWeakSelf__;
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        
        if (data) {
            //            NSLog(@"%@",data);
            
            weakSelf.scanMessage = data;
            [self setDataStringisUrl:weakSelf.scanMessage];
        }
    }
}
-(void)setDataStringisUrl:(NSString *)message{
    
//    if([MaqueTool newIsUrl:scanMessage] == NO){
//
//        [self hidden];
//        [self UI];
//        //                [self Frame:0];
//        NSInteger _height = [MaqueTool HeightStr:scanMessage typefaceName:nil typefaceSize:__kNewSize(24) scopeWidth:__kScreenWidth__-__kNewSize(80*2) scopeHeight:__kNewSize(24+170)];
//
//        [MaqueTool newParagraphStyle:_bodyLable str:scanMessage LineSpacing:__kNewSize(8)];
//
//        _bodyLable.text = scanMessage;
//
//        [self Frame:_height];
//        //                _bodyLable.backgroundColor = [UIColor redColor];
//    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getScanDataString:)])
    {
        [self.delegate getScanDataString:self.scanMessage];
    }
    
    
}


/**
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    
    //左侧的view 原来宽30
    UIView *leftView = [[UIView alloc]init];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self addSubview:leftView];
    _leftView = leftView;
    
    //右侧的view
    UIView *rightView = [[UIView alloc]init];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self addSubview:rightView];
    _rightView = rightView;
    
    //最上部view
    UIView *upView = [[UIView alloc]init];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self addSubview:upView];
    _upView = upView;
    
    //底部view
    UIView *downView = [[UIView alloc]init];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self addSubview:downView];
    _downView = downView;
    
    UIImageView *centerView = [[UIImageView alloc]init];
    //扫描框图片的拉伸，拉伸中间一块区域
    UIImage *scanImage = [UIImage imageNamed:@"QR"];
    CGFloat top = 34*0.5-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = 34*0.5-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    scanImage = [scanImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    centerView.image = scanImage;
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    _centerView = centerView;
    
    //扫描线
    UIImageView *line = [[UIImageView alloc]init];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"scanline"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    line.clipsToBounds = YES;
    [self addSubview:line];
    _line = line;
    
    
    if (_photoImag) {
        [self addSubview:self.photo];
    }
    if (_flashImag) {
        [self addSubview:self.flash];
    }
    if (_backImag) {
        [self addSubview:self.back];
    }
    [self layoutSubviews];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(self.scanW){
        
    }else{
        
        self.scanW = 465/2;
    }
    CGFloat gapW = (__kScreenWidth__-((96/2)*3))/4;
    
    _photo.frame = CGRectMake(gapW, 116/2, 96/2, 96/2);
    _flash.frame = CGRectMake(gapW*2+(_photo.bounds.size.width), 116/2, 96/2, 96/2);
    _back.frame = CGRectMake(gapW*3+(_flash.bounds.size.width*2), 116/2, 96/2, 96/2);
    
    
    //扫描框的宽
    CGFloat scanViewW = self.scanW;
    
    //左侧的view 原来宽30
    _leftView.frame = CGRectMake(0, 0, (__kScreenWidth__ - scanViewW) * 0.5, self.frame.size.height);
    //右侧的view
    _rightView.frame = CGRectMake(self.frame.size.width-((__kScreenWidth__ - scanViewW) * 0.5), 0, (__kScreenWidth__ - scanViewW) * 0.5, self.frame.size.height);
    //最上部view
    _upView.frame = CGRectMake((__kScreenWidth__ - scanViewW) * 0.5, 0, scanViewW, 374/2);
    //底部view
    _downView.frame = CGRectMake((__kScreenWidth__ - scanViewW) * 0.5, CGRectGetMaxY(_upView.frame) + scanViewW, scanViewW, __kScreenHeight__ - (CGRectGetMaxY(_upView.frame) + scanViewW));
    //扫码框
    _centerView.frame = CGRectMake(CGRectGetMaxX(_leftView.frame), CGRectGetMaxY(_upView.frame), scanViewW, scanViewW);
    //扫描线
    _line.frame = CGRectMake((__kScreenWidth__ - scanViewW) * 0.5, CGRectGetMaxY(_upView.frame), scanViewW, 2);
    
    if (_back) {
        [_back addSubview:self.backgroundImg];
    }
    if (_photo) {
        [_photo addSubview:self.photogroundImg];
    }
    if (_flash) {
        [_flash addSubview:self.flashgroundImg];
    }
    
}


/**
 *  添加扫码动画
 */
- (void)addAnimation{
    
    UIView *line = [self viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [GSQRCodeView moveYTime:2 fromY:[NSNumber numberWithFloat:4] toY:[NSNumber numberWithFloat:self.scanW -2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep{
    
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    //    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  去除扫码动画
 */
- (void)removeAnimation{
    
    UIView *line = [self viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

/**
 *  开始扫码
 */
- (void)startRunning{
    
    [session startRunning];
}

/**
 *  结束扫码
 */
- (void)stopRunning{
    
    [session stopRunning];
}


/**
 *  移除监听
 */
- (void)dealloc{
    
    [session removeObserver:self forKeyPath:@"running"];
}
#pragma mark - 私有方法

- (void)turnTorchOn: (bool) on

{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            
            
            [device lockForConfiguration:nil];
            
            if (on) {
                
                [device setTorchMode:AVCaptureTorchModeOn];
                
                [device setFlashMode:AVCaptureFlashModeOn];
                
                //                on = NO;
                
            } else {
                
                [device setTorchMode:AVCaptureTorchModeOff];
                
                [device setFlashMode:AVCaptureFlashModeOff];
                
                //                on = YES;
                
            }
            
            [device unlockForConfiguration];
            
        }
        
    }
    
}

/**
 
 *  打开相册
 
 */

-(void)openPhotoLibrary

{
    
    // Supported orientations has no common orientation with the application, and [PUUIAlbumListViewController shouldAutorotate] is returning YES
    
    
    
    // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self.getPresentedViewController presentViewController:imagePicker animated:YES completion:^{
            
            NSLog(@"打开相册");
            
        }];
        
    }
    
    else
        
    {
        
        NSLog(@"不能打开相册");
        
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __kWeakSelf__;
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //通过对话框的形式呈现
            //            [self alertControllerMessage:scannedResult];
            weakSelf.scanMessage = scannedResult;
            
            [self setDataStringisUrl:weakSelf.scanMessage];
        }else{
            [self alertControllerMessage:@"这不是一个二维码"];
        }
    }];
}

//由于要写两次，所以就封装了一个方法
-(void)alertControllerMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self.getPresentedViewController presentViewController:alert animated:YES completion:nil];
}
- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
#pragma mark - click
-(void)backClick:(UIControl *)con
{
    [self stopRunning];
    if ([self.delegate respondsToSelector:@selector(newGsBack)])
    {
        [self.delegate newGsBack];
    }
}
-(void)photoClick:(UIControl *)con
{
    
    [self openPhotoLibrary];
    if ([self.delegate respondsToSelector:@selector(newGSOpenPhoto)])
    {
        [self.delegate newGSOpenPhoto];
    }
}
-(void)flashClick:(UIControl *)con
{
    if (_isOpenFlash == NO) {
        _isOpenFlash = YES;
    }else{
        _isOpenFlash = NO;
        
    }
    [self turnTorchOn:_isOpenFlash];
    
    //    if ([self.delegate respondsToSelector:@selector(newGsOpenFlash)])
    //    {
    //        [self.delegate newGsOpenFlash];
    //    }
}
#pragma mark - 初始化UI
-(UIControl *)back{
    if (!_back) {
        _back = [[UIControl alloc]init];
        [_back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _back;
}
-(UIControl *)photo{
    if (!_photo) {
        _photo = [[UIControl alloc]init];
        [_photo addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _photo;
}
-(UIControl *)flash{
    if (!_flash) {
        _flash = [[UIControl alloc]init];
        [_flash addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flash;
}

-(UIImageView *)backgroundImg{
    if (!_backgroundImg) {
        _backgroundImg = [[UIImageView alloc]init];
        _backgroundImg.frame = self.back.bounds;
        _backgroundImg.image = [UIImage imageNamed:self.backImag];
        
    }
    return _backgroundImg;
}
-(UIImageView *)photogroundImg{
    if (!_photogroundImg) {
        _photogroundImg = [[UIImageView alloc]init];
        _photogroundImg.frame = self.photo.bounds;
        _photogroundImg.image = [UIImage imageNamed:self.photoImag];
        
    }
    return _photogroundImg;
}
-(UIImageView *)flashgroundImg{
    if (!_flashgroundImg) {
        _flashgroundImg = [[UIImageView alloc]init];
        _flashgroundImg.frame = self.flash.bounds;
        _flashgroundImg.image = [UIImage imageNamed:self.flashImag];
        
    }
    return _flashgroundImg;
}
-(UILabel *)promptLable{
    if (!_promptLable) {
        _promptLable = [[UILabel alloc]init];
        
    }
    return _promptLable;
}
#pragma mark -  纯文本展示
-(void)hidden{
    
    _back.alpha = 0;
    _photo.alpha = 0;
    _flash.alpha = 0;
    _centerView.alpha = 0;
    _line.alpha = 0;
    _leftView.alpha = 0;
    _rightView.alpha = 0;
    _upView.alpha = 0;
    _downView.alpha = 0;
    
}

-(void)UI{
    [self addSubview:self.beijingView];
    [self addSubview:self.headline];
    [self addSubview:self.subtitle];
    [self addSubview:self.bodyLable];
    [self addSubview:self.fuzhi];
    [self addSubview:self.fanhui];
    
}

-(void)Frame:(NSInteger)sizeH{
    //    [_beijingView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.top).offset(__kNewSize(0));
    //        make.left.offset(__kNewSize(0));
    //        make.size.mas_equalTo(CGSizeMake(__kScreenWidth__,__kScreenHeight__));
    //    }];
    //    [_headline mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.top).offset(__kNewSize(320));
    //        make.left.offset(__kNewSize(80));
    //        make.size.mas_equalTo(CGSizeMake(__kScreenWidth__-__kNewSize(80*2),__kNewSize(36)));
    //    }];
    //    [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_headline.bottom).offset(__kNewSize(46));
    //        make.left.offset(__kNewSize(80));
    //        make.size.mas_equalTo(CGSizeMake(__kScreenWidth__-__kNewSize(80*2),__kNewSize(24)));
    //    }];
    //    [_bodyLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_subtitle.bottom).offset(__kNewSize(34));
    //        make.left.offset(__kNewSize(80));
    //        make.size.mas_equalTo(CGSizeMake(__kScreenWidth__-__kNewSize(80*2),__kNewSize(24)));
    //    }];
    //    [_fuzhi mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_bodyLable.bottom).offset(__kNewSize(174));
    //        make.left.offset(__kNewSize(80));
    //        make.size.mas_equalTo(CGSizeMake(__kNewSize(590),__kNewSize(70)));
    //    }];
    //
    //    [_fanhui mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_bodyLable.bottom).offset(__kNewSize(38));
    //        make.left.offset(__kNewSize(80));
    //        make.size.mas_equalTo(CGSizeMake(__kNewSize(590),__kNewSize(70)));
    //    }];
    
    _beijingView.frame = CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__);
    _headline.frame = CGRectMake(__kNewSize(80), __kNewSize(320), __kScreenWidth__-__kNewSize(80*2),__kNewSize(36));
    _subtitle.frame = CGRectMake(__kNewSize(80), _headline.frame.origin.y+_headline.frame.size.height+__kNewSize(46), __kScreenWidth__-__kNewSize(80*2),__kNewSize(24));
    _bodyLable.frame = CGRectMake(__kNewSize(80), _subtitle.frame.origin.y+_subtitle.frame.size.height+__kNewSize(10), __kScreenWidth__-__kNewSize(80*2),__kNewSize(24)+sizeH);
    _fuzhi.frame = CGRectMake(__kNewSize(80), _bodyLable.frame.origin.y+_bodyLable.frame.size.height+__kNewSize(100), __kNewSize(590),__kNewSize(70));
    _fanhui.frame = CGRectMake(__kNewSize(80), _fuzhi.frame.origin.y+_fuzhi.frame.size.height+__kNewSize(38),__kNewSize(590),__kNewSize(70));
    
}

-(UIView *)beijingView{
    if (!_beijingView) {
        _beijingView = [[UIView alloc]init];
        _beijingView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        
    }
    return _beijingView;
}
-(UIButton *)fanhui{
    if (!_fanhui) {
        _fanhui = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fanhui setTitle:@"返回" forState:UIControlStateNormal];
        [_fanhui setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _fanhui.backgroundColor = [UIColor colorWithHexString:@"#6f6f6f"];
        
    }
    return _fanhui;
}
-(UIButton *)fuzhi{
    if (!_fuzhi) {
        _fuzhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fuzhi setTitle:@"复制" forState:UIControlStateNormal];
        [_fuzhi setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _fuzhi.backgroundColor = [UIColor colorWithHexString:@"#6f6f6f"];
    }
    return _fuzhi;
}

-(UILabel *)headline{
    if (!_headline) {
        _headline = [[UILabel alloc]init];
        _headline.text = @"扫描结果";
        _headline.textAlignment = NSTextAlignmentLeft;
        _headline.textColor = [UIColor whiteColor];
        _headline.font = [UIFont systemFontOfSize:__kNewSize(36)];
        _headline.numberOfLines = 1;
        _headline.lineBreakMode = NSLineBreakByTruncatingTail;
        _headline.backgroundColor = [UIColor clearColor];
    }
    return _headline;
}
-(UILabel *)subtitle{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc]init];
        _subtitle.text = @"文本";
        _subtitle.textAlignment = NSTextAlignmentLeft;
        _subtitle.textColor = [UIColor whiteColor];
        _subtitle.font = [UIFont systemFontOfSize:__kNewSize(24)];
        _subtitle.numberOfLines = 1;
        _subtitle.lineBreakMode = NSLineBreakByTruncatingTail;
        _subtitle.backgroundColor = [UIColor clearColor];
    }
    return _subtitle;
}
-(UILabel *)bodyLable{
    if (!_bodyLable) {
        _bodyLable = [[UILabel alloc]init];
        _bodyLable.textAlignment = NSTextAlignmentLeft;
        _bodyLable.textColor = [UIColor whiteColor];
        _bodyLable.font = [UIFont systemFontOfSize:__kNewSize(24)];
        _bodyLable.numberOfLines = 8;
        _bodyLable.lineBreakMode = NSLineBreakByTruncatingTail;
        _bodyLable.backgroundColor = [UIColor clearColor];
    }
    return _bodyLable;
}

@end
