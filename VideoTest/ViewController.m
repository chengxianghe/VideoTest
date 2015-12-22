//
//  ViewController.m
//  VideoTest
//
//  Created by chengxianghe on 15/12/18.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)netWork:(id)sender {
    
    [self.navigationController pushViewController:[[TestViewController alloc] initWithURL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14468618701471.mp4"]] animated:YES];
    
}


- (IBAction)locale:(id)sender {
    // 本地的
    NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.navigationController pushViewController:[[TestViewController alloc] initWithURL:url] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
