//
//  AVMoviePlayer.m
//  VideoTest
//
//  Created by chengxianghe on 15/12/23.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import "AVMoviePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MovieIndicatorView.h"
#import "MovieSlider.h"
#import "MovieManager.h"

#define kMakeCMTime(value) (CMTimeMakeWithSeconds(value, self.timescale))

@interface AVMoviePlayer ()<ProgressDelegate>

@property (nonatomic, strong) AVPlayer *moviePlayer; // 视频播放控件
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSTimer   *timer; // 定时器

@property (nonatomic, strong) UIButton  *play; // 播放按钮
@property (nonatomic, strong) UIButton  *backBtn;     //返回按钮
@property (nonatomic, strong) UIButton  *rorateBtn; // 旋转按钮
@property (nonatomic, strong) UILabel   *beginLabel; // 开始的时间label
@property (nonatomic, strong) UILabel   *endLabel; // 结束时间label
@property (nonatomic, strong) UILabel   *titleLabel; // 视频标题
@property (nonatomic, strong) UILabel   *thumbTimeLabel; // 添加到滑块上的时间显示label
@property (nonatomic, strong) UIView    *bottomSliderView; // 进度条和时间label底部的view
@property (nonatomic, strong) UIView    *topBackView; // 视频顶部view

@property (nonatomic, strong) UISlider  *volume; //声音进度条
@property (nonatomic, strong) UISlider  *brightnessSlider; //亮度进度条
@property (nonatomic, strong) UISlider  *volumeSlider; // 用来接收和更改系统音量条
@property (nonatomic, strong) MovieSlider    *progress; // 视频底部进度条

@property (nonatomic, strong) MovieIndicatorView *activity; // 添加菊花动画
@property (nonatomic, strong) BrightnessHUD     *brigntnessHud; // 模仿系统的亮度提示HUD
@property (nonatomic, strong) VideoProgressHUD  *videoProgressHud; // 快进/快退 HUD

@property (nonatomic, assign) UIDeviceOrientation movieOrientation; // 旋转方向
@property (nonatomic,   copy) NSAttributedString *totalTimeStr; //总时间
@property (nonatomic, strong) NSURL *url; // 视频url
@property (nonatomic,   copy) NSString *title; //视频标题

@property (nonatomic, assign) CMTimeScale timescale; // timescale
@property (nonatomic, assign) BOOL isPlayEnd; // 是否播放结束了
@end

@implementation AVMoviePlayer{
    PanDirection panDirection; // 定义一个实例变量，保存枚举值
    CGFloat sumTime; // 用来保存快进的总时长
    BOOL	_isPlayEnd;     // 是否播放结束了
    
}
- (void)dealloc {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title URL:(NSURL *)url {
    
    if (CGRectIsEmpty(frame)) {
        frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/kScaleRadio);
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        self.url = url;
//        self.title = title;
        
        self.movieOrientation = [UIDevice currentDevice].orientation;
        
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        self.moviePlayer = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:movieAsset]];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
//        self.moviePlayer.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        _playerLayer.frame = self.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:_playerLayer];
        
        
        [self configUI];
        
        [self configNotification];
        
        [self addObserverToPlayerItem:self.moviePlayer.currentItem];
        
        
    }
    return self;
}

