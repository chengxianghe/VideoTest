//
//  MyIndicatorView.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BrightnessHUDStyle) {
    BrightnessHUDStyleBlack,
    BrightnessHUDStyleLight
};
@interface BrightnessHUD : UIView

- (void)setProgress:(CGFloat)progress;

@end

@interface VideoProgressHUD : UIView

- (void)showWithVideoProgress:(CGFloat)progress text:(NSAttributedString *)text isForward:(BOOL)isForward;

@end


@interface MyIndicatorView : UIActivityIndicatorView

@end



@interface ProgressView : UIView

- (instancetype)initWithTintImage:(NSString *)tintImage BackImage:(NSString *)backImage;

- (instancetype)initWithTintColor:(UIColor *)tintColor BackColor:(UIColor *)backColor;

- (void)setProgress:(CGFloat)progress;

@end
