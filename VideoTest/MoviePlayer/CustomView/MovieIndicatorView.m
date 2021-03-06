//
//  MyIndicatorView.m
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import "MovieIndicatorView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
#define MYCOLOR [UIColor blackColor]
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define kLoadBundleImage(image) [NSString stringWithFormat:@"SystemHUD.bundle/%@", image]

@implementation MovieIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 菊花背景的大小
        self.frame = CGRectMake(kWidth/2-50, KHeight/2-50, 100, 100);
        // 菊花的背景色
        self.backgroundColor = MYCOLOR;
        self.layer.cornerRadius = 10;
        // 菊花的颜色和格式（白色、白色大、灰色）
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        // 在菊花下面添加文字
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 40)];
        label.text = @"loading...";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    return self;
}

@end

@interface SystemHUD()

@property (nonatomic, strong) UILabel *textLabel;     //
@property (nonatomic, strong) UIImageView *imageView;     //
@property (nonatomic, strong) ProgressView *progressView;     //

@end

@implementation SystemHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 158, 158);
        self.center = CGPointMake(kWidth/2, KHeight/2);
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        
        CGFloat width = self.frame.size.width - 20;

        self.textLabel = [[UILabel alloc]init];
        self.textLabel.frame = CGRectMake(10, 10, width, 20);
        self.textLabel.text = @"亮度";
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        [self addSubview:self.textLabel];
        
        self.imageView = [[UIImageView alloc] init];
        CGFloat imageW = 80;
        self.imageView.frame = CGRectMake((self.frame.size.width-imageW)/2, (self.frame.size.height-imageW)/2, imageW, imageW);

        [self addSubview:self.imageView];
        
        self.progressView = [[ProgressView alloc] init];
        self.progressView.frame = CGRectMake(0, 0, 136, 30);
        self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 20);
        [self addSubview:self.progressView];
        
        self.style = SystemHUDStyleBrightness;
        self.mode = SystemHUDShowModeBlack;

        if (iOS8Later) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurView.frame = self.bounds;
            [self insertSubview:blurView atIndex:0];
            self.backgroundColor = [UIColor clearColor];
        }

    }
    return self;
}

- (void)setStyle:(SystemHUDStyle)style {
    _style = style;
    
    if (style == SystemHUDStyleBrightness) {
        self.textLabel.text = @"亮度";
    } else if (style == SystemHUDStyleVolume) {
        self.textLabel.text = @"音量";
    }
    
}

- (void)setMode:(SystemHUDShowMode)mode {
    _mode = mode;
    
    NSString *progressTine = kLoadBundleImage(@"progress");
    NSString *progressBack = kLoadBundleImage(@"progress_bg");

    if (mode == SystemHUDShowModeLight) {
        self.textLabel.textColor = [UIColor whiteColor];
        [self.progressView setTintImage:progressTine BackImage:progressBack];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
        [self.progressView setTintImage:progressTine BackImage:progressBack];
    }
}

- (void)setProgress:(CGFloat)progress {
    
    if (_style == SystemHUDStyleVolume) {
        NSMutableString *imageName = [NSMutableString stringWithString:@"volume"];
        [imageName appendString:progress <= 0 ? @"_close" : @""];
        [imageName appendString:_mode == SystemHUDShowModeLight ? @"_light" : @"_dark"];

        self.imageView.image = [UIImage imageNamed:kLoadBundleImage(imageName)];
        
    } else {
        if (_mode == SystemHUDShowModeLight) {
            self.imageView.image = [UIImage imageNamed:kLoadBundleImage(@"brightness_light")];
        } else {
            self.imageView.image = [UIImage imageNamed:kLoadBundleImage(@"brightness_dark")];
        }
    }
    
    [self.progressView setProgress:progress];
}

/**
 *      if (style == SystemHUDStyleBrightness) {
 imageName = @"playgesture_BrightnessSun6";
 progressTine = @"playgesture_BrightnessProgress";
 progressBack = @"playgesture_BrightnessProgressBg";
 } else if (style == SystemHUDStyleBrightnessLight) {
 imageName = @"playgesture_BrightnessSun";
 progressTine = @"playgesture_BrightnessProgress";
 progressBack = @"playgesture_BrightnessProgressBg";
 } else if (style == SystemHUDStyleVolumeBlack) {
 imageName = @"playgesture_volume_light";
 progressTine = @"playgesture_BrightnessProgress";
 progressBack = @"playgesture_BrightnessProgressBg";
 } else if (style == SystemHUDStyleVolumeLight) {
 imageName = @"playgesture_volume_light";
 progressTine = @"playgesture_BrightnessProgress";
 progressBack = @"playgesture_BrightnessProgressBg";
 }
 */

@end

@interface VideoProgressHUD()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ProgressView *progressView;

@end

@implementation VideoProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 160, 100);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        
        CGFloat width = self.frame.size.width - 20;
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kLoadBundleImage(@"forward")]];
        self.imageView.frame = CGRectMake(0, 0, 30, 30);
        self.imageView.center = CGPointMake(self.center.x, 30);
        
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, width, 40)];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.text = @"00:00 / --:--";
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];

        self.progressView = [[ProgressView alloc] init];
        [self.progressView setTintColor:[UIColor blueColor] BackColor:[UIColor clearColor]];
        self.progressView.frame = CGRectMake(0, 0, width, 3);
        self.progressView.center = CGPointMake(self.center.x, self.frame.size.height - 10);

        [self addSubview:self.progressView];
        
        if (iOS8Later) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurView.frame = self.bounds;
            [self insertSubview:blurView atIndex:0];
            self.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (void)showWithVideoProgress:(CGFloat)progress text:(NSAttributedString *)text isForward:(BOOL)isForward {
    
    self.imageView.image = [UIImage imageNamed:isForward ? kLoadBundleImage(@"forward") : kLoadBundleImage(@"rewind")];
    [self.progressView setProgress:progress];
    self.textLabel.attributedText = text;
}

@end


@interface ProgressView ()

@property (nonatomic, strong) UIImageView *tintImageView;     //
@property (nonatomic, strong) UIImageView *backImageView;     //

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintImageView = [[UIImageView alloc] init];
        self.backImageView = [[UIImageView alloc] init];
        self.tintImageView.contentMode = UIViewContentModeLeft;
        self.tintImageView.clipsToBounds = YES;
        self.backImageView.contentMode = UIViewContentModeLeft;
        self.backImageView.clipsToBounds = YES;
        [self addSubview:self.backImageView];
        [self addSubview:self.tintImageView];

    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor BackColor:(UIColor *)backColor {
    self.tintImageView.backgroundColor = tintColor;
    self.backImageView.backgroundColor = backColor;
}

- (void)setTintImage:(NSString *)tintImage BackImage:(NSString *)backImage {
    self.tintImageView.image = [UIImage imageNamed:tintImage];
    self.backImageView.image = [UIImage imageNamed:backImage];
}

- (void)setProgress:(CGFloat)progress {
    self.backImageView.frame = self.bounds;
    self.tintImageView.frame = CGRectMake(0, 0, self.bounds.size.width * progress, self.bounds.size.height);
}

@end
