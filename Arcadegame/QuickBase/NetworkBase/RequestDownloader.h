//
//  RequestDownloader.h
//  Interactive
//
//  Created by Abner on 16/4/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "RequestConstants.h"

@interface RequestDownloader : NSObject

+ (RequestDownloader *)requestDownloadDataWithUrl:(NSString *)requestUrl
                                        totleSize:(int64_t)totleSize
                                         savePath:(NSString *)savedPath
                                           params:(NSDictionary *)params
                                         progress:(void (^)(float progress))progress
                                    requestFinish:(void(^)(BOOL isSuccess, ConnectionErrorType errorType, id responseObject))finished;

- (void)cancel;
- (void)suspend;

@end