- (void)configUI {
    // 添加暂停播放按钮
    self.play = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.play setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    self.play.hidden = YES;
    
    // 添加暂停播放方法
    [self.play addTarget:self action:@selector(playMovie:) forControlEvents:UIControlEventTouchUpInside];
    [self.play addTarget:self action:@selector(viewNoDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_play];
    
    // 添加底部进度条和时间显示
    // 1.添加底部view
    self.bottomSliderView = [[UIView alloc]init];
    self.bottomSliderView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    self.bottomSliderView.hidden = YES;
    [self addSubview:self.bottomSliderView];
    
    // 2.添加开始时间label
    self.beginLabel = [[UILabel alloc]init];
    self.beginLabel.textColor = [UIColor whiteColor];
    self.beginLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomSliderView addSubview:_beginLabel];
    
    // 3.添加进度条
    self.progress = [[MovieSlider alloc]init];
    self.progress.delegate = self;
    [self.bottomSliderView addSubview:self.progress];
    
    // 4.添加总时长label
    self.endLabel = [[UILabel alloc]init];
    self.endLabel.textColor = [UIColor whiteColor];
    self.endLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomSliderView addSubview:self.endLabel];
    
    // 添加返回按钮
    self.topBackView = [[UIView alloc] init];
    self.topBackView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [self addSubview:self.topBackView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.topBackView addSubview:self.titleLabel];
    
    self.rorateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rorateBtn setImage:[UIImage imageNamed:@"btn_miniscreen"] forState:UIControlStateNormal];
    [self.rorateBtn setImage:[UIImage imageNamed:@"btn_fullscreen"] forState:UIControlStateSelected];
    [self.rorateBtn setSelected:YES];
    self.rorateBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.rorateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rorateBtn.showsTouchWhenHighlighted = YES;
    self.rorateBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.rorateBtn addTarget:self action:@selector(rotateBtnDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.topBackView addSubview:self.rorateBtn];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"top_back_normal"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"top_back_active"] forState:UIControlStateSelected];
    
    self.backBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backBtn.showsTouchWhenHighlighted = YES;
    self.backBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBackView addSubview:self.backBtn];
    
    // 添加菊花动画
    self.activity = [[MovieIndicatorView alloc]init];
    [self addSubview:self.activity];
    [self.activity startAnimating];
    
    //添加亮度hud
    self.brigntnessHud = [[BrightnessHUD alloc] init];
    self.brigntnessHud.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.brigntnessHud];
    
    // 添加视频进度hud
    self.videoProgressHud = [[VideoProgressHUD alloc] init];
    self.videoProgressHud.hidden = YES;
    [self addSubview:self.videoProgressHud];
    
    // 在滑块上添加时间显示label，拖动滑块的时候显示进度
    self.thumbTimeLabel = [[UILabel alloc]init];
    self.thumbTimeLabel.layer.masksToBounds = YES; // 显示label的边框，不然没有圆角效果
    self.thumbTimeLabel.layer.cornerRadius = 3; // 显示圆角
    self.thumbTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.thumbTimeLabel.backgroundColor = [UIColor whiteColor];
    [self.progress.thumbView addSubview:_thumbTimeLabel];
    // 一开始让label隐藏
    self.thumbTimeLabel.hidden = YES;
    
    // 创建自己的音量条
    self.volume = [[UISlider alloc]init]; // 先让slider横放
    [self.volume setThumbImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal]; // 给滑块一个空白的图片
    // 把slider旋转90度
    self.volume.transform = CGAffineTransformMakeRotation(-M_PI_2); // M_PI_2是90度，M_PI * 1.5是180度
    [self addSubview:_volume];
    // 一开始先隐藏音量条,让其上下滑动的时候出现，手势在加载完成后添加
    self.volume.hidden = YES;
    
    // 创建亮度条
    self.brightnessSlider = [[UISlider alloc]init]; // 先让slider横放
    [self.brightnessSlider setThumbImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal]; // 给滑块一个空白的图片
    // 把slider旋转90度
    self.brightnessSlider.hidden = YES;
    self.brightnessSlider.transform = CGAffineTransformMakeRotation(-M_PI_2); // M_PI_2是90度，M_PI * 1.5是180度
    self.brightnessSlider.value = [UIScreen mainScreen].brightness;
    [self addSubview:self.brightnessSlider];
    
    // 添加并接收系统的音量条
    // 把系统音量条放在可视范围外，用我们自己的音量条来控制
    MPVolumeView *volum = [[MPVolumeView alloc]initWithFrame:CGRectMake(-1000, -1000, 30, 30)];
    volum.hidden = kNeedHudTip;
    // 遍历volumView上控件，取出音量slider
    for (UIView *view in volum.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            // 接收系统音量条
            self.volumeSlider = (UISlider *)view;
            // 把系统音量的值赋给自定义音量条
            self.volume.value = self.volumeSlider.value;
            break;
        }
    }
    // 添加系统音量控件
    [self addSubview:volum];
    
    // 创建两个UIImageView，用来展示音量的max，min图标
    CGFloat volumWidth = self.volumeSlider.frame.size.height; // 图标的高度
    UIImageView *maxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.volume.frame.size.height, 0, volumWidth, volumWidth)];
    maxImageView.image = [UIImage imageNamed:@"yinliangda"];
    maxImageView.tag = 100;
    [self.volume addSubview:maxImageView];
    UIImageView *minImageView = [[UIImageView alloc]initWithFrame:CGRectMake(- volumWidth, 0, volumWidth, volumWidth)];
    minImageView.image = [UIImage imageNamed:@"yinliangxiao"];
    minImageView.tag = 101;
    [self.volume addSubview:minImageView];
    
}

