//
//  GSplayListViewCell.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/15.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSplayListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setCurrentLabelAlpha_PlayListIndex:(NSInteger)alpha;

@end
