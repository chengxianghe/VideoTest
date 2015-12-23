//
//  MovieManager.m
//  VideoTest
//
//  Created by chengxianghe on 15/12/19.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import "MovieManager.h"

/*
 * DatabaseManager
 * 通过把播放过的影片的进度信息保存在plist 文件中，实现记住播放历史的功能
 * plist 文件采用队列形式，队列长度为50
 */

NSString *const MoviePlayerArchiveKey_identifier = @"identifier";
NSString *const MoviePlayerArchiveKey_date = @"date";
NSString *const MoviePlayerArchiveKey_progress = @"progress";

NSInteger const MoviePlayerArchiveKey_MaxCount = 50;

@implementation MovieManager

+ (NSString *)pathOfArchiveFile{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath lastObject];
    NSString *plistFilePath = [documentPath stringByAppendingPathComponent:@"playRecord.plist"];
    return plistFilePath;
}
+ (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress{
    
    NSMutableArray *recardList = [[NSMutableArray alloc]initWithContentsOfFile:[MovieManager pathOfArchiveFile]];
    if (!recardList) {
        recardList = [[NSMutableArray alloc]init];
    }
    if (recardList.count==MoviePlayerArchiveKey_MaxCount) {
        [recardList removeObjectAtIndex:0];
    }
    
    NSDictionary *dic = @{MoviePlayerArchiveKey_identifier:identifier,MoviePlayerArchiveKey_date:[NSDate date],MoviePlayerArchiveKey_progress:@(progress)};
    [recardList addObject:dic];
    [recardList writeToFile:[MovieManager pathOfArchiveFile] atomically:YES];
}

+ (CGFloat)getProgressByIdentifier:(NSString *)identifier{
    NSMutableArray *recardList = [[NSMutableArray alloc]initWithContentsOfFile:[MovieManager pathOfArchiveFile]];
    __block CGFloat progress = 0;
    [recardList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        if ([dic[MoviePlayerArchiveKey_identifier] isEqualToString:identifier]) {
            progress = [dic[MoviePlayerArchiveKey_progress] floatValue];
            *stop = YES;
        }
    }];
    if (progress > 0.99 || progress < 0.01) {
        return 0;
    }
    return progress;
}

@end
