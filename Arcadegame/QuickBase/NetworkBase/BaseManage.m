//
//  BaseManage.m
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "BaseManage.h"
#import <JSONModel/JSONModel.h>
#import <CoreTelephony/CTCellularData.h>

@interface BaseManage ()

@property (nonatomic, assign) BOOL isUsedCache;
@property (nonatomic, assign, readwrite) BOOL shouldCleanList;
@property (nonatomic, assign, readwrite) NSInteger totalPage;   // 当前可分页数
//@property (nonatomic, assign, readwrite) NSInteger pageIndex;   // 起始值 1
@property (nonatomic, assign, readwrite) NSInteger total;       // 最大分页数(内容总数)

@end

@implementation BaseManage{
    NSMutableDictionary *_currentPageDic;
}

/**
 *  默认Manage销毁的时候,取消没有请求完的网络
 */
- (void)dealloc{
    [self cancelRequest];
}

#pragma mark -
- (id)init{
    self = [super init];
    if(self){
        //NSURL *baseUrl = [NSURL URLWithString:[HelpTools sharedAppSingleton].baseUrlString];
        //_requestOperation = [[RequestOperation alloc] initWithBaseURL:baseUrl];
        _requestSession = [[RequestSession alloc] init];
        _requestSession.fileArray = self.fileArray;
        
        _currentPageDic = [NSMutableDictionary new];
        self.totalPage = self.pageIndex = kInitialIndexPage;
        
        self.shouldCleanList = YES;
    }
    
    return self;
}

- (instancetype)initWithObserver:(id)observer{
    self = [self init];
    if(self){
        _requestSession.observer = observer;
    }
    
    return self;
}

- (void)getTelephonyAuthorization{
    
    CTCellularData *cellularData = [CTCellularData new];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState restrictedState) {
        
        switch (restrictedState) {
            case kCTCellularDataRestrictedStateUnknown:
                DLOG(@"CTCellularData:ThreadIsMain:%@<Unknown>", [NSThread isMainThread] ? @"YES" : @"NO");
                break;
            case kCTCellularDataRestricted:
                DLOG(@"CTCellularData:ThreadIsMain:%@<Restricted>", [NSThread isMainThread] ? @"YES" : @"NO");
                break;
            case kCTCellularDataNotRestricted:
                DLOG(@"CTCellularData:ThreadIsMain:%@<NotRestricted>", [NSThread isMainThread] ? @"YES" : @"NO");
                break;
            default:
                break;
        }
    };
}

