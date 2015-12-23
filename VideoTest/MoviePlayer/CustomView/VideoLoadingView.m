//
//  VideoLoadingView.m
//  CXHVideoRecoder
//
//  Created by chengxianghe on 15/8/9.
//  Copyright (c) 2015年 CXH. All rights reserved.
//

#import "VideoLoadingView.h"

#define ProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

@implementation VideoLoadingView
{
    CGFloat _angleInterval;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色设置
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (progress >= 1) {
        [self removeFromSuperview];
    } else {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    CGFloat lineWidth = 1;
    
    // 进度环边框 白色背景
    [[UIColor whiteColor] set];
    CGFloat to = - M_PI * 1.6 + _angleInterval; // 初始值0.05
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - lineWidth;
    CGContextSetLineWidth(ctx, lineWidth);
    
    CGFloat w = radius * 2 + 1;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextStrokePath(ctx);
    //
    //    // 白色滑块
    //    [[UIColor whiteColor] set];
    //    CGContextSetLineWidth(ctx, 5);
    //    CGContextSetLineCap(ctx, kCGLineCapRound);
    //    CGContextAddArc(ctx, xCenter, yCenter, radius, _angleInterval, to, 0);
    //    CGContextStrokePath(ctx);
    
    //    // 背景遮罩
    //    [[UIColor clearColor] set];
    //    CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
    //    CGContextSetLineWidth(ctx, lineW);
    //    CGContextAddArc(ctx, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
    //    CGContextStrokePath(ctx);
    
    // 进程圆 -- 清除模式(白色逐渐消失)
    //    [[UIColor clearColor] set];
    //    CGContextSetLineWidth(ctx, 1);
    //    CGContextMoveToPoint(ctx, xCenter, yCenter);
    //    CGContextAddLineToPoint(ctx, xCenter, 0);
    //    to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
    //    CGContextAddArc(ctx, xCenter, yCenter, radius-lineWidth*1.5, - M_PI * 0.5, to, 1);
    //    CGContextClosePath(ctx);
    //
    //    CGContextFillPath(ctx);
    
    // 进程圆 -- 填充模式(白色逐渐填充)
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(ctx, 1);
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius-lineWidth*1.5, - M_PI * 0.5, to, 0);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
    
    // 加载时显示的文字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%s", (self.progress * 100) <= 0 ? 0 : self.progress * 100 , "\%"];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:11 * ProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    [self setCenterProgressText:progressStr withAttributes:attributes];
    
}

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize strSize = [text sizeWithAttributes:attributes];
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    } else {
        CGSize strSize;
        NSAttributedString *attrStr = nil;
        if (attributes[NSFontAttributeName]) {
            //            strSize = [text sizeWithFont:attributes[NSFontAttributeName]];
            
            strSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :attributes[NSFontAttributeName]} context:nil].size;
            
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            //            strSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            
            strSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:[UIFont systemFontSize]]} context:nil].size;
            
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        }
        
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
    }
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

@end

