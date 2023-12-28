//
//  AGUserData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGUserTokenData;

@interface AGUserData : NSObject

@property (strong, nonatomic) AGUserTokenData *accessToken;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *aliasId;
@property (strong, nonatomic) NSString *angelPoints;
@property (strong, nonatomic) NSString *authStatus;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *goldCoin;
@property (strong, nonatomic) NSString *hxId;
@property (strong, nonatomic) NSString *hxPwd;
@property (strong, nonatomic) NSString *inviteCode;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSString *registerTime;
@property (strong, nonatomic) NSString *type;

@end

@interface AGUserTokenData : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *expireTime;
@property (strong, nonatomic) NSString *refreshToken;

@end

NS_ASSUME_NONNULL_END
