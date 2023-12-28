//
//  RequestDownloader.m
//  Interactive
//
//  Created by Abner on 16/4/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "RequestDownloader.h"

@interface RequestDownloader ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSString *savedPath;
@property (nonatomic, strong) NSString *tmpSavedPath;
@property (nonatomic, strong) NSString *requestUrlSring;

@property(nonatomic, assign) int64_t totalBytesWritten;
@property(nonatomic, assign) int64_t totalBytesExpectedToWrite;

@property (nonatomic, copy) void(^progressBlock)(float progress);
@property (nonatomic, copy) void(^completionBlock)(BOOL isSuccess, ConnectionErrorType errorType, id responseObject);

@end

@implementation RequestDownloader

- (void)dealloc{
    
    if(self.downloadTask){
        self.downloadTask = nil;
    }
}

- (instancetype)init{
    
    if(self = [super init]){
        
    }
    
    return self;
}

// 暂停
- (void)suspend{
    if(self.downloadTask){
        
        [self.downloadTask suspend];
    }
}

// 取消
- (void)cancel{
    if(self.downloadTask){
        
        [self.downloadTask cancel];
    }
}

+ (RequestDownloader *)requestDownloadDataWithUrl:(NSString *)requestUrl
                                        totleSize:(int64_t)totleSize
                                         savePath:(NSString *)savedPath
                                           params:(NSDictionary *)params
                                         progress:(void (^)(float progress))progress
                                    requestFinish:(void(^)(BOOL isSuccess, ConnectionErrorType errorType, id responseObject))finished{
    
    RequestDownloader *downloader = [RequestDownloader new];
    
    downloader.savedPath = savedPath;
    downloader.requestUrlSring = requestUrl;
    downloader.totalBytesExpectedToWrite = totleSize;
    
    [downloader setCompletionBlcok:finished];
    [downloader setProgressBlock:progress];
    
    [downloader getFileSizeWithURLString:requestUrl];
    [downloader resume:requestUrl];
    
    return downloader;
}

- (NSURLSession *)session{
    
    if(!_session){
    
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    }
    
    return _session;
}

// 开始任务
- (void)resume:(NSString *)urlString{
    
    if(self.totalBytesWritten == self.totalBytesExpectedToWrite &&
       self.totalBytesWritten != 0){
        
        self.completionBlock(YES, ErrorType_NOERROR, nil);
        
        return;
    }
    
    NSMutableURLRequest *downloadRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    if(self.totalBytesWritten > 0){
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.totalBytesWritten];
        [downloadRequest setValue:range forHTTPHeaderField:@"Range"];
    }
    
    self.downloadTask = [self.session dataTaskWithRequest:downloadRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    
    [self.downloadTask resume];
}

- (void)getFileSizeWithURLString:(NSString*)urlString{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:self.savedPath]){
        
        self.totalBytesWritten = self.totalBytesExpectedToWrite;
    }
    else {
        NSString *filePath = [[self.savedPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"tmp"];
        self.tmpSavedPath = filePath;
        
        if([fileManager fileExistsAtPath:filePath]){
            
            NSError *error;
            long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:&error] fileSize];
            
            if(error){
                NSLog(@"%@ get file size failed!", filePath);
            }
            
            self.totalBytesWritten = fileSize;
        }
    }
}

- (void)setCompletionBlcok:(void(^)(BOOL isSuccess, ConnectionErrorType errorType, id responseObject))finished{
    
    self.completionBlock = ^(BOOL isSuccess, ConnectionErrorType errorType, id responseObject){
    
        dispatch_sync(dispatch_get_main_queue(), ^{
           
            finished(isSuccess, errorType, responseObject);
        });
    };
}

- (void)setProgressBlockWithProgress:(void (^)(float))progressBlock{
    
    self.progressBlock = ^(float p){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            progressBlock(p);
        });
    };
}

#pragma mark - NSURLSessionDataDelegate
// 收到响应调用的代理方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    // 创建输出流，并打开流
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToFileAtPath:self.tmpSavedPath append:YES];
    [outputStream open];
    
    self.outputStream = outputStream;
    completionHandler(NSURLSessionResponseAllow);
}

// 收到数据调用的代理方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    [self.outputStream write:(uint8_t *)data.bytes maxLength:data.length];
    
    self.totalBytesWritten += data.length;
    
    float p = self.totalBytesWritten * 1.0 / self.totalBytesExpectedToWrite;
    
    self.progressBlock(p);
}

// 数据下载完成调用的方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    [self.outputStream close];
    self.outputStream = nil;
    
    [self.session invalidateAndCancel];
    
    if(error){
        self.completionBlock(NO, ErrorType_SEVERERROR, error.debugDescription);
    }
    else {
        NSError *fileError;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager moveItemAtPath:self.tmpSavedPath toPath:self.savedPath error:&fileError]){
            
            NSLog(@"%@ change file name failed! error:%@", self.tmpSavedPath, fileError.debugDescription);
        }
        
        self.completionBlock(YES, ErrorType_NOERROR, nil);
    }
}

@end
