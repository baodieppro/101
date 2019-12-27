//
//  GSDlLNAView.h
//  GSPlay
//
//  Created by Roger on 2019/9/11.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MRDLNA/MRDLNA.h>
@protocol MyDLNAViewDelegate <NSObject>

-(void)gs_dlnaStartPlay:(NSString *)serviceName listIndex:(NSInteger)listIndex;

@end
@interface GSDLNAView : UIView
@property(nonatomic, assign) id<MyDLNAViewDelegate>delegate;
@property (nonatomic,strong) NSString * playUrl;//!<
@property (nonatomic,assign) NSInteger  listIndex;//!<

-(void)startSearchDLNA;
@end
