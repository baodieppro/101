//
//  GShareView.m
//  ToolscreenShot
//
//  Created by 巩小鹏 on 2018/9/17.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//
#define __kWeakSelf__ __weak typeof(self) weakSelf = self;


#import "GShareView.h"
#import "GOpenUrl.h"
#import "Config.h"

@interface GShareView ()

@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View

@property (nonatomic,strong) UIView * shareView;//!<分享背景
@property (nonatomic,strong) UIButton * cancelShare;//!<取消
@property (nonatomic,strong) UILabel * lableShare;//!<没有检测到分享app
@property (nonatomic,strong) NSMutableArray * titleArr;
@property (nonatomic,strong) NSMutableArray * imageArr;

@property (nonatomic, assign) ShareClickType shareClickType;//!<分享功能区分

@end

@implementation GShareView

+ (GShareView *)newShare
{
    static GShareView* updateappearances = nil;
    static dispatch_once_t onceUpdateToken;
    dispatch_once(&onceUpdateToken, ^{
        updateappearances = [[GShareView alloc] init];
    });
    
    return updateappearances;
}
#pragma mark - Click点击分享
-(void)shareNewClick:(UIButton *)btn{
    NSString * titleStr;
    if (_titleArr.count != 0) {
        titleStr = _titleArr[btn.tag - 401];
    }
    if ([titleStr isEqualToString:@"微信朋友圈"]) {
     
        self.shareClickType = WechatTimeLine_ShareType;
        
    }else if ([titleStr isEqualToString:@"微信好友"]){
   
        self.shareClickType = WechatSession_ShareType;

    }else if ([titleStr isEqualToString:@"QQ好友"]){
       
        self.shareClickType = QQ_ShareType;

    }else if ([titleStr isEqualToString:@"QQ空间"]){
     
        self.shareClickType = Qzone_ShareType;

    }else if ([titleStr isEqualToString:@"新浪微博"]){
       
        self.shareClickType = Sina_ShareType;

    }else{
        NSLog(@"空的");
        self.shareClickType = error_ShareType;

    }
    
    _shareBlock(self.shareClickType);
    
    [self dismiss];
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]init];
        if (self.isWX == YES) {
            //没有安装微信
            //        NSLog(@"安装微信");
            [_titleArr addObject:@"微信朋友圈"];
            [_titleArr addObject:@"微信好友"];
          
        }
        if (self.isQQ == YES) {
            //没有安装QQ
            //        NSLog(@"安装QQ");
            [_titleArr addObject:@"QQ好友"];
            [_titleArr addObject:@"QQ空间"];
           
        }
        if (self.isSina == YES) {
            //没有安装新浪微博
            //        NSLog(@"安装新浪微博");
            [_titleArr addObject:@"新浪微博"];
           
        }
    }
    return _titleArr;
}
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc]init];
        if (self.isWX == YES == YES) {
            [_imageArr addObject:@"share_1"];
            [_imageArr addObject:@"share_2"];
        }
        if (self.isQQ == YES) {
            [_imageArr addObject:@"share_3"];
            [_imageArr addObject:@"share_4"];
        }
        if (self.isSina == YES) {
            [_imageArr addObject:@"share_5"];
        }
    }
    return _imageArr;
}
#pragma mark - 测试数据
-(void)testInit{
    if (!_titleArr) {
        [self.titleArr addObject:@"微信朋友圈"];
        [self.titleArr addObject:@"微信好友"];
        [self.titleArr addObject:@"QQ好友"];
        [self.titleArr addObject:@"QQ空间"];
        [self.titleArr addObject:@"新浪微博"];
    
        [self.imageArr addObject:@"share_1"];
        [self.imageArr addObject:@"share_2"];
        [self.imageArr addObject:@"share_3"];
        [self.imageArr addObject:@"share_4"];
        [self.imageArr addObject:@"share_5"];
     }
    
}

-(void)s_UI{
    
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self.cancelShare];
    [self.window addSubview:self.shareView];
    
    if (self.shareType == ShareScreenshotsType)
    {
        [self.window addSubview:self.screenShotsImage];
    }
    if (self.titleArr.count == 0) {
        [_shareView addSubview:self.lableShare];
    }else{
        [self createKeyboardToolsButton:self.titleArr image:self.imageArr LableColor:[UIColor grayColor]];

    }
    [self p_hideFrame];
}
//隐藏
-(void)p_hideFrame{
//    if (self.shareType == ShareScreenshotsType)
//    {
//        _screenShotsImage.frame = CGRectMake((100), __kScreenHeight__, __kScreenWidth__- (200), __kScreenHeight__ - (425));
//    }
    _shareView.frame =CGRectMake(0,__kScreenHeight__, __kScreenWidth__, (394/2-60));
    _cancelShare.frame = CGRectMake(0, __kScreenHeight__, __kScreenWidth__, 60);
}

