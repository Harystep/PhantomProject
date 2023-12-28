//
//  RequestSession.m
//  DJMicroVideo
//
//  Created by AbnerWork on 2017/12/4.
//  Copyright © 2017年 DJAbner. All rights reserved.
//

#import "RequestSession.h"
#import <objc/runtime.h>

@implementation RequestSession

- (id)init{
    return [self initWithBaseURL:nil];
}

- (id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if(self){
        //采用默认请求数据格式，默认请求格式为二进制
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
        //[self addCommonHeadersToRequest];
        
        //[self.requestSerializer setValue:@"application/json;text/html;charset=utf-8" forKey:@"Content-Type"];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];//image/png
        //[NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil]
        self.downloadOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)paramUrl params:(NSDictionary *)params httpType:(HttpType)httpType requestFinish:(RequestFeedBack)finished{
    
    //每个请求之前都会检测网络状态
    /*
     if(!self.reachabilityManager.isReachable){
     finished(NO, ErrorType_NOCONNECTION, nil);
     return nil;
     }
     */
    
    // 请求之前重置 HTTPHeader
    [self addCommonHeadersToRequest];
    
    if(@available(iOS 9.0, *)){
        paramUrl = [paramUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        paramUrl = [paramUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    }
    
    switch (httpType) {
        case GET:{
            
            return [self requestDataByGetWithUrl:paramUrl params:params requestFinish:finished];
        }
        case POST:{
            
            if(self.fileArray &&
               self.fileArray.count){
                
                return [self requestDataByPostWithUrl:paramUrl params:params fileDataDicArray:self.fileArray requestFinish:finished];
            }
            
            return [self requestDataByPostWithUrl:paramUrl params:params requestFinish:finished];
        }
        case PUT:{
            break;
        }
        case DELETE:{
            break;
        }
        case PATCH:{
            break;
        }
        default:{
            HttpErrorEntity *errorEntity = [HttpErrorEntity new];
            errorEntity.msg = @"请求类型错误";
            errorEntity.code = @"-10086";
            
            finished(NO, ErrorType_HttpType_Error, errorEntity);
            return nil;
        }
    }
    
    return nil;
}

- (NSURLSessionDataTask *)requestDataByGetWithUrl:(NSString *)paramUrl params:(NSDictionary *)params requestFinish:(RequestFeedBack)finished{
    
    paramUrl = [NSObject stringSafeChecking:paramUrl];
    paramUrl = [[HelpTools sharedAppSingleton].baseUrlString stringByAppendingString:paramUrl];
    
    __block __typeof(self)__blockSelf = self;
    NSURLSessionDataTask *dataTask = [self GET:paramUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //---------------------
        //获取本地时间与服务器时间差
        [__blockSelf writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
        //---------------------
        
        if(DEBUG){
            
            if(![NSString isNotEmptyAndValid:receiverString]){
                
                DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], responseObject ? responseObject : @"");
            }
            else {
                if(@available(iOS 9.0, *)){
                                DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], receiverString?receiverString:@"");
                            }
                            else {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], receiverString?receiverString:@"");
                #pragma clang diagnostic pop
                            }
            }
        }
        
        if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]){
            
            /*
             if(![responseObject objectForKey:@"status"]){
             
             finished(YES, ErrorType_NOERROR, responseObject);
             
             return;
             }
             */
            
            [__blockSelf writeServerTime:responseObject];
            //NSInteger succeedFlag = [[responseObject objectForKey:@"code"] integerValue];
            NSInteger errCode = [[responseObject objectForKey:@"code"] integerValue];
            if(errCode == 0) {
                
                errCode = [[responseObject objectForKey:@"errCode"] integerValue];
            }
            
            if(errCode == 0){
                
                if(finished){
                    finished(YES, ErrorType_NOERROR, responseObject);
                }
            }
            else {
                HttpErrorEntity *errorEntity = [HttpErrorEntity mj_objectWithKeyValues:responseObject];
                if(finished){
                    finished(NO, [self getErrorType:errorEntity], errorEntity);
                }
            }
        }
        else {
            if(finished){
                finished(NO, ErrorType_RESPONSEERROR, responseObject);
            }
        }
        
        if([httpResponse statusCode] < 400){
            
        }
        else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //---------------------
        //获取本地时间与服务器时间差
        [__blockSelf writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
        //---------------------
        
        if(@available(iOS 9.0, *)){
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request error:%@ -> %@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], receiverString?receiverString:@"", error);
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request error:%@ -> %@\n", [[httpResponse.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], receiverString?receiverString:@"", error);
#pragma clang diagnostic pop
        }
        
        HttpErrorEntity *errorEntity = nil;
        
