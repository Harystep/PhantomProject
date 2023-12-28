//
//  ESUserData.h
//  EShopClient
//
//  Created by Abner on 2019/6/18.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESUserData : NSObject

@property (nonatomic, strong) NSString *ryToken;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *memId;
@property (nonatomic, strong) NSString *memPhone;
@property (nonatomic, strong) NSString *memPortrait;
@property (nonatomic, strong) NSString *memNickname;
@property (nonatomic, assign) NSInteger memStatus;

+ (void)updateUserDataWith:(ESUserData *)userData;

@end

/// ESUserThirdData
@interface ESUserThirdData : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *ryToken;
@property (nonatomic, strong) NSString *isBindPhone;
@property (nonatomic, strong) NSString *opendId;
@property (nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *memPortrait;

@end

NS_ASSUME_NONNULL_END
