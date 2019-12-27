//
//  GSplayListView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/15.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyGSplayListViewDelegate <NSObject>

-(void)mylistCell_didSelectRowAtIndexPath:(NSInteger)index;
-(void)myplaylistRequestLoadPage:(NSInteger)page;

@end
@interface GSplayListView : UIView
@property(nonatomic, assign) id<MyGSplayListViewDelegate>delegate;
@property (nonatomic,assign) NSInteger  playListIndex;
@property (nonatomic,strong) NSArray * playListData;
@end
