//
//  YYYMailView.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/27.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYMailView.h"
#import "YYYMailTopView.h"
#import "YYYMail.h"
#import "YYYLetterView.h"
@interface YYYMailView()
@property (nonatomic, strong)YYYMailTopView * topView;
@property (nonatomic, strong)YYYLetterView * letterView;

@end
@implementation YYYMailView

- (instancetype)initWithFrame:(CGRect)frame mail:(YYYMail *)mail
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        CGFloat width=frame.size.width;
        CGFloat height=frame.size.height;
        self.topView=[[YYYMailTopView alloc] initWithFrame:CGRectMake(0, -height+5, width, 2*height)];
        [self addSubview:self.topView];
        self.letterView=[[YYYLetterView alloc] initWithMail:mail];
        self.letterView.frame=self.frame;
        
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
    [[UIColor whiteColor] setFill];
    // 设直线条宽度
    [path setLineWidth:w*2];
    // 设置起点
    [path moveToPoint:CGPointMake(w,w)];
    // 添加点
    [path addLineToPoint:CGPointMake(w, rect.size.height-w)];
    [path addLineToPoint:CGPointMake(rect.size.width-w, rect.size.height-w)];
    [path addLineToPoint:CGPointMake(rect.size.width-w, w)];
    // 封闭路径
    [path closePath];
    // 开始绘制
    [path fill];
    [path stroke];
    //画上面的三角形
    [path moveToPoint:CGPointMake(rect.size.width-w, w)];
    [path addLineToPoint:CGPointMake(rect.size.width/2, rect.size.height/2+topCount*w)];
    [path addLineToPoint:CGPointMake(w, w)];
    [path fill];
    [path stroke];
    [path removeAllPoints];
    //画下面的三角形
    [path moveToPoint:CGPointMake(rect.size.width-w, rect.size.height-w)];
    [path addLineToPoint:CGPointMake(rect.size.width/2, rect.size.height/2-topCount*w)];
    [path addLineToPoint:CGPointMake(w, rect.size.height-w)];
    [path closePath];
    [path fill];
    [path stroke];
    
}
-(void)animate{
    [self.superview addSubview:self.letterView];
    [self.superview insertSubview:self.letterView atIndex:3];
    [UIView animateWithDuration:0.5 animations:^{
        self.topView.transform=CGAffineTransformScale(self.transform, 1, -1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            CGRect f=self.letterView.frame;
            f.origin.y-=self.frame.size.height*2;
            [self.letterView setFrame:f];
        } completion:^(BOOL finished) {
            [self.superview bringSubviewToFront:self.letterView];
            [UIView animateWithDuration:1 animations:^{
                CGRect f=self.letterView.frame;
                f.origin.y-=self.frame.size.height;
                [self.letterView setFrame:f];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1 animations:^{
                    [self.letterView setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height)];
                } completion:^(BOOL finished) {
                    NSLog(@"动画完成");
                    [self removeFromSuperview];
                }];
                
            }];
        }];
    }];
}

@end
