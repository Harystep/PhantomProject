//
//  BaseEntity.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

@class PageInfoEntity;

@interface BaseEntity : NSObject

@property(nonatomic, strong) PageInfoEntity *paginated; //分页信息
@property(nonatomic, strong) NSDate *serverDate;        //服务器系统时间

@end

/**
 *  PageInfoEntity
 */
@interface PageInfoEntity : NSObject

@property(nonatomic, strong) NSNumber *numCount;   //当前页
@property(nonatomic, strong) NSNumber *total;   //总页数
@property(nonatomic, strong) NSNumber *more;    //是否还有更多

@end

@interface BaseOptionModel : NSObject
@end
