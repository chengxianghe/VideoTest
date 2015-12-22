//
//  MoviePlayer.h
//  MoviePlayer
//
//  Created by lanou on 15/11/6.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionVerticalNone,
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMovedVolume,
    PanDirectionVerticalMovedBrightness
};

//typedef NS_ENUM(NSInteger, MovieOrientation) {
//    MovieOrientationPortrait,
//    MovieOrientationLandscape
//    
//};

@protocol MoviePlayerDelegate <NSObject>

- (void)onMoviePlayerBackAction;

@end

@interface MoviePlayer : UIView

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

@end

