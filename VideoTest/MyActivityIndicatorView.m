//
//  MyActivityIndicatorView.m
//  DouBan
//
//  Created by lanou on 15/10/26.
//  Copyright (c) 2015年 UI. All rights reserved.
//

#import "MyActivityIndicatorView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
#define MYCOLOR [UIColor blackColor]


@interface BrightnessHUD()
@property (nonatomic, strong) UILabel *textLabel;     // <#注释#>
@property (nonatomic, strong) UIImageView *imageView;     // <#注释#>
@property (nonatomic, strong) ProgressView *progressView;     // <#注释#>
@end

@implementation BrightnessHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 160, 170);
        self.center = CGPointMake(kWidth/2, KHeight/2);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.alpha = 0.8;
        
        CGFloat width = self.frame.size.width - 20;

        // 在菊花下面添加文字
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.frame = CGRectMake(10, 10, width, 20);
        self.textLabel.text = @"亮度";
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        [self addSubview:self.textLabel];
        
        
//        if (style == BrightnessHUDStyleBlack) {
//            [self sharedInstance].imageView.image = [UIImage imageNamed:@"playgesture_BrightnessSun6"];
//        } else {
//            [self sharedInstance].imageView.image = [UIImage imageNamed:@"playgesture_BrightnessSun"];
//        }
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playgesture_BrightnessSun6"]];
        CGFloat imageW = 80;
        self.imageView.frame = CGRectMake((self.frame.size.width-imageW)/2, (self.frame.size.height-imageW)/2, imageW, imageW);

        [self addSubview:self.imageView];
        
        self.progressView = [[ProgressView alloc] initWithTintImage:@"playgesture_BrightnessProgress" BackImage:@"playgesture_BrightnessProgressBg"];
        self.progressView.frame = CGRectMake(8, self.frame.size.height - 40, 150, 30);
        [self addSubview:self.progressView];
        
    }
    return self;
}


- (void)setProgress:(CGFloat)progress {
    [self.progressView setProgress:progress];
}

@end

@interface VideoProgressHUD()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ProgressView *progressView;

@end

@implementation VideoProgressHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 160, 100);
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        self.alpha = 0.8;
        
        CGFloat width = self.frame.size.width - 20;
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kuaijin"]];
        self.imageView.frame = CGRectMake(0, 0, 30, 30);
        self.imageView.center = CGPointMake(self.center.x, 30);
        
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, width, 40)];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.text = @"00:00 / --:--";
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];

        self.progressView = [[ProgressView alloc] initWithTintColor:[UIColor blueColor] BackColor:[UIColor clearColor]];
        self.progressView.frame = CGRectMake(0, 0, width, 3);
        self.progressView.center = CGPointMake(self.center.x, self.frame.size.height - 10);

        [self addSubview:self.progressView];
    }
    return self;
}

- (void)showWithVideoProgress:(CGFloat)progress text:(NSString *)text isForward:(BOOL)isForward {
    
    NSString *imageName = isForward ? @"kuaijin" : @"kuaitui";
    
    self.imageView.image = [UIImage imageNamed:imageName];
    self.textLabel.text = text;
    [self.progressView setProgress:progress];
}

@end


@interface ProgressView ()

@property (nonatomic, strong) UIImageView *tintImageView;     //
@property (nonatomic, strong) UIImageView *backImageView;     //

@end

@implementation ProgressView

- (instancetype)init
{
    self = [super init];
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

- (instancetype)initWithTintColor:(UIColor *)tintColor BackColor:(UIColor *)backColor {
    self = [self init];
    if (self) {
        self.tintImageView.backgroundColor = tintColor;
        self.backImageView.backgroundColor = backColor;
    }
    return self;
}

- (instancetype)initWithTintImage:(NSString *)tintImage BackImage:(NSString *)backImage {
    self = [self init];
    if (self) {
        self.tintImageView.image = [UIImage imageNamed:tintImage];
        self.backImageView.image = [UIImage imageNamed:backImage];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    self.backImageView.frame = self.bounds;
    self.tintImageView.frame = CGRectMake(0, 0, self.bounds.size.width * progress, self.bounds.size.height);
}

@end

@implementation MyActivityIndicatorView

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
    return  self;
}

@end
