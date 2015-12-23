//
//  MovieManager.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/19.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//记住播放进度相关的数据库操作类
@interface MovieManager : NSObject

+ (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress;
+ (CGFloat)getProgressByIdentifier:(NSString *)identifier;

@end
