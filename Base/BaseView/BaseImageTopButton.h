//
//  BaseImageTopButton.h
//  CCQMEnglish
//
//  Created by Roger on 2019/9/24.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseImageTopButton : UIControl
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIImageView * imageView;
-(void)titleTopOffset:(CGFloat)offset;

@end