//        if(!receiverString || !receiverString.length) {
//
//            errorEntity = [HttpErrorEntity new];
//            errorEntity.errMsg = @"网络连接错误";
//            errorEntity.errCode = @"90001";
//        }
        
        if(task.currentRequest.HTTPBody){
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:task.currentRequest.HTTPBody options:NSJSONReadingMutableContainers error:&error];
            
            if(!error && dic){
                
                errorEntity = [HttpErrorEntity mj_objectWithKeyValues:dic];
            }
            else {
                
                DLOG(@"\nHttpErrorEntity to dic error:%@\n", error?error:@"");
            }
        }
        
        if(finished){
            finished(NO, [self getErrorType:errorEntity], errorEntity);
        }
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)requestDataByPostWithUrl:(NSString *)paramUrl params:(NSDictionary *)params requestFinish:(RequestFeedBack)finished{
    
    paramUrl = [NSString stringSafeChecking:paramUrl];
    paramUrl = [[HelpTools sharedAppSingleton].baseUrlString stringByAppendingString:paramUrl];
    
    __block __typeof(self)__blockSelf = self;
    NSURLSessionDataTask *dataTask = [self POST:paramUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //---------------------
        //获取本地时间与服务器时间差
        [__blockSelf writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
        //---------------------
        
        if(DEBUG) {
            if(![NSString isNotEmptyAndValid:receiverString]){
                
                DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], responseObject ? responseObject : @"");
            }
            else {
                
                if(@available(iOS 9.0, *)){
                    DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], receiverString);
                }
                else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], receiverString);
#pragma clang diagnostic pop
                }
            }
        }
        
        if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]){
            /*
             if([[responseObject objectForKey:@"code"] integerValue] == 200){
             if(finished){
             finished(YES, ErrorType_NOERROR, responseObject);
             }
             }
             */
            
            [__blockSelf writeServerTime:responseObject];
            //NSInteger succeedFlag = [[responseObject objectForKey:@"code"] integerValue];
            NSInteger errCode = [[responseObject objectForKey:@"code"] integerValue];
            if(errCode == 0) {
                
                errCode = [[responseObject objectForKey:@"errCode"] integerValue];
            }
            if(errCode == 0){
                
                if(finished){
                    finished(YES, ErrorType_NOERROR, responseObject);
                }
            }
            else {
                HttpErrorEntity *errorEntity = [HttpErrorEntity mj_objectWithKeyValues:responseObject];
                if(finished){
                    finished(NO, [self getErrorType:errorEntity], errorEntity);
                }
            }
        }
        else {
            if(finished){
                finished(NO, ErrorType_RESPONSEERROR, responseObject);
            }
        }
        
        if([httpResponse statusCode] < 400){
            
        }
        else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //---------------------
        //获取本地时间与服务器时间差
        [__blockSelf writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
        //---------------------
        
        if(@available(iOS 9.0, *)){
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request error:%@ -> %@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], receiverString, error);
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request error:%@ -> %@\n", [[httpResponse.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], receiverString, error);
#pragma clang diagnostic pop
        }
        
        HttpErrorEntity *errorEntity = nil;
        
