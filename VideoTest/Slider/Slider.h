//
//  Slider.h
//  ProgressSlider
//
//  Created by lanou on 15/11/9.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProgressDelegate <NSObject>
// 点击view后返回的value
- (void)touchView:(float)value;
- (void)progressAction:(CGFloat)progress;

@end
@interface Slider : UIView


@property (nonatomic, strong) UIView *thumbView; // 滑块

@property (nonatomic, assign) id<ProgressDelegate> delegate;

/**
 *  缓冲的进度
 */
@property (nonatomic, assign) CGFloat cacheProgress; //
@property (nonatomic, assign) CGFloat value;     //
@property (nonatomic, assign) CGFloat maximumValue;     //
@property (nonatomic, assign) CGFloat minimumValue;     //
@property (nonatomic, assign) BOOL highlighted;     // 

@end