//展示
-(void)p_disFrame{
   
    _cancelShare.frame = CGRectMake(0, __kScreenHeight__-120/2, __kScreenWidth__, (120/2));
    _shareView.frame =CGRectMake(0,__kScreenHeight__-(394/2), __kScreenWidth__, (394/2-60));
}
-(void)p_dis{
        //等比例缩放
        CGFloat kHeigthMargins = 30;
        CGFloat heightS =__kScreenHeight__ - (394/2+kHeigthMargins*2);
        CGFloat widthS =__kScreenWidth__ /(__kScreenHeight__/heightS);
        CGFloat kWidthMargins = (__kScreenWidth__ - widthS)/2;
    self.screenShotsImage.frame = CGRectMake(kWidthMargins, kHeigthMargins, widthS, heightS);
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{

        self.screenShotsImage.transform = CGAffineTransformMakeScale(0.1,0.1);

        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.6 animations: ^{

        self.screenShotsImage.transform = CGAffineTransformMakeScale(1.1,1.1);
        }];

        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.8 animations: ^{

        self.screenShotsImage.transform = CGAffineTransformMakeScale(1.0,1.0);

        }];

    } completion:nil];
    
}
#pragma mark - 展示
-(void)show{
     __kWeakSelf__;
    [self isDisPaly:^{
         [weakSelf s_UI];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf p_disFrame];
            self->_shareView.alpha = 1;
            self->_cancelShare.alpha = 1;
            self->_backgroundGrayView.alpha = 0.8;
            
        } completion:^(BOOL finished) {
            if (finished) {
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
          
        }];
        
        [UIView commitAnimations];
        if (self.shareType == ShareScreenshotsType){
            [self p_dis];
        }
    } Hide:^{
        
    }];
    
}
-(void)dismiss{
    __kWeakSelf__;
    [self isDisPaly:^{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf p_hideFrame];
            weakSelf.alpha = 0;
            weakSelf.shareView.alpha = 0;
            weakSelf.cancelShare.alpha = 0;
            weakSelf.backgroundGrayView.alpha = 0;
            weakSelf.screenShotsImage.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.shareView = nil;
                [weakSelf.shareView removeFromSuperview];
                [weakSelf.backgroundGrayView removeFromSuperview];
                [weakSelf.cancelShare removeFromSuperview];
                [weakSelf.lableShare removeFromSuperview];
                [weakSelf removeFromSuperview];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        }];
        [UIView commitAnimations];
        [weakSelf.screenShotsImage removeFromSuperview];
        weakSelf.screenShotsImage = nil;

    } Hide:^{
        
    }];
}
#pragma mark - 展示按钮UI布局
-(void)createKeyboardToolsButton:(NSArray *)itmeArr image:(NSArray *)imageArr LableColor:(UIColor *)color
{
    for (NSInteger r = 0; r < itmeArr.count; r++) {
        UIControl * con = [_shareView viewWithTag:401+r];
        UIImageView * img = [con viewWithTag:601+r];
        UILabel * lab = [con viewWithTag:501+r];
        [img removeFromSuperview];
        [lab removeFromSuperview];
        [con removeFromSuperview];
         img = nil;
         lab = nil;
         con = nil;
    }
    
    CGFloat _hig ;

        _hig = (74/2);
    //
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.frame = _shareView.bounds;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO; //隐藏横向滚动条
    scrollView.showsVerticalScrollIndicator = NO; //隐藏竖向滚动条
    scrollView.contentSize = CGSizeMake(63*itmeArr.count+60, _shareView.bounds.size.height);

    NSLog(@"%f",scrollView.contentSize.width);
    
    for (NSInteger i = 0; i < itmeArr.count; i++) {
        
        
        UIControl *control = [[UIControl alloc]init];
        control.frame =CGRectMake((30/2)+(scrollView.contentSize.width - (60/2))/itmeArr.count*i, _hig, (scrollView.contentSize.width - (60/2))/itmeArr.count, (126/2));
        control.tag = 401+i;
        [control addTarget:self action:@selector(shareNewClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:control];
        [_shareView addSubview:scrollView];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(((scrollView.contentSize.width - (60/2))/itmeArr.count-(74/2))/2, 0, (74/2), (74/2))];
        imageView.tag = 601+i;
        imageView.image= [UIImage imageNamed:imageArr[i]];
        [control addSubview:imageView];
        
        UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (74/2+30/2), control.bounds.size.width, (22/2))];
        titleLable.textColor = color;
        titleLable.text = itmeArr[i];
        titleLable.font = [UIFont systemFontOfSize:(22/2)];
