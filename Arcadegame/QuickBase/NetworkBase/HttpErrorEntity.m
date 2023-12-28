//
//  HttpErrorEntity.m
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "HttpErrorEntity.h"

@implementation HttpErrorEntity

+ (NSDictionary *)mj_objectClassInArray{
    
    //return @{@"errors":@"HFErrorEntity"};
    return @{@"errors":@"ESErrorEntity"};
}

- (NSString *)msg{
    
    if(_msg && _msg.length){
        
        return _msg;
    }
    
    return @"网络加载错误";
}

- (NSString *)errMsg{
    
    if(_errMsg && _errMsg.length){
        
        return _errMsg;
    }
    
    return @"网络加载错误";
}

@end

/**
 *  ErrorEntity
 */
@implementation ErrorEntity

+ (BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}

@end

/**
 *  HFErrorEntity
 */
@implementation HFErrorEntity

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

/**
 *  DataEntity
 */
@implementation DataEntity

+ (BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}

@end

/**
*  ESErrorEntity
*/
@implementation ESErrorEntity

@end
