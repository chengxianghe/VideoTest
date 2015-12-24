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

@property (nonatomic, weak) id <MoviePlayerDelegate> delegate;     //

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title URL:(NSURL *)url;

/** 销毁播放器 */
- (void)stopPlay;

/** 暂停播放器 */
- (void)pausePlay;

/** 继续播放 */
- (void)continuePlay;

/** 是否正在播放 */
- (BOOL)isPlaying;

@end
