//
//  MoviePlayer.h
//  MoviePlayer
//
//  Created by lanou on 15/11/6.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

/**
 *  视频播放控件, MP框架 实现
 */
#import <UIKit/UIKit.h>
#import "MoviePlayerHeader.h"

@interface MoviePlayer : UIView

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

