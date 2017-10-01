//
//  YYYMailTopView.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/27.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYMailTopView.h"

@implementation YYYMailTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 设置画笔颜色
    [MailColor setStroke];
    UIBezierPath * path = [[UIBezierPath alloc]init];
    
    CGFloat w=5.0f;
    CGFloat topCount=5;
    // 设置拐角处的效果为圆角
    [path setLineJoinStyle:kCGLineJoinRound];
    // 设置结束处的效果为圆角
    [path setLineCapStyle:kCGLineCapRound];
    // 设直线条宽度
    [path setLineWidth:w*2];
    
    CGFloat height=rect.size.height;
    CGFloat width=rect.size.width;
    // 设置起点
    [path moveToPoint:CGPointMake(w, height/2)];
    // 添加点
    [path addLineToPoint:CGPointMake(width-w, height/2)];
    [path addLineToPoint:CGPointMake(width/2, height/2+height/4+topCount*w)];
    // 封闭路径
    [path closePath];
    
    [[UIColor whiteColor] setFill];
    [path fill];
    // 开始绘制
    [path stroke];
}


@end
