//
//  AVMoviePlayer.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//

/**
 *  视频播放控件, AV框架 实现
 */
#import <UIKit/UIKit.h>
#import "MoviePlayerHeader.h"


@interface AVMoviePlayer : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIButton *backBtn;     //返回按钮
@property (nonatomic, strong) NSTimer *timer; // 定时器
@property (nonatomic, weak) id <MoviePlayerDelegate> delegate;     //

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;

/**
 *  销毁播放器
 */
- (void)stopPlay;

- (void)pausePlay;

- (void)continuePlay;

- (BOOL)isPlaying;

@end
