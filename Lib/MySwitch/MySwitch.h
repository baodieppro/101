//
//  MySwitch.h
//  SuperSearch
//
//  Created by 巩小鹏 on 2018/5/15.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock) (BOOL OnStatus);

@protocol MySwitchDelegate

- (void)onStatusDelegate;

@end
@interface MySwitch : UIControl
{
    //背景View 滑块View
    UIImageView *UIImageViewBack,*UIImageViewBlock;
    //背景图片 滑块右图片 滑块左图片
    UIImage *UIImageBack,*UIImageSliderRight,*UIImageSliderLeft;
    
    UILabel *UIlableSliderRight,*UIlableSliderLeft;
}



//Switch 返回开关量block
@property (nonatomic,copy) MyBlock myBlock;
//Switch 返回开关量delegate
@property (nonatomic) id delegate;
//Switch 开关状态
@property (nonatomic) BOOL OnStatus;
//Switch 长 宽 滑块半径
@property (nonatomic) CGFloat Width,Height,CircleR;
//滑块距离边框边距
@property (nonatomic) CGFloat Gap;
/*
 * 带有block 初始化
 * @param frame
 * @param gap 滑块距离边框的距离
 * @param block
 */
- (id)initWithFrame:(CGRect)frame withGap:(CGFloat)gap statusChange:(MyBlock)block;
/*
 * 初始化
 * @param frame
 * @param gap 滑块距离边框的距离
 */
- (id)initWithFrame:(CGRect)frame withGap:(CGFloat)gap;
//设置背景图片
-(void)setBackgroundImage:(UIImage *)image;
//设置左滑块图片
-(void)setLeftBlockImage:(UIImage *)image;
//设置右滑块图片
-(void)setRightBlockImage:(UIImage *)image;

/*
 *  title 初始化
 * @param items titleArr
 */
- (instancetype)initWithItems:(NSArray *)items;

//Switch 圆角
@property (nonatomic) BOOL myCornerRadius;

@property(nonatomic) NSInteger selectedSegmentIndex;

@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, strong) UIColor  *selectedTitleColor;

@property (nonatomic, strong) UIFont   *titleFont;

@property (nonatomic, assign) CGFloat  spacing; // label之间的间距
@property (nonatomic, assign) CGFloat  contentInset; // 内容内宿边距

@property (nonatomic, copy) UIColor *trackerColor; // 滑块的颜色
@property (nonatomic, copy) UIImage *trackerImage; // 滑块的图片

@property (nonatomic, strong) UIColor  *selectedLeftColor;
@property (nonatomic, strong) UIColor  *selectedRightColor;

    
  
@end
