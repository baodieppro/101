//
//  GSActionSheet.m
//  爷爷网
//
//  Created by 巩小鹏 on 2019/5/16.
//  Copyright © 2019 GrandqaNet. All rights reserved.
//

#import "GSActionSheet.h"

#define GS_ACTIONSHEET_ACTION_HEIGHT            50
#define GS_ACTIONSHEET_SECTION_HEADER_HEIGHT    0.00f
#define GS_ACTIONSHEET_Bottom_Height ([[UIScreen mainScreen] bounds].size.height >= 812.0 ? 22 : 0)

#define GS_LINE_COLOR                           [UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1]
#define GS_ONE_PIXEL_SEPERATOR_HEIGHT           ([[UIScreen mainScreen] scale]>1.0?([[UIScreen mainScreen] scale]>2.0?1.0/3:1.0/2):1.0)

@interface GSActionSheet ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *bodyView;
@property (nonatomic, strong) NSMutableArray *actionSheetTitles;

- (void)clickBodyView:(id)sender;

@end

@implementation GSActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.actionSheetTitles = [NSMutableArray array];
        
        self.bodyView = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.bodyView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
        [self.bodyView addTarget:self action:@selector(clickBodyView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bodyView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.bodyView addSubview:self.tableView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 withDelegate:(id)delegate
                 actionTitles:(NSString *)actionTitles, ...NS_REQUIRES_NIL_TERMINATION {
    
    if ([self initWithFrame:CGRectZero]) {
        self.delegate = delegate;
        
        self.actionSheetTitle = title;
        va_list args;
        va_start(args, actionTitles);
        for (NSString *arg = actionTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self.actionSheetTitles addObject:arg];
        }
        va_end(args);
        [self.tableView reloadData];
    }
    return self;
}

#pragma mark - table delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.actionSheetTitles count];
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"customActionSheetCellIdentifier";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *selectedbackgroundView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        [selectedbackgroundView setBackgroundColor:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]];
        [cell setSelectedBackgroundView:selectedbackgroundView];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:68.0 / 255.0 green:68.0 / 255.0 blue:68.0 / 255.0 alpha:1]];
        [cell.textLabel setHighlightedTextColor:[UIColor colorWithRed:68.0 / 255.0 green:68.0 / 255.0 blue:68.0 / 255.0 alpha:1]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    UIImageView *imgLineBottom = [[UIImageView alloc] init];
    imgLineBottom.backgroundColor = GS_LINE_COLOR;
    [cell addSubview:imgLineBottom];
    if (indexPath.section == 0) {
        imgLineBottom.frame = CGRectMake(0, GS_ACTIONSHEET_ACTION_HEIGHT-1, CGRectGetWidth(tableView.frame), 1);

        cell.textLabel.text = self.actionSheetTitles[indexPath.row];
    } else {
        imgLineBottom.frame = CGRectMake(0, GS_ACTIONSHEET_ACTION_HEIGHT+GS_ACTIONSHEET_Bottom_Height-1, CGRectGetWidth(tableView.frame), 1);

        [cell.textLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
        [cell.textLabel setHighlightedTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
        cell.textLabel.text = NSLocalizedString(@"取消", nil);
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            return GS_ACTIONSHEET_ACTION_HEIGHT+GS_ACTIONSHEET_Bottom_Height;
            break;
            
        default:
            break;
    }
    return GS_ACTIONSHEET_ACTION_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return GS_ACTIONSHEET_SECTION_HEADER_HEIGHT;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, GS_ACTIONSHEET_SECTION_HEADER_HEIGHT)];
        [headerView setBackgroundColor:[UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1]];
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    long row = 0;
    if (indexPath.section == 0) {
        row = indexPath.row;
    } else {
        row = [self.actionSheetTitles count] + 1;
    }
    [self clickBodyView:nil];
    if (indexPath.section == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(GSActionSheetCanceld:)]) {
            [self.delegate GSActionSheetCanceld:self];
        }
    } else {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(GSActionSheet:actionAtIndex:)]) {
            [self.delegate GSActionSheet:self actionAtIndex:row];
        }
    }
}

- (NSInteger)addActionWithTitle:(NSString *)title {
    [self.actionSheetTitles addObject:title];
    return [self.actionSheetTitles count];
}

- (void)clickBodyView:(id)sender {
    float tableViewHeight = (([self.actionSheetTitles count] + 1) * GS_ACTIONSHEET_ACTION_HEIGHT + GS_ACTIONSHEET_SECTION_HEADER_HEIGHT);
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [self setAlpha:0];
                         [self.tableView setFrame:CGRectMake(0,
                                                             self.frame.size.height,
                                                             self.frame.size.width,
                                                             tableViewHeight)];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)showInView:(UIView *)parentView {
    [self setFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    [self.bodyView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    float actionSheetTitleHeight = self.actionSheetTitle && [self.actionSheetTitle length] > 0 ? GS_ACTIONSHEET_ACTION_HEIGHT : 0;
    
    if (actionSheetTitleHeight > 0
        && !self.tableView.tableHeaderView) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, GS_ACTIONSHEET_ACTION_HEIGHT)];
        [titleLabel setText:self.actionSheetTitle];
        [titleLabel setTextColor:[UIColor colorWithRed:68.0 / 255.0 green:68.0 / 255.0 blue:68.0 / 255.0 alpha:1]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.tableView setTableHeaderView:titleLabel];
    }
    
    float tableViewHeight = ([self.actionSheetTitles count] + 1) * GS_ACTIONSHEET_ACTION_HEIGHT + GS_ACTIONSHEET_SECTION_HEADER_HEIGHT + actionSheetTitleHeight;
    [self.tableView setFrame:CGRectMake(0,
                                        self.frame.size.height,
                                        self.frame.size.width,
                                        tableViewHeight)];
    [self setAlpha:0];
    [parentView addSubview:self];
    [parentView bringSubviewToFront:self];
    NSInteger tabbarHeight = 0;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:1];
                         [self.tableView setFrame:CGRectMake(0,
                                                             self.frame.size.height - tableViewHeight - tabbarHeight-GS_ACTIONSHEET_Bottom_Height,
                                                             self.frame.size.width,
                                                             tableViewHeight+GS_ACTIONSHEET_Bottom_Height)];
                     }
                     completion:^(BOOL finished) {}];
}

- (void)dealloc {
    self.delegate = nil;
}
@end
