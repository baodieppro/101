//
//  DownloadCell.h
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DownloadCell : UITableViewCell

@property (nonatomic , strong) UIImageView * leftImageView;
@property (nonatomic , strong) UILabel * titleLabel;
@property (nonatomic , strong) UILabel * urlLabel;
@property (nonatomic , strong) UIButton * startButton;//!<开始/暂停
@property (strong, nonatomic) UIProgressView *loadedView;//!<进度条

@property (nonatomic , strong) Download_FMDBDataModel * downLoadModel;//!<数据

@end

NS_ASSUME_NONNULL_END
