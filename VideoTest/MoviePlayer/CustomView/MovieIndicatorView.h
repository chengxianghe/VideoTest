//
//  MyIndicatorView.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//

/**
 *  视频需要的各种提示框
 */

#import <UIKit/UIKit.h>


/**
 *  视频加载loading HUD
 */
@interface MovieIndicatorView : UIActivityIndicatorView

@end

typedef NS_ENUM(NSInteger, BrightnessHUDStyle) {
    BrightnessHUDStyleBlack,
    BrightnessHUDStyleLight
};

/**
 *  系统亮度 HUD
 */
@interface BrightnessHUD : UIView

@property (nonatomic, assign) BrightnessHUDStyle style; // 展示样式

- (void)setProgress:(CGFloat)progress;

@end

/**
 *  视频快进快退 HUD
 */
@interface VideoProgressHUD : UIView

- (void)showWithVideoProgress:(CGFloat)progress text:(NSAttributedString *)text isForward:(BOOL)isForward;

@end

/**
 *  视频进度条 配合上面HUD展示
 */
@interface ProgressView : UIView

- (void)setTintImage:(NSString *)tintImage BackImage:(NSString *)backImage;

- (void)setTintColor:(UIColor *)tintColor BackColor:(UIColor *)backColor;

- (void)setProgress:(CGFloat)progress;

@end
