//
//  GSTableView.m
//  爷爷网
//
//  Created by 巩小鹏 on 2019/5/26.
//  Copyright © 2019 GrandqaNet. All rights reserved.
//

#import "GSTableView.h"
@interface GSTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath * _lastCellIndex;
}
@end
@implementation GSTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
   self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource =self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        /// 自动关闭估算高度，不想估算那个，就设置那个即可
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        [self setSeparatorColor:[UIColor clearColor]];
//        self.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        self.backgroundColor = [UIColor  clearColor];
    }
    return self;
}
-(instancetype)init{
   self = [super init];
    if (self) {

    }
    return self;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self GS_numberOfSectionsInTableView:tableView];
}
//显示有几个Cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self GS_tableView:tableView numberOfRowsInSection:section];
}
//数据交互
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            GSLog(@"最后一个cell %ld",indexPath.row);
            _lastCellIndex= indexPath;
        }
    GSLog(@"[tableView numberOfRowsInSection:indexPath.section]:%ld",[tableView numberOfRowsInSection:indexPath.section]);
    return [self GS_tableView:tableView cellForRowAtIndexPath:indexPath LastCellIndex:_lastCellIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self GS_tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self GS_tableView:tableView heightForHeaderInSection:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self GS_tableView:tableView heightForFooterInSection:section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self GS_tableView:tableView didSelectRowAtIndexPath:indexPath];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self GS_tableView:tableView viewForHeaderInSection:section];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self GS_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - newDelegate

-(NSInteger) GS_numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_numberOfSectionsInTableView:)]) {
      return [self.GSDelegate gs_numberOfSectionsInTableView:(GSTableView *)tableView];
    }
    return 1;
}
- (NSInteger)GS_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:numberOfRowsInSection:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView numberOfRowsInSection:section];
    }
    return 0;
}
- (UITableViewCell *)GS_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath LastCellIndex:(NSIndexPath *)LastCellIndex
{
    //多返回了一个最后cell的坐标
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:cellForRowAtIndexPath:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView cellForRowAtIndexPath:indexPath];
    }
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:cellForRowAtIndexPath:LastCellIndex:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView cellForRowAtIndexPath:indexPath LastCellIndex:LastCellIndex];
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
}
- (CGFloat)GS_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:heightForRowAtIndexPath:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView heightForRowAtIndexPath:indexPath];
    }
    return 0.00f;
}
- (CGFloat)GS_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:heightForHeaderInSection:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView heightForHeaderInSection:section];
    }
    return 0.00f;
}
- (CGFloat)GS_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:heightForFooterInSection:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView heightForFooterInSection:section];
    }
     return 0.00f;
}
-(UIView *)GS_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:viewForHeaderInSection:)]) {
        return [self.GSDelegate gs_tableView:(GSTableView *)tableView viewForHeaderInSection:section];
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
    
    
-(void)GS_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:didSelectRowAtIndexPath:)]) {
        [self.GSDelegate gs_tableView:(GSTableView *)tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)GS_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.GSDelegate respondsToSelector:@selector(gs_tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.GSDelegate gs_tableView:(GSTableView *)tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }else{
        [self gstableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}
    
#pragma mark -私有方法
- (void)gstableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView numberOfRowsInSection:indexPath.section] == 1 && indexPath.row == 0) {
        //只有一个cell的时候进入
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 15;
    }else{
        //刷新cell的时候把第一个圆角恢复
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 0;
        if ([cell respondsToSelector:@selector(tintColor)]) {
                // 圆角弧度半径
                CGFloat cornerRadius = 15.f;
                // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
                cell.backgroundColor = UIColor.clearColor;
                
                // 创建一个shapeLayer
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
                // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
                CGMutablePathRef pathRef = CGPathCreateMutable();
                // 获取cell的size
                CGRect bounds = CGRectInset(cell.bounds, 0, 0);
                
                // CGRectGetMinY：返回对象顶点坐标
                // CGRectGetMaxY：返回对象底点坐标
                // CGRectGetMinX：返回对象左边缘坐标
                // CGRectGetMaxX：返回对象右边缘坐标
                
                // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
                BOOL addLine = NO;
                // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                if (indexPath.row == 0) {
                    // 初始起点为cell的左下角坐标
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                    // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    addLine = YES;
                }
                else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    // 初始起点为cell的左上角坐标
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                }
                else
                {
                    // 添加cell的rectangle信息到path中（不包括圆角）
                    CGPathAddRect(pathRef, nil, bounds);
                    addLine = YES;
                }
                
                
                // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
                layer.path = pathRef;
                backgroundLayer.path = pathRef;
                // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
                CFRelease(pathRef);
                // 按照shape layer的path填充颜色，类似于渲染render
                // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
                layer.fillColor = [UIColor whiteColor].CGColor;
                // 添加分隔线图层
                if (addLine == YES) {
                    CALayer *lineLayer = [[CALayer alloc] init];
                    CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                    // 分隔线颜色取自于原来tableview的分隔线颜色
                    lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                    [layer addSublayer:lineLayer];
                }
                
                // view大小与cell一致
                UIView *roundView = [[UIView alloc] initWithFrame:bounds];
                // 添加自定义圆角后的图层到roundView中
                [roundView.layer insertSublayer:layer atIndex:0];
                roundView.backgroundColor = UIColor.clearColor;
                //cell的背景view
                //cell.selectedBackgroundView = roundView;
                cell.backgroundView = roundView;
                
                //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
                UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
                backgroundLayer.fillColor = tableView.separatorColor.CGColor;
                [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
                selectedBackgroundView.backgroundColor = UIColor.clearColor;
                cell.selectedBackgroundView = selectedBackgroundView;
            }
        
    }
    
}
-(void)layerbottom:(UIView *)view{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    
    [shapeLayer setLineWidth:1.3f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:2], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //这两个是设置横线两端的起始位置
    CGPathMoveToPoint(path, NULL, 20, 80);
    CGPathAddLineToPoint(path, NULL, width-60, 80);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[view layer] addSublayer:shapeLayer];
}
@end
