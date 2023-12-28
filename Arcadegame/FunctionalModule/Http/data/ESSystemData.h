//
//  ESSystemData.h
//  EShopClient
//
//  Created by Abner on 2019/7/16.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESSystemData : NSObject

@end

/**
 ESSystemResonListData
 */
@interface ESSystemResonListData : NSObject

@property (nonatomic, strong) NSArray *list;

@end

/**
 ESSystemResonData
 */
@interface ESSystemResonData : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *auseContent;
@property (nonatomic, strong) NSString *reasonContent;
@property (nonatomic, strong) NSString *reasonSort;
@property (nonatomic, strong) NSString *back;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;

@end

/**
 ESSystemUPAppVersionData
 */
@interface ESSystemUPAppVersionData : NSObject

@property (nonatomic, strong) NSString *isCompel;
@property (nonatomic, strong) NSString *appType;
@property (nonatomic, strong) NSString *versionNum;
@property (nonatomic, strong) NSString *clientType;
@property (nonatomic, strong) NSString *versionStatus;
@property (nonatomic, strong) NSString *back;
@property (nonatomic, strong) NSString *upgradeUrl;
@property (nonatomic, strong) NSString *versionCont;

@end

/**
ESSystemAllLogisticsData
*/
@interface ESSystemAllLogisticsData : NSObject

@property (nonatomic, assign) id shopsLogis;
@property (nonatomic, strong) NSArray *logistics;

@end

@interface ESSystemLogisticsData : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *logisName;
@property (nonatomic, strong) NSString *logisCode;
@property (nonatomic, strong) NSString *logisStatus;

@end

NS_ASSUME_NONNULL_END
