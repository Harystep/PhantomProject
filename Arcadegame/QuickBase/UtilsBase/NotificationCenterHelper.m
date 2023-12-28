//
//  NotificationCenterHelper.m
//  Interactive
//
//  Created by Abner on 16/5/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "NotificationCenterHelper.h"

NSString *NSStringFromNotifCenterName(NotifCenterType typeName){
    ENUM_BEGIN
    ENUM_CASE(NotificationCenterVRPlaying)
    ENUM_CASE(NotificationCenterRelogin)
    ENUM_CASE(NotificationCenterRefreshData)
    ENUM_CASE(NotificationCenterTimer)
    ENUM_CASE(NotificationCenterRloadCart)
//    ENUM_CASE(NotificationCenterPayResult)
//    ENUM_CASE(NotificationCenterPayViewClose)
//    ENUM_CASE(NotificationCenterPayViewCloseFromCart)
//    ENUM_CASE(NotificationCenterRYProgress)
    ENUM_CASE(NotificationCenterLoginout)
//    ENUM_CASE(NotificationCenterPayPassword)
//    ENUM_CASE(NotificationCenterWechatLoginResult)
    ENUM_CASE(NotificationCenterMessageUnread)
    ENUM_CASE(NotificationCenterUserInfoReload)
    ENUM_CASE(NotificationCenterLogined)
    ENUM_END
}

typedef void (^NotificationBlock )(NSNotification *notification);

@interface NotificationCenterHelper ()

@property (nonatomic, strong) NSMutableDictionary *mNotificationCenterTaskDic;

@end

@implementation NotificationCenterHelper

+ (NotificationCenterHelper *)sharedNotificationCenterHelper{
    
    static NotificationCenterHelper *sharedNotificationCenterHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNotificationCenterHelper = [NotificationCenterHelper new];
    });
    
    return sharedNotificationCenterHelper;
}

#pragma mark - Interface

+ (void)addNotifiction:(NotifCenterType)typeName observer:(id)observer object:(id)object handle:(void(^)(NSNotification *notification))handle{
 
    [self addNotifictionName:NSStringFromNotifCenterName(typeName) observer:observer handle:handle object:object isAutoRemove:NO];
}

+ (void)addNotifictionAutoRemove:(NotifCenterType)typeName observer:(id)observer object:(id)object handle:(void(^)(NSNotification *notification))handle{
    
    [self addNotifictionName:NSStringFromNotifCenterName(typeName) observer:observer handle:handle object:object isAutoRemove:YES];
}

+ (void)removeNotifiction:(NotifCenterType)typeName observer:(id)observer{
 
    [self removeNotifictionName:NSStringFromNotifCenterName(typeName) observer:observer];
}

+ (void)removeAllNotifiction:(id)observer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark -
+ (void)addNotifictionName:(NSString *)name observer:(id)observer handle:(void(^)(NSNotification *notification))handle object:(id)object isAutoRemove:(BOOL)flag{
    
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(handleNotification:) name:name object:nil];
    
    [[self sharedNotificationCenterHelper].mNotificationCenterTaskDic setValue:[handle copy] forKey:name];
}

+ (void)addNotifiction:(NotifCenterType)typeName observer:(id)observer selector:(SEL)selector{
    
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:NSStringFromNotifCenterName(typeName) object:nil];
}

+ (void)postNotifiction:(NotifCenterType)typeName userInfo:(NSDictionary *)userInfo{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromNotifCenterName(typeName) object:nil userInfo:userInfo];
}

+ (void)removeNotifictionName:(NSString *)name observer:(id)observer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
}

- (void)handleNotification:(NSNotification *)notification{
    
    NotificationBlock handle = [self.mNotificationCenterTaskDic objectForKey:notification.name];
    
    if(handle){
        
        [self.mNotificationCenterTaskDic removeObjectForKey:notification.name];
        [NotificationCenterHelper removeNotifictionName:notification.name observer:notification];
        
        handle(notification);
    }
}


//+ (NotifyObject *)createNotifyObject:(id)object,...;

@end

/**
 *  NotifyObject
 */
@implementation NotifyObject

@end

