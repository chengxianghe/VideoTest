//
//  VideoLoadingView.h
//  CXHVideoRecoder
//
//  Created by chengxianghe on 15/8/9.
//  Copyright (c) 2015年 CXH. All rights reserved.
//

/**
 *  模仿微信视频加载效果
 */
#import <UIKit/UIKit.h>

@interface VideoLoadingView : UIView

@property (nonatomic, assign) CGFloat progress;

// 清除指示器
- (void)dismiss;

@end
