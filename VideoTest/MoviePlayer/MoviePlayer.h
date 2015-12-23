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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id <MoviePlayerDelegate> delegate;     //

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;

/**
 *  销毁播放器
 */
- (void)stopPlay;

- (void)pausePlay;

- (void)continuePlay;

@end

