//
//  MovieSlider.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol ProgressDelegate <NSObject>

// 点击view后返回的value
- (void)touchView:(float)value;
- (void)progressAction:(CGFloat)progress;

@end

@interface MovieSlider : UIView

@property (nonatomic, strong) UIImageView *thumbView; // 滑块
@property (nonatomic, weak) id<ProgressDelegate> delegate;

/**
 *  缓冲的进度
 */
@property (nonatomic, assign) CGFloat cacheProgress; //
@property (nonatomic, assign) CGFloat value;     //
@property (nonatomic, assign) CGFloat maximumValue;     //
@property (nonatomic, assign) CGFloat minimumValue;     //
@property (nonatomic, assign) BOOL highlighted;     // 

@end