//        if(!receiverString || !receiverString.length) {
//
//            errorEntity = [HttpErrorEntity new];
//            errorEntity.errMsg = @"网络连接错误";
//            errorEntity.errCode = @"90001";
//        }
        
        if(task.currentRequest.HTTPBody){
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:task.currentRequest.HTTPBody options:NSJSONReadingMutableContainers error:&error];
            
            if(!error && dic){
                
                errorEntity = [HttpErrorEntity mj_objectWithKeyValues:dic];
            }
            else {
                
                DLOG(@"\nHttpErrorEntity to dic error:%@\n", error?error:@"");
            }
        }
        
        if(finished){
            finished(NO, [self getErrorType:errorEntity], errorEntity);
        }
        
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)requestDataByPostWithUrl:(NSString *)paramUrl params:(NSDictionary *)params fileDataDicArray:(NSArray *)fileDataDicArray requestFinish:(RequestFeedBack)finished{
    
    paramUrl = [NSString stringSafeChecking:paramUrl];
    paramUrl = [[HelpTools sharedAppSingleton].baseUrlString stringByAppendingString:paramUrl];
    
    __block __typeof(self)__blockSelf = self;
    NSURLSessionDataTask *dataTask = [self POST:paramUrl parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if(fileDataDicArray){
            
            [fileDataDicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDictionary *fileDataDic = obj;
                
                NSArray *keys = [fileDataDic allKeys];
                for(NSString *key in keys){
                    
                    NSString *filePath = [fileDataDic valueForKey:key];
                    
                    if(filePath && filePath.length){
                        
                        NSString *fileExtension = [filePath pathExtension];
                        NSString *mimeType = [self checkUploadMimeType:fileExtension];
                        
                        NSString *fileName = [filePath lastPathComponent];
                        
                        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                        
                        if(fileData){
                            ///*后台强取name来验证，临时解决方案*/
                            //NSString *name = @"files";
                            //if([paramUrl rangeOfString:@"/buyers/app/uploadTxPic"].location != NSNotFound){
                            //    name = @"file";
                            //}
                            //[formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
                            [formData appendPartWithFileData:fileData name:key fileName:fileName mimeType:mimeType];
                        }
                    }
                }
            }];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //---------------------
        //获取本地时间与服务器时间差
        [__blockSelf writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
        //---------------------
        
        if(@available(iOS 9.0, *)){
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], receiverString);
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request finish:%@\n", [[httpResponse.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], receiverString);
#pragma clang diagnostic pop
        }
        
        if([httpResponse statusCode] < 400){
            if(finished){
                finished(YES, ErrorType_NOERROR, responseObject);
            }
        }
        else {
            HttpErrorEntity *errorEntity = [HttpErrorEntity mj_objectWithKeyValues:responseObject];
            if(finished){
                finished(NO, [self getErrorType:errorEntity], responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //---------------------
        //获取本地时间与服务器时间差
        [__blockSelf writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
        //---------------------
        
        if(@available(iOS 9.0, *)){
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request error:%@ -> %@\n", [[httpResponse.URL absoluteString] stringByRemovingPercentEncoding], receiverString, error);
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]request error:%@ -> %@\n", [[httpResponse.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], receiverString, error);
#pragma clang diagnostic pop
        }
        
        HttpErrorEntity *errorEntity = nil;
        
//        if(!receiverString || !receiverString.length) {
//
//            errorEntity = [HttpErrorEntity new];
//            errorEntity.errMsg = @"网络连接错误";
//            errorEntity.errCode = @"90001";
//        }
        
        if(task.currentRequest.HTTPBody){
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:task.currentRequest.HTTPBody options:NSJSONReadingMutableContainers error:&error];
            
            if(!error && dic){
                
                errorEntity = [HttpErrorEntity mj_objectWithKeyValues:dic];
            }
            else {
                
                DLOG(@"\nHttpErrorEntity to dic error:%@\n", error?error:@"");
            }
        }
        
        if(finished){
            finished(NO, [self getErrorType:errorEntity], errorEntity);
        }
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)requestDownloadDataWithUrl:(NSString *)requestUrl rangeData:(NSNumber *)rangeData params:(NSDictionary *)params savePath:(NSString *)savedPath progress:(void (^)(float progress))progress requestFinish:(RequestFeedBack)finished{
    
    requestUrl = [NSString stringSafeChecking:requestUrl];
    if(@available(iOS 9.0, *)){
        requestUrl = [requestUrl stringByRemovingPercentEncoding];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    }
    
    //AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    //NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:requestUrl parameters:params error:nil];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    if(rangeData &&
       rangeData.longLongValue > 0){
        
        NSString *rangeString=[NSString stringWithFormat:@"bytes=%lld-", rangeData.longLongValue];
        [request setValue:rangeString forHTTPHeaderField:@"Range"];
    }
    /*
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    
    DLOG(@"%@", operation.request.allHTTPHeaderFields);
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]download request finish:%@\n", [[operation.request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], operation.responseString);
        
        if(finished){
            finished(YES, ErrorType_NOERROR, @"Download success!");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DLOG(@"\n[[[[]]]]request URL:%@\n\n[[[[]]]]download request error:%@ -> %@\n", [[operation.request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], operation.responseString, error);
        
        if(finished){
            finished(NO, ErrorType_SEVERERROR, error);
        }
    }];
    
    //[self.downloadOperationQueue addOperation:operation];
    [operation start];
     
    return operation;
     */
    
    return nil;
}

- (void)cancelAllDownloadRequest{
    [self.downloadOperationQueue cancelAllOperations];
}

- (void)cancelAllRequest{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - Request Result

- (void)requestSuccessWithTask:(NSURLSessionDataTask *)task andResponse:(id)responseObject{
    
    NSString *receiverString = [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    //---------------------
    //获取本地时间与服务器时间差
    [self writeLocalAndServerTimeOffset:[httpResponse allHeaderFields]];
    //---------------------
    
    
}

#pragma mark -
- (void)writeLocalAndServerTimeOffset:(NSDictionary *)headerField{
    if(headerField && ([headerField count] > 0)){
        NSString *dateString = [headerField objectForKey:@"Date"];
        
        if([NSString isNotEmptyAndValid:dateString]){
            
            NSDate   *serverDate = [HelpTools getDateFromGMTString:dateString];
            [HelpTools sharedAppSingleton].localAndServerTimeOffset = [HelpTools getOffsetForLocalAndServerDate:serverDate];
        }
    }
}

- (void)writeServerTime:(NSDictionary *)response{
    if (response[@"status"]) {
        NSDictionary * status =response[@"status"];
        [HelpTools sharedAppSingleton].serverLastTime = [status[@"cct"] doubleValue];
    }
}

- (void)addPrivateHeadersToRequest:(NSDictionary *)headsDic{
    
    for(NSString *key in headsDic.allKeys){
        [self.requestSerializer setValue:headsDic[key] forHTTPHeaderField:key];
    }
}

- (void)addCommonHeadersToRequest{//:(AFHTTPRequestOperationManager *)manager{
    /*
    //应用标示
    //[self.requestSerializer setValue:@"WNI" forHTTPHeaderField:@"wn-app"];
    
    //版本号
    [self.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"wn-app-v"];
    
    //产品渠道
    [self.requestSerializer setValue:@"AppStore" forHTTPHeaderField:@"wn-app-c"];
    
    //设置是开发版还是产品版
    if (DEBUG) {
        //测试模式
        [self.requestSerializer setValue:@"Dev" forHTTPHeaderField:@"wn-app-m"];
    }else{
        //产品模式
        [self.requestSerializer setValue:@"Prod" forHTTPHeaderField:@"wn-app-m"];
    }
    */
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *deviceType = @"ios";
    NSString *params = [NSString stringWithFormat:@"%@;%f;%@", APP_BUNDLE_NAME, [[NSDate date] timeIntervalSince1970], deviceType];
    NSString *md5Params = [HelpTools md5:params];
    
    //[self.requestSerializer setValue:md5Params forHTTPHeaderField:@"params"];
    [self.requestSerializer setValue:deviceType forHTTPHeaderField:@"device_type"];
    //[self.requestSerializer setValue:[HelpTools md5:[md5Params stringByAppendingString:[HelpTools sharedAppSingleton].currentAPISalt]] forHTTPHeaderField:@"sign"];
    [self.requestSerializer setValue:[NSString stringSafeChecking:APP_VERSION] forHTTPHeaderField:@"VersionName"];
    [self.requestSerializer setValue:CHANNEL_KEY forHTTPHeaderField:@"channelKey"];
    
    if([HelpTools isLoginWithoutVC]){
        
        [self.requestSerializer setValue:[NSString stringSafeChecking:[HelpTools userDataForToken]] forHTTPHeaderField:@"accessToken"];
    }
    else {
        
        //[self.requestSerializer setValue:@"" forHTTPHeaderField:@"accessToken"];
    }
    
    DLOG(@"\n\nCommonHeadersToRequest:%@\n\n", self.requestSerializer.HTTPRequestHeaders);
}

/**
 *  包含通用错误处理
 */
- (ConnectionErrorType)getErrorType:(HttpErrorEntity *)errorEntity{
    ConnectionErrorType errorType = ErrorType_RESPONSEERROR;
    BOOL showCommentAlert = YES;
    
    if(errorEntity){
        /*
        if(!errorEntity.state){
            return errorType;
        }
        
        if(errorEntity.status.error_code == 100){
            //您的帐号已过期
            [HelpTools setUserDataNull:nil];
            
            __BlockObject(self);
            [[HelpTools rootViewController] showLoginViewControllerHandle:^(BOOL isBackToSuper) {
                if(isBackToSuper){
                    if(__blockObject.observer){
                        UIViewController *controller = (UIViewController *)__blockObject.observer;
                        if([controller.navigationController.viewControllers count] > 1){
                            [controller.navigationController popViewControllerAnimated:NO];
                        }
                        else {
                            [controller.navigationController dismissViewControllerAnimated:NO completion:nil];
                        }
                    }
                }
                else {
                    if(__blockObject.observer){
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_DATA(NSStringFromClass([__blockObject.observer class])) object:nil];
                    }
                }
            }];
            
            errorType = ErrorType_NOLOGIN;
            showCommentAlert = NO;
        }
         */
        // ESShop 错误模型
        if(!errorEntity.code ||
           [errorEntity.code isEqualToString:@""]){
            return errorType;
        }
        
        if([errorEntity.code integerValue] == 401){
            //账号认证失败，重新登录
            //[HelpTools saveUserDataCleanToken];
            [HelpTools cleanUserDataCache];
            [NotificationCenterHelper postNotifiction:NotificationCenterRYProgress userInfo:@{@"isLogin":@(NO)}];
            [NotificationCenterHelper postNotifiction:NotificationCenterLoginout userInfo:nil];
            
            errorType = ErrorType_NOLOGIN;
            showCommentAlert = NO;
        }
        
        if(!self.closeCommonErrorProcess && showCommentAlert){
            NSString *info = @"网络连接错误";
            if([NSString isNotEmptyAndValid:errorEntity.msg]){
                
                info = errorEntity.msg;
            }
            
            if(info && ![info isEqualToString:@""]){
                //弹框代码
            }
        }
    }
    
    return errorType;
}

- (NSString *)checkUploadMimeType:(NSString *)fileExtension{
    
    if([fileExtension isEqualToString:@"png"])  return @"image/png";
    if([fileExtension isEqualToString:@"jpge"]) return @"image/jpeg";
    if([fileExtension isEqualToString:@"jpg"])  return @"image/jpeg";
    if([fileExtension isEqualToString:@"txt"])  return @"text/plain";
    if([fileExtension isEqualToString:@"rtf"])  return @"application/rtf";
    if([fileExtension isEqualToString:@"au"])   return @"audio/basic";
    if([fileExtension isEqualToString:@"mp3"])  return @"audio/x-mpeg";
    if([fileExtension isEqualToString:@"mp4"])  return @"video/mp4";
    
    return @"";
}

@end
