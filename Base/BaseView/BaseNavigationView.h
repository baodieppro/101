//
//  BaseNavigationView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/18.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "BaseView.h"

@interface BaseNavigationView : BaseView
@property (nonatomic ,strong) UIButton * backButton;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,assign) CGFloat topheight;

@end