- (void)requestResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    __WeakObject(self);
    self.isUsedCache = NO;
    
    //[self getTelephonyAuthorization];
    
    [self.requestSession requestDataWithUrl:[self getUrl] params:[self getUrlParam] httpType:[self checkHttpType] requestFinish:^(BOOL isSuccess, ConnectionErrorType errorType, id responseObject) {
        
        __WeakStrongObject();
        if([__strongObject isCache] &&
           __strongObject.pageIndex == kInitialIndexPage){
            
            if(isSuccess){
                
                [__strongObject cacheResponseObject:responseObject];
            }
            else {
                BOOL shouldGetCache = YES;
                if([responseObject isKindOfClass:[HttpErrorEntity class]]){
                    
                    if(![((HttpErrorEntity *)responseObject).errCode isEqualToString:@"90001"]) {
                        
                        shouldGetCache = NO;
                        [__strongObject cacheResponseObject:nil];
                    }
                }
                
                if(shouldGetCache) {
                    
                    responseObject = [__strongObject getCacheObject];
                    
                    if(responseObject){
                        
                        isSuccess = YES;
                        __strongObject.isUsedCache = YES;
                    }
                }
            }
        }
        else if([responseObject isKindOfClass:[HttpErrorEntity class]]){
            
            // 容错处理
            [self setLoadMoreDisable];
        }
        
        if(ErrorType_NOLOGIN == errorType &&
           ![self shouldIgnoreLoginCheck]){
            
            [[HelpTools activityViewController] showLoginViewControllerHandle:^(BOOL isLoginSuccsee) {
                
                if(isLoginSuccsee){
                    
                    [NotificationCenterHelper postNotifiction:NotificationCenterRefreshData userInfo:nil];
                }
            }];
        }
        
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

- (HttpType)checkHttpType{
    
    if([self isPost]){
        
        return POST;
    }
    
    return [self getHttpType];
}

#pragma mark - HttpConfig
- (NSString *)getErrorTag{
    
    return @"msg";
}

- (NSString *)getResultTag{
    
    /*
    if([self getDivTag].length){
        
        return [self getDivTag];
    }
     */
    
    //return @"results";
    return @"data";
}

- (NSString *)getTotalPageTag{
    
    return @"totalPage";
}

- (NSString *)getPageIndexTag{
    
    return @"pageIndex";
}

- (NSString *)getTotalTag{
    
    return @"total";
}

- (NSString *)getDivTag{
    
    return @"TEST";
}

- (NSDictionary *)getUrlParam{
    
    return @{};
}

- (NSString *)getUrl{
    
    return @"";
}

- (BOOL)isPost{
    
    return false;
}

- (NSInteger)getHttpType{
    
    return GET;
}

- (BOOL)isCookie{
    
    return false;
}

- (BOOL)isGetCookie{
    
    return false;
}

- (BOOL)isCache{
    
    return false;
}

- (NSString *)getCacheId{
    
    return @"";
}

- (BOOL)shouldIgnoreLoginCheck{
    
    return false;
}

#pragma mark - instert check

- (NSDictionary *)checkResponseObject:(id)responseObject{
    
    if([responseObject isKindOfClass:[HttpErrorEntity class]])  return nil;
    
    NSDictionary *responseDic = responseObject;
    NSString *value = [self getResultTag];
    
    if([self getDivTag].length){
        
        responseDic = responseObject[value];
        value = [self getDivTag];
        
        if(!self.isUsedCache){
            
            //self.pageIndex = [responseDic[[self getPageIndexTag]] integerValue];
            //self.totalPage = [responseDic[[self getTotalPageTag]] integerValue];
            //self.total = [responseDic[[self getTotalTag]] integerValue];
            //self.pageIndex = [responseDic[@"pageNum"] integerValue];
            
            NSInteger totalInteger = 0;
            id total = [responseDic valueForKey:@"total"];
            if(total && total != [NSNull null]){
                
                totalInteger = [total integerValue];
            }
            self.total = totalInteger;
            
            if(self.maxTotalNum > 0 &&
               self.maxTotalNum < self.total){
                
                self.totalPage = ceil(1.0 * self.maxTotalNum / kCountOfSinglePage);
            }
            else {
                self.totalPage = ceil(totalInteger * 1.0 / kCountOfSinglePage);
            }
            
            if(self.pageIndex == kInitialIndexPage){
                
                self.shouldCleanList = YES;
            }
            else {
                self.shouldCleanList = NO;
            }
            
            self.pageIndex += 1;
        }
        else {
            
            [self setLoadMoreDisable];
        }
    }
    else {
        self.shouldCleanList = YES;
    }
    
    return responseDic[value];
}

- (BOOL)shouldLoadMore{
    
    if((self.pageIndex - 1) == self.totalPage){
        
        return NO;
    }
    
    return YES;
}

- (void)setLoadMoreDisable{
    
    self.totalPage = self.pageIndex;
    
    if(self.pageIndex == kInitialIndexPage)
        self.shouldCleanList = YES;
}

#pragma mark - Cache

- (void)cacheResponseObject:(id)responseObject{
    
    if([self isCache]){
        
        NSString *cacheID = [self getLocalCacheID];
        
        [BaseManage saveFile:responseObject fileName:cacheID];
    }
}

- (id)getCacheObject{
    
    if([self isCache]){
        
        NSString *cacheID = [self getLocalCacheID];
        
        return [BaseManage getFile:cacheID];
    }
    
    return nil;
}

- (NSString *)getLocalCacheID{
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *cacheID = [self getCacheId];
    
    if(![NSString isNotEmptyAndValid:cacheID]){
        
        cacheID = [NSStringFromClass([self class]) lowercaseString];
    }
    else {
        cacheID = [[NSString stringWithFormat:@"%@.", [NSStringFromClass([self class]) lowercaseString]] stringByAppendingString:cacheID];
    }
    
    return [NSString stringWithFormat:@"%@.%@", [NSString stringSafeChecking:bundleID], cacheID];
}

#pragma mark - Common Cache

+ (BOOL)saveFile:(id)fileData fileName:(NSString *)fileName{
    
    if(![NSString isNotEmptyAndValid:fileName]){
        
        return NO;
    }
    
    NSMutableData *cacheData = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:cacheData];
    [archiver encodeObject:fileData forKey:fileName];
    [archiver finishEncoding];
    
    NSString *fileFolderPath = [PathTools getDataCacheFolder];
    NSString *filePath = [fileFolderPath stringByAppendingPathComponent:fileName];
    
    BOOL isSuccess = NO;
    if(filePath){
        isSuccess = [cacheData writeToFile:filePath atomically:YES];
    }
    
    return isSuccess;
}

+ (id)getFile:(NSString *)fileName{
    
    if(![NSString isNotEmptyAndValid:fileName]){
        
        return nil;
    }
    
    NSString *fileFolderPath = [PathTools getDataCacheFolder];
    NSString *filePath = [fileFolderPath stringByAppendingPathComponent:fileName];
    
    NSData *archiverData = [[NSData alloc] initWithContentsOfFile:filePath];
    if(!archiverData){
        
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archiverData];
    
    id entityData = [unarchiver decodeObjectForKey:fileName];
    [unarchiver finishDecoding];
    
    return entityData;
}

+ (id)getCacheWithRequestClass:(Class)requestClass cacheID:(NSString *)cacheID{
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    
    if(![NSString isNotEmptyAndValid:cacheID]){
        
        cacheID = [NSStringFromClass(requestClass) lowercaseString];
    }
    else {
        cacheID = [[NSString stringWithFormat:@"%@.", [NSStringFromClass(requestClass) lowercaseString]] stringByAppendingString:cacheID];
    }
    
    NSString *localCacheID = [NSString stringWithFormat:@"%@.%@", [NSString stringSafeChecking:bundleID], cacheID];
    
    return [self getFile:localCacheID];
}

#pragma mark - FileArray

- (NSMutableArray *)fileArray{
    
    if(!_fileArray){
        
        _fileArray = [NSMutableArray new];
    }
    
    return _fileArray;
}

#pragma mark -
- (BOOL)isNetworkReachable{
    return self.requestSession.reachabilityManager.isReachable;
}

- (void)cancelRequest{
    [self.requestSession cancelAllRequest];
}

- (void)getNetworkStatus:(getNetworkStatus)getNetworkStatus
{
    __block kNetworkStatus networkStatus;
    [self.requestSession.reachabilityManager startMonitoring];
    
    [self.requestSession.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = kNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = kNetworkReachWIFI;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = kNetworkReachWWAN;
                break;
            default:
                break;
        }

        if (getNetworkStatus) {
            getNetworkStatus(networkStatus);
        }
    }];
}

