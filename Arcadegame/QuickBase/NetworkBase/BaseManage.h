//
//  BaseManage.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "RequestOperation.h"
#import "RequestSession.h"

typedef void (^ResponseBlock)(BOOL isSucceeded, id objectData);

typedef enum kNetworkStatus{
    
    kNetworkNotReachable,       //无网络
    kNetworkReachWWAN,       //3g网络
    kNetworkReachWIFI           //wifi
    
}kNetworkStatus;

typedef void (^getNetworkStatus)(kNetworkStatus networkStatus);

@interface BaseManage : NSObject

//@property (nonatomic, strong) RequestOperation *requestOperation;
@property (nonatomic, strong) RequestSession *requestSession;

/**
 *  需要上传的文件
 */
@property (nonatomic, strong) NSMutableArray *fileArray;

@property (nonatomic, assign, readonly) BOOL shouldCleanList;
@property (nonatomic, assign, readonly) NSInteger totalPage;
@property (nonatomic, assign, readwrite) NSInteger pageIndex;
@property (nonatomic, assign, readonly) NSInteger total;
@property (nonatomic, assign) NSInteger maxTotalNum;

- (instancetype)initWithObserver:(id)observer;

- (void)requestResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

/**
 *  检查 Resut 是否包含附加信息
 *
 *  @param responseObject AF 返回的数据
 *
 *  @return Dic to Model 可用字典
 */
- (NSDictionary *)checkResponseObject:(id)responseObject;

/**
 *  解析URL链接
 *
 *  @return 解析好的字典
 */
- (NSDictionary *)getURLParams:(NSString *)urlString;

/**
 *  获取服务器Json错误标签
 */
- (NSString *)getErrorTag;

/**
 *  获取服务器Json数据标签，如果有自定义则使用自定义标签
 */
- (NSString *)getResultTag;

/**
 *  获取服务器Json自定义标签
 */
- (NSString *)getDivTag;

/**
 *  当前总页数标签 默认"totalPage"
 */
- (NSString *)getTotalPageTag;

/**
 *  当前页码标签 默认"pageIndex"
 */
- (NSString *)getPageIndexTag;

/**
 *  最大页数标签 默认"total"
 */
- (NSString *)getTotalTag;

/**
 *  获取请求参数
 */
- (NSDictionary *)getUrlParam;

/**
 *  获取请求Api
 */
- (NSString *)getUrl;

/**
 *  是否 POST 请求，默认为 GET 请求
 */
- (BOOL)isPost;

/**
*  获取网络请求类型
*  兼容旧版，如果isPost为TURE，该方法不可用；默认为 GET 请求
*/
- (NSInteger)getHttpType;

/**
 *  是否Cookie模式，传cookie
 */
- (BOOL)isCookie;

/**
 *  是否获取Cookie值
 */
- (BOOL)isGetCookie;

/**
 *  是否缓存
 */
- (BOOL)isCache;

/**
 *  获取缓存所需的 ID
 */
- (NSString *)getCacheId;

/**
 *  是否忽略用户登录判断
 */
- (BOOL)shouldIgnoreLoginCheck;

/**
 *  缓存responseObject
 */
- (void)cacheResponseObject:(id)responseObject;

/**
 *	判断是否有网络
 */
- (BOOL)isNetworkReachable;

/**
 *  取消请求
 */
- (void)cancelRequest;

/**
 *  获取网络状态
 */
- (void)getNetworkStatus:(getNetworkStatus)status;

/**
 *  是否可以加载更多
 */
- (BOOL)shouldLoadMore;

/**
 *  拼装参数
 *
 *  @param commad        请求URL的字符串(定义在AppConstants.h中)
 *  @param paramObject   可传入字典、JSONModel
 *  @param isWithSession 是否要加入session
 *  @param isToJson      是否要转成json字符串
 *  @param isWithMore    是否具有加载更多的列表
 *  @param isMore        是否加载更多
 *
 *  @return param
 */
- (NSDictionary *)requestParamDicWithRqeustCommand:(NSString *)commad
                                    andParamObject:(id)paramObject
                                     isWithSession:(BOOL)isWithSession
                                          isToJson:(BOOL)isToJson
                                        isWithMore:(BOOL)isWithMore
                                          moreFlag:(BOOL)isMore;

- (NSDictionary *)requestParamDicWithParamObject:(id)paramObject
                                   isWithSession:(BOOL)isWithSession;

/**
 *  获取缓存ID
 */
- (NSString *)getLocalCacheID;

/**
 *  获取缓存文件
 *
 *  @param fileData   应为json转成的字典
 *  @param fileName   应为cacheID
 *
 */
+ (BOOL)saveFile:(id)fileData fileName:(NSString *)fileName;

/**
 *  拼装参数
 *
 *  @param fileName   应为cacheID
 *
 *  @return 应为json转成的字典
 */
+ (id)getFile:(NSString *)fileName;

/**
 *  拼装参数
 *
 *  @param requestClass   Http请求类名
 *  @param cacheID   cacheID，查询Http请求设置获得，没有传空
 *
 */
+ (id)getCacheWithRequestClass:(Class)requestClass cacheID:(NSString *)cacheID;

@end
