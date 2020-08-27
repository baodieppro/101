//
//  QRCodeViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//==

#import "QRCodeViewController.h"
#import "GSQRCodeView.h"

@interface QRCodeViewController ()<GSScanViewDelegate>
@property (nonatomic,strong) GSQRCodeView * qrCodeView;
@end

@implementation QRCodeViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self g_init];
    [self g_addUI];
    [self g_layoutFrame];
}
- (void)g_init{
//    self.myView.backgroundColor = [UIColor clearColor];
}
- (void)g_addUI{
    [self.myView addSubview:self.qrCodeView];
}
- (void)g_layoutFrame{

}
#pragma mark - delegate
-(void)getScanDataString:(NSString*)scanDataString{
    
    NSLog(@"二维码内容：%@",scanDataString);
    //    [SecurityStrategy addBlurEffect];
    
        if(self.delegate && [self.delegate respondsToSelector:@selector(getQRDataString:)])
        {
            [self.delegate getQRDataString:scanDataString];
        }
        [self newGsBack];
    
    
}
-(void)newGsBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 懒加载
-(GSQRCodeView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView = [[GSQRCodeView alloc]initWithFrame:CGRectMake(0, 0, __kScreenWidth__, __kScreenHeight__)];
        _qrCodeView.delegate = self;
//        [_qrCodeView.fuzhi addTarget:self action:@selector(fuzhiClick) forControlEvents:UIControlEventTouchUpInside];
//        [_qrCodeView.fanhui addTarget:self action:@selector(fanhuiClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _qrCodeView;
}

@end
