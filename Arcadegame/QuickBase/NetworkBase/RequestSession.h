//
//  RequestSession.h
//  DJMicroVideo
//
//  Created by AbnerWork on 2017/12/4.
//  Copyright © 2017年 DJAbner. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MJExtension/MJExtension.h>
#import "RequestConstants.h"
#import "HttpErrorEntity.h"
#import "AFNetworking.h"

typedef void(^RequestFeedBack)(BOOL isSuccess, ConnectionErrorType errorType, id responseObject);

@interface RequestSession : AFHTTPSessionManager

/** 下载请求队列 */
@property (nonatomic, strong) NSOperationQueue *downloadOperationQueue;

@property (nonatomic, strong) NSArray *fileArray;

/**
 *  调用类
 */
@property (nonatomic, assign) id observer;

/**
 *  默认为NO;类自己处理服务器返回错误时,设置为YES
 */
@property (nonatomic, assign) BOOL closeCommonErrorProcess;


/**
 *  通用get与post网络请求
 *
 *  @param paramUrl 相对链接
 *  @param params   参数
 *  @param httpType 请求类型
 *  @param finished 结果反馈
 *
 */
- (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)paramUrl params:(NSDictionary *)params httpType:(HttpType)httpType requestFinish:(RequestFeedBack)finished;

/**
 *  上传文件、图片的post请求
 *
 *  @param paramUrl         相对链接
 *  @param params           参数
 *  @param fileDataDicArray 需要上传文件的列表 (字典：{"服务器解析的文件名":"文件存在在本地的路径"})
 *  @param finished         结果反馈
 *
 */
- (NSURLSessionDataTask *)requestDataByPostWithUrl:(NSString *)paramUrl params:(NSDictionary *)params fileDataDicArray:(NSArray *)fileDataDicArray requestFinish:(RequestFeedBack)finished;

/**
 *  下载文件
 *
 *  @param requestUrl 需下载文件的地址
 *  @param params     附加post参数
 *  @param savedPath  保存磁盘的位置
 *  @param progress   实时下载进度
 *  @param finished   结果反馈
 *
 */
- (NSURLSessionDataTask *)requestDownloadDataWithUrl:(NSString *)requestUrl
                                             rangeData:(NSNumber *)rangeData
                                                params:(NSDictionary *)params
                                              savePath:(NSString *)savedPath
                                              progress:(void (^)(float progress))progress
                                         requestFinish:(RequestFeedBack)finished;

/**
 *  取消网络请求
 */
- (void)cancelAllRequest;

/**
 *  取消所有的下载请求
 */
- (void)cancelAllDownloadRequest;

- (void)addPrivateHeadersToRequest:(NSDictionary *)headsDic;

//-----------------------------
//有需要的比如上传文件等方法再添加

/**
 *  if not necessary,you should use 'requestDataWithUrl:params:httpType:requestFinish:'
 */
- (NSURLSessionDataTask *)requestDataByGetWithUrl:(NSString *)paramUrl params:(NSDictionary *)params requestFinish:(RequestFeedBack)finished;

/**
 *  if not necessary,you should use 'requestDataWithUrl:params:httpType:requestFinish:'
 */
- (NSURLSessionDataTask *)requestDataByPostWithUrl:(NSString *)paramUrl params:(NSDictionary *)params requestFinish:(RequestFeedBack)finished;

@end
