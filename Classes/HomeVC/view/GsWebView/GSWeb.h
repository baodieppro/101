//
//  GSWeb.h
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#ifndef GSWeb_h
#define GSWeb_h

#define __kWeakSelf__ __weak typeof(self) weakSelf = self;

#import "GSStaticModel.h"
#import "GSTool.h"
#import "GSPanLoad.h"
#import "GSWebView.h"
#import "GSWebProgressLayer.h"

//=============================== 进度条颜色 =====================================

#define __Web_ProgressColor__ @"#FFD454"

//===============================仿 UC 左右滑动 返回或加载 =====================================

#define __PanLoad_LeftImageName__   @""
#define __PanLoad_RightImageName__  @""

#endif /* GSWeb_h */
