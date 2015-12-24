//
//  MoviePlayerHeader.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//

#ifndef MoviePlayerHeader_h
#define MoviePlayerHeader_h

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionVerticalNone,
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMovedVolume,
    PanDirectionVerticalMovedBrightness
};

// 枚举值，包含播放状态
typedef NS_ENUM(NSInteger, PlayState){
    PlayStateUnknow,
    PlayStatePause,
    PlayStatePlaying,
    PlayStateHome,
    PlayStateEnd
};


@protocol MoviePlayerDelegate <NSObject>

/**
 *  竖屏点击返回
 */
- (void)moviePlayerOnBackAction;

/**
 *  播放结束
 */
- (void)moviePlayerCompletionAction:(id)player;

@end

#define kNeedHudTip [@YES boolValue]

// 默认竖屏播放比例
#define kScaleRadio (16/9.0)
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#endif /* MoviePlayerHeader_h */