- (void)configNotification {
    // add event handler, for this example, it is `volumeChange:` method
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 系统音量
    [center addObserver:self selector:@selector(volumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 系统亮度
    [center addObserver:self selector:@selector(brightnessDidChange:) name:UIScreenBrightnessDidChangeNotification object:nil];
    
    // 旋转方向
    [center addObserver:self selector:@selector(deviceOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // 播放结束的通知
    [center addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    // 进入前台
    [center addObserver:self selector:@selector(playWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 进入后台
    [center addObserver:self selector:@selector(playDidEnterEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    self.play.frame = CGRectMake(0, 0, 60, 60);
    self.play.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    CGFloat height = 45; // 进度条高度
    self.bottomSliderView.frame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, height);
    self.beginLabel.frame = CGRectMake(0, 0, 80, height);
    CGFloat progressX = self.beginLabel.frame.size.width;
    self.progress.frame = CGRectMake(progressX, 0, self.frame.size.width - progressX * 2, height);
    self.endLabel.frame = CGRectMake(self.frame.size.width - progressX, 0, 80, height);
    self.topBackView.frame = CGRectMake(0, 0, self.frame.size.width, 45);
    self.titleLabel.frame = CGRectMake(40, 20, self.topBackView.frame.size.width-80, 20);
    self.rorateBtn.frame = CGRectMake(self.topBackView.frame.size.width-40, 15, 30, 30);
    self.backBtn.frame = CGRectMake(0, 10, 40, 40);
    
    self.thumbTimeLabel.frame = CGRectMake(-35, -30, 80, 25);
    self.volume.frame = CGRectMake(0, 0, 30, self.frame.size.height / 2.8);
    self.volume.center = CGPointMake(40, self.frame.size.height / 2);
    
    self.brightnessSlider.frame = self.volume.frame;
    self.brightnessSlider.center = CGPointMake(self.frame.size.width - 40, self.frame.size.height / 2);
    
    UIImageView *maxImageView = (UIImageView *)[self.volume viewWithTag:100];
    UIImageView *minImageView = (UIImageView *)[self.volume viewWithTag:101];
    CGFloat volumWidth = maxImageView.frame.size.height; // 图标的高度
    
    maxImageView.frame = CGRectMake(self.volume.frame.size.height, 0, volumWidth, volumWidth);
    minImageView.frame = CGRectMake(-volumWidth, 0, volumWidth, volumWidth);
    
    self.brigntnessHud.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.videoProgressHud.center = self.center;
    
}

#pragma mark - PublicMethod
// 给视频名称赋值
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)stopPlay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CGFloat current = CMTimeGetSeconds(self.moviePlayer.currentItem.currentTime);
    CGFloat duration = CMTimeGetSeconds(self.moviePlayer.currentItem.duration);

    // 记录
    [MovieManager addPlayRecordWithIdentifier:[self.url absoluteString] progress:current/duration];
    
    [self removeObserverFromPlayerItem:self.moviePlayer.currentItem];
    
    // 关闭定时器
    [self.timer invalidate];
    [self dismissAction];
    [self.moviePlayer pause];
    [self.playerLayer removeFromSuperlayer];
    self.progress.delegate  = nil;
    [self.brigntnessHud removeFromSuperview];
    self.brigntnessHud = nil;
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pausePlay {
    self.play.selected = NO;
    [self playMovie:self.play];
}

- (void)continuePlay {
    self.play.selected = YES;
    [self playMovie:self.play];
}

- (BOOL)isPlaying {
    return self.moviePlayer.rate > 0;
}

#pragma mark - ProgressDelegate
- (void)touchView:(float)value {
    // 跳转到指定位置
    [self.moviePlayer.currentItem cancelPendingSeeks];
    [self.moviePlayer seekToTime:kMakeCMTime(value) completionHandler:^(BOOL finished) {
        if (finished) {
            self.thumbTimeLabel.hidden = YES;
            [self continuePlay];
        }
    }];
     
}

- (void)progressAction:(CGFloat)progress {
    
    // 保证视图不消失
    [self viewNoDismiss];
    // 实时播放时间
    self.thumbTimeLabel.hidden = NO;
    self.thumbTimeLabel.text = [self durationStringWithTime:(int)progress];
    self.beginLabel.text = self.thumbTimeLabel.text;
    [self pausePlay];
}

#pragma mark - 播放状态，timer方法
- (void)playbackStates:(NSTimer *)timer {
    // 当用户互动滑块的时候不去赋值
    // 这里不用 touchInside，因为touchInside有yes和no，松手后滑块有可能不走
    if (!self.progress.highlighted) {
        self.progress.value  = CMTimeGetSeconds(self.moviePlayer.currentTime);
        // 没点滑块的时候时间label隐藏
        self.thumbTimeLabel.highlighted = YES;
        
        // 实时播放时间
        self.beginLabel.text = [self durationStringWithTime:(int)CMTimeGetSeconds(self.moviePlayer.currentTime)];
    }
}

#pragma mark - 平移手势方法
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    // 判断是垂直移动还是水平移动
//    PanDirection panDirection; // 定义一个实例变量，保存枚举值
//    CGFloat sumTime = 0; // 用来保存快进的总时长

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            panDirection = PanDirectionVerticalNone;
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                panDirection = PanDirectionHorizontalMoved;
                // 取消隐藏
                //                self.horizontalLabel.hidden = NO;
                self.videoProgressHud.hidden = NO;
                
                // 给sumTime初值
                sumTime =  CMTimeGetSeconds(self.moviePlayer.currentTime);
            } else if (x < y){ // 垂直移动
                
                CGFloat xl = [pan locationInView:self].x;
                
                if (xl < self.frame.size.width * 0.3) {
                    panDirection = PanDirectionVerticalMovedVolume;
                    // 显示音量控件
                    self.volume.hidden = NO;
                } else if (xl > self.frame.size.width * 0.7) {
                    panDirection = PanDirectionVerticalMovedBrightness;
                    // 显示音量控件
                    self.brightnessSlider.hidden = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMovedVolume:{
                    // 音量
                    [self volumeAdd:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                case PanDirectionVerticalMovedBrightness:{
                    // 亮度
                    [self brightnessAdd:veloctyPoint.y];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    // 隐藏视图
                    //                    self.horizontalLabel.hidden = YES;
                    self.videoProgressHud.hidden = YES;
                    // ⚠️在滑动结束后，视屏要跳转
                    [self.moviePlayer seekToTime:kMakeCMTime(sumTime)];
                    // 把sumTime滞空，不然会越加越多
                    sumTime = 0;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - pan水平移动的方法
- (void)horizontalMoved:(CGFloat)value {
    // 快进快退的方法
    // 每次滑动需要叠加时间
    sumTime += value / 200;
    
    // 需要限定sumTime的范围
    if (sumTime > CMTimeGetSeconds(self.moviePlayer.currentItem.duration)) {
        sumTime = CMTimeGetSeconds(self.moviePlayer.currentItem.duration);
    }else if (sumTime < 0){
        sumTime = 0;
    }
    
    // 当前快进的时间
    NSString *nowTime = [self durationStringWithTime:(int)sumTime];
    self.beginLabel.text = nowTime;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nowTime attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [str appendAttributedString:self.totalTimeStr];
    [self.videoProgressHud showWithVideoProgress:sumTime/CMTimeGetSeconds(self.moviePlayer.currentItem.duration) text:str isForward:value > 0];
    
}

#pragma mark - 系统相关
#pragma mark  音量
//声音增加
- (void)volumeAdd:(CGFloat)value{
    // 更改系统的音量
    self.volumeSlider.value -= value / 10000;
}

#pragma mark  亮度
- (void)brightnessAdd:(CGFloat)value{
    // 更改 系统的亮度 但是没有通知发出 这里手动调用
    [UIScreen mainScreen].brightness -= value/10000;
    [self brightnessDidChange:nil];
}

#pragma mark  设备旋转
- (void)rotateBtnDidTouch {
    
    [self pausePlay];
    
    if (_movieOrientation == UIDeviceOrientationPortrait) {
        [self playToLandscapeRight];
        self.rorateBtn.selected = NO;
    } else {
        [self playToPortrait];
        self.rorateBtn.selected = YES;
    }
}

- (void)playToLandscapeRight {
    //        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //        self.transform = CGAffineTransformMakeRotation(M_PI/2);
    //        self.bounds = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/kScaleRadio);
}

- (void)playToPortrait {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //        self.transform = CGAffineTransformMakeRotation(M_PI*2);
    //        self.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/kScaleRadio);
}

#pragma mark - 通知
#pragma mark  视频加载好了
- (void)playPreparedToPlay {
    
    // 隐藏返回按钮
    self.topBackView.hidden = YES;
    
    // 取消菊花动画
    [self.activity stopAnimating];
    
    // 给视频总时长赋值
    self.beginLabel.text = [self durationStringWithTime:(int)0];
    self.endLabel.text = [self durationStringWithTime:(int)CMTimeGetSeconds(self.moviePlayer.currentItem.duration)];
    
    // videoHud
    self.totalTimeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" / %@", self.endLabel.text] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    // 修改progress的最大值和最小值
    self.progress.maximumValue = CMTimeGetSeconds(self.moviePlayer.currentItem.duration);
    self.progress.minimumValue = 0;
    
    self.timescale = self.moviePlayer.currentItem.duration.timescale;
    NSLog(@"timescale--%d", self.timescale);

    
    // 添加平移手势，用来控制音量和快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    [self addGestureRecognizer:pan];
    
    // 添加一个tap手势,在视频加载好之后添加轻拍
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
        // 加载完后添加timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playbackStates:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        // 记录
    CGFloat progress = [MovieManager getProgressByIdentifier:[self.url absoluteString]];
    if (progress > 0 && progress < 1) {
        [self.activity startAnimating];
        [self.moviePlayer seekToTime:kMakeCMTime(progress * (self.progress.maximumValue-self.progress.minimumValue)) completionHandler:^(BOOL finished) {
            if (finished) {
                [self continuePlay];
                [self.activity stopAnimating];
            }
        } ];
    } else {
        [self continuePlay];
    }
    
    
}

// 播放结束
- (void)playFinished {
    //还原到起点
    _isPlayEnd = YES;
    
    [self.moviePlayer.currentItem cancelPendingSeeks];
    [self.moviePlayer seekToTime:kMakeCMTime(0) completionHandler:^(BOOL finished) {
        if (finished) {
            [self tapAction];
            [self pausePlay];

            if ([self.delegate respondsToSelector:@selector(moviePlayerCompletionAction:)]) {
                [self.delegate moviePlayerCompletionAction:self];
            }
        }
    }];

}

//进入前台 再次进入前台要 转竖屏
- (void)playWillEnterForeground {
    
    [self pausePlay];
    [self.activity startAnimating];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    if (_movieOrientation != UIDeviceOrientationPortrait) {
        [self playToPortrait];
        self.rorateBtn.selected = YES;
    }
    
    [self.activity stopAnimating];
    [self continuePlay];
    
}

// 进入后台
- (void)playDidEnterEnterBackground {
    [self pausePlay];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];

    // 记录
    [MovieManager addPlayRecordWithIdentifier:[self.url absoluteString] progress:CMTimeGetSeconds(self.moviePlayer.currentTime)/CMTimeGetSeconds(self.moviePlayer.currentItem.duration)];
}

- (void)volumeDidChange:(NSNotification *)notification {
    self.volume.hidden = NO;
    NSString *volumeS = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
    self.volume.value = volumeS.floatValue; // 越小幅度越小
    
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView:) object:_volume];
    [self performSelector:@selector(hiddenView:) withObject:_volume afterDelay:2];
}

- (void)brightnessDidChange:(NSNotification *)notification {
    _brightnessSlider.hidden = NO;
    _brightnessSlider.value = [UIScreen mainScreen].brightness;
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView:) object:_brightnessSlider];
    [self performSelector:@selector(hiddenView:) withObject:_brightnessSlider afterDelay:2];
    
    self.brigntnessHud.hidden = NO;
    [self.brigntnessHud setProgress:_brightnessSlider.value];
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView:) object:self.brigntnessHud];
    [self performSelector:@selector(hiddenView:) withObject:self.brigntnessHud afterDelay:2];
    
    
}

- (void)deviceOrientation:(NSNotification *)noti {
    
    if (_movieOrientation != [UIDevice currentDevice].orientation) {
        _movieOrientation = [UIDevice currentDevice].orientation;
        [self setNeedsDisplay];
        [self layoutIfNeeded];
        [self performSelector:@selector(continuePlay) withObject:nil afterDelay:0.5];
        [self tapAction];
    }
    
}

#pragma mark - 根据时长求出字符串
- (NSString *)durationStringWithTime:(int)time {
    // 获取分钟
    NSString *hour = [NSString stringWithFormat:@"%02d",time / 3600];
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",(time % 3600) / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    
    return [NSString stringWithFormat:@"%@:%@:%@", hour, min, sec];
}

#pragma mark - 播放暂停方法
- (void)playMovie:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        // 暂停
        [self.moviePlayer pause];
    }else{
        // 播放
        [self.moviePlayer play];
    }
}

#pragma mark - tap手势方法
- (void)tapAction {
    [self viewNoDismiss];
    self.play.hidden = !self.play.hidden;
    self.bottomSliderView.hidden = !self.bottomSliderView.hidden;
    self.topBackView.hidden = !self.topBackView.hidden;
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.topBackView.hidden withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - 返回按钮执行的方法
- (void)onBack:(UIButton *)sender {
    
    if (_movieOrientation == UIDeviceOrientationPortrait) {
        
        [self stopPlay];
        
        if ([self.delegate respondsToSelector:@selector(moviePlayerOnBackAction)]) {
            [self.delegate moviePlayerOnBackAction];
        }
    } else {
        
        [self rotateBtnDidTouch];
    }
}

#pragma mark - 保证视图不消失的方法,每次调用这个方法，把之前的倒计时抹去，添加一个新的3秒倒计时
- (void)viewNoDismiss {
    // 先取消一个3秒后的方法，保证不管点击多少次，都只有一个方法在3秒后执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAction) object:nil];
    
    // 3秒后执行的方法
    [self performSelector:@selector(dismissAction) withObject:nil afterDelay:3];
}

// 3秒后执行的方法
- (void)dismissAction {
    self.play.hidden = YES;
    self.bottomSliderView.hidden = YES;
    self.topBackView.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)hiddenView:(UIView *)view {
    view.hidden = YES;
}



/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f, timescale:%d",CMTimeGetSeconds(playerItem.duration), playerItem.duration.timescale);
            if (self.timer == nil) {

                [self playPreparedToPlay];
                NSLog(@"播放.------");
            } else {
                [self.activity stopAnimating];
                [self continuePlay];
            }
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        if (_isPlayEnd) {
            return;
        }
        
        if (![self.activity isAnimating] && self.moviePlayer.rate == 0) {
            [self.activity startAnimating];
        } else if (self.moviePlayer.rate > 0) {
            [self.activity stopAnimating];
        }
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
                //
        // 计算视频缓冲长度
        self.progress.cacheProgress = totalBuffer;
    }
}

@end
