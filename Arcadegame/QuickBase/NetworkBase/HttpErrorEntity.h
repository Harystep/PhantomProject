//
//  HttpErrorEntity.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataEntity;
@class ErrorEntity;
@class HFErrorEntity;

@interface HttpErrorEntity : NSObject

@property(nonatomic, retain) NSString *statusType;
@property(nonatomic, retain) NSString *info;
@property(nonatomic, retain) NSString *infoTitle;
@property(nonatomic, strong) NSArray *errors;
@property(nonatomic, strong) DataEntity *data;

@property(nonatomic, strong) HFErrorEntity *status;

@property(nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) NSString *errCode;

@end

/**
 *  ErrorEntity
 */
@interface ErrorEntity : NSObject

@property(nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *msg;

@end

/**
 *  HFErrorEntity
 */
@interface HFErrorEntity : NSObject

@property(nonatomic, assign) int succeed;
@property(nonatomic, assign) int error_code;
@property(nonatomic, strong) NSString *cct;
@property(nonatomic, strong) NSString *error_desc;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;

@end

/**
 *  DataEntity
 */
@interface DataEntity : NSObject

@property(nonatomic, strong) NSString *version;
@property(nonatomic, strong) NSString *versionUrl;
@property(nonatomic, strong) NSString *infoTitle;
@property(nonatomic, strong) NSString *info;
@property(nonatomic, assign) BOOL hasNew;

@end

/**
*  ESErrorEntity
*/
@interface ESErrorEntity : NSObject

@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errDesc;

@end