#pragma mark -
- (NSDictionary *)getURLParams:(NSString *)urlString{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSRange range1  = [urlString rangeOfString:@"?"];
    NSRange range2  = [urlString rangeOfString:@"#"];
    NSRange range   ;
    if (range1.location != NSNotFound) {
        range = NSMakeRange(range1.location, range1.length);
    }else if (range2.location != NSNotFound){
        range = NSMakeRange(range2.location, range2.length);
    }else{
        range = NSMakeRange(NSNotFound, 1);
    }
    
    if (range.location != NSNotFound) {
        NSString * paramString = [urlString substringFromIndex:range.location+1];
        NSArray * paramCouples = [paramString componentsSeparatedByString:@"&"];
        for (int i = 0; i < [paramCouples count]; i++) {
            NSArray * param = [[paramCouples objectAtIndex:i] componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                if(@available(iOS 9.0, *)){
                    [dic setObject:[[param objectAtIndex:1] stringByRemovingPercentEncoding] forKey:[[param objectAtIndex:0] stringByRemovingPercentEncoding]];
                }
                else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [dic setObject:[[param objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[param objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop
                }
            }
        }
        return dic;
    }
    return nil;
}

- (NSDictionary *)requestParamDicWithParamObject:(id)paramObject
                                   isWithSession:(BOOL)isWithSession{
    
    NSMutableDictionary *mutableParamDictionary = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *pramDic = nil;
    
    if([paramObject isKindOfClass:[NSDictionary class]] ||
       [paramObject isKindOfClass:[NSMutableDictionary class]]){
        
        pramDic = [NSMutableDictionary dictionaryWithDictionary:paramObject];
    }
    else if([paramObject isKindOfClass:[JSONModel class]]){
        
        pramDic = [NSMutableDictionary dictionaryWithDictionary:[paramObject toDictionary]];
        
    }
    else {
        pramDic = [NSMutableDictionary new];
    }
    
    if(pramDic){
        if(isWithSession){
            [mutableParamDictionary setObject:kAccessToken forKey:@"accessToken"];
        }
        
        [pramDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [mutableParamDictionary setValue:[pramDic objectForKey:key] forKey:key];
        }];
    }
    
    return mutableParamDictionary;
}

- (NSDictionary *)requestParamDicWithRqeustCommand:(NSString *)commad
                                    andParamObject:(id)paramObject
                                     isWithSession:(BOOL)isWithSession
                                          isToJson:(BOOL)isToJson
                                        isWithMore:(BOOL)isWithMore
                                          moreFlag:(BOOL)isMore{
    
    NSMutableDictionary *mutableParamDictionary = [NSMutableDictionary dictionary];
    if(commad && ![commad isEqualToString:@""]){
        [mutableParamDictionary setValue:commad forKey:@"url"];
    }
    
    NSMutableDictionary *pramDic = nil;
    
    if([paramObject isKindOfClass:[NSDictionary class]] ||
       [paramObject isKindOfClass:[NSMutableDictionary class]]){
        
        pramDic = [NSMutableDictionary dictionaryWithDictionary:paramObject];
    }
    else if([paramObject isKindOfClass:[JSONModel class]]){
        
        pramDic = [NSMutableDictionary dictionaryWithDictionary:[paramObject toDictionary]];
        
    }
    else {
        pramDic = [NSMutableDictionary new];
    }
    
    if(pramDic){
        if(isWithMore){
            int currentPage;
            if(!isMore){
                currentPage = 1;
                [_currentPageDic setValue:@(currentPage) forKey:commad];
            }
            else {
                currentPage = [[_currentPageDic objectForKey:commad] intValue] + 1;
                [_currentPageDic setValue:@(currentPage) forKey:commad];
            }
            
            NSDictionary *dic = @{@"count":@(kCountOfSinglePage),
                                  @"page":@(currentPage)};
            [pramDic setValue:dic forKey:@"pagination"];
        }
        
        if(isWithSession){
            NSDictionary *dic = [HelpTools sharedAppSingleton].userSessionDic;
            [pramDic setValue:dic forKey:@"session"];
        }
        
        if(isToJson){
            NSString *jsonStr = [self dictionaryToJsonStr:pramDic];
            if(jsonStr){
                [mutableParamDictionary setValue:jsonStr forKey:@"json"];
            }
        }
        else {
            [pramDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [mutableParamDictionary setValue:[pramDic objectForKey:key] forKey:key];
            }];
        }
    }
    
    return mutableParamDictionary;
}

- (NSString *)dictionaryToJsonStr:(NSDictionary *)dic{
    if(!dic || (dic.count < 1)){
        return nil;
    }
    
    NSError *error = nil;
    id toJsonResult = [NSJSONSerialization dataWithJSONObject:dic
                                                      options:kNilOptions error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:toJsonResult encoding:NSUTF8StringEncoding];
    
    if(!error){
        NSLog(@"Dictionary to json string error:%@", error);
    }
    
    return jsonStr;
}

@end
