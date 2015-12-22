//
//  TestViewController.m
//  VideoTest
//
//  Created by chengxianghe on 15/12/19.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import "TestViewController.h"
#import "MoviePlayer.h"

// 默认竖屏播放比例
#define kScaleRadio (16/9.0)
@interface TestViewController ()<MoviePlayerDelegate>

@property (nonatomic, strong) MoviePlayer *mview;     //
@property (nonatomic, strong) NSURL *url;     //
@property (nonatomic, assign) CGFloat brightness; //系统亮度

@end

@implementation TestViewController

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [UIScreen mainScreen].brightness = self.brightness;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)dealloc {

    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mview = [[MoviePlayer alloc] initWithFrame:CGRectZero URL:_url];
    
    [self.view addSubview:self.mview];
    self.mview.title = @"测试视频";

    self.mview.delegate = self;
    
    self.brightness = [UIScreen mainScreen].brightness;
    
}

- (void)onMoviePlayerBackAction {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