//        titleLable.adjustsFontSizeToFitWidth = YES;
        titleLable.textAlignment = NSTextAlignmentCenter;
//        titleLable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        //        [self sizeToFit];
        titleLable.tag = 501+i;
        [control addSubview:titleLable];

    }
}


#pragma mark - 判断真机与模拟器
-(void)isDisPaly:(void (^)(void))disPaly Hide:(void (^)(void))hide{
    __kWeakSelf__;
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        [weakSelf testInit];
        disPaly();
//        hide();
        
    }else{
//         [weakSelf testInit];
        //真机
        if(weakSelf.isQQ  ==  weakSelf.isWX  == weakSelf.isSina  == YES){
             disPaly();
        }
        else if(weakSelf.isQQ  ==  weakSelf.isWX  == YES){
             disPaly();
        }
        else if(weakSelf.isQQ  == weakSelf.isSina  == YES){
             disPaly();
        }
        else if(weakSelf.isWX  == weakSelf.isSina  == YES){
             disPaly();
        }
        else 
        {
            hide();
        }
    }
    
}
#pragma mark - 判断是否有分享的三方app
-(BOOL)isQQ{
    return [GOpenUrl isAppOpenStr:@"mqqapi://"];
}
- (BOOL)isWX{
    return [GOpenUrl isAppOpenStr:@"weixin://"];
}
- (BOOL)isSina{
    return [GOpenUrl isAppOpenStr:@"sinaweibo://"];
}

#pragma mark - 初始化

-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
    }
    return _window;
}
-(UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]init];
        _shareView.backgroundColor = [UIColor whiteColor];
    }
    return _shareView;
}
-(UIImageView *)screenShotsImage{
    if (!_screenShotsImage) {
        _screenShotsImage = [[UIImageView alloc]init];
        _screenShotsImage.alpha = 1;
        _screenShotsImage.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        //设置圆角
        _screenShotsImage.layer.cornerRadius = 6;
        //将多余的部分切掉
        _screenShotsImage.layer.masksToBounds = YES;
    }
    return _screenShotsImage;
}
-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,0, __kScreenWidth__, __kScreenHeight__);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backgroundGrayView addGestureRecognizer:tap];
        
    }
    return _backgroundGrayView;
}
-(UIButton *)cancelShare{
    if (!_cancelShare) {
        _cancelShare = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelShare setImage:[UIImage imageNamed:@"tool_bird_11"] forState:UIControlStateNormal];
        [_cancelShare setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelShare.backgroundColor = [UIColor whiteColor];
//                _cancelShare.layer.masksToBounds = YES;
//        //        _determineBtn.layer.cornerRadius = 2.0;
//                _cancelShare.layer.borderWidth = 1.0;
//                CGColorRef colorref = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
//                [_cancelShare.layer setBorderColor:colorref];
        //        _deleteTMVBtn.jsonTheme.imageWithState(@"ident_14",UIControlStateNormal);
        
        _cancelShare.titleLabel.font = [UIFont systemFontOfSize: 36/2];
        //        UIView * xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kScreenWidth__, 1)];
        //        xian.backgroundColor = [UIColor colorWithHexString:@"#e4e6eb"];
        //        [_cancelShare addSubview:xian];
        [_cancelShare addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer * leftBorder = [CALayer layer];
        leftBorder.frame = CGRectMake(0, 1,__kScreenWidth__,1);
        leftBorder.backgroundColor = [UIColor grayColor].CGColor;
        [_cancelShare.layer addSublayer:leftBorder];
    }
    return _cancelShare;
}
-(UILabel *)lableShare{
    if (!_lableShare) {
        _lableShare = [[UILabel alloc]initWithFrame:CGRectMake(0, ((394/2-60)-50)/2, __kScreenWidth__, 50)];
        _lableShare.text = @"未检测到可分享APP！";
        _lableShare.font = [UIFont systemFontOfSize:33/2];
        _lableShare.textColor = [UIColor blackColor];
        _lableShare.textAlignment = NSTextAlignmentCenter;
    }
    return _lableShare;
}
@end
