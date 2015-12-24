//
//  MovieManager.h
//  VideoTest
//
//  Created by chengxianghe on 15/12/19.
//  Copyright © 2015年 CXH. All rights reserved.
//

/**
 *  记录和读取播放进度
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MovieManager : NSObject

+ (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress;

+ (CGFloat)getProgressByIdentifier:(NSString *)identifier;

@end
