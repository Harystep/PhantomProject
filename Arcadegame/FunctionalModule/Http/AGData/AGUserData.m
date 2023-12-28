//
//  AGUserData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "AGUserData.h"

@implementation AGUserData

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]){
        
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.aliasId = [aDecoder decodeObjectForKey:@"aliasId"];
        self.angelPoints = [aDecoder decodeObjectForKey:@"angelPoints"];
        self.authStatus = [aDecoder decodeObjectForKey:@"authStatus"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.goldCoin = [aDecoder decodeObjectForKey:@"goldCoin"];
        self.hxId = [aDecoder decodeObjectForKey:@"hxId"];
        self.hxPwd = [aDecoder decodeObjectForKey:@"hxPwd"];
        self.inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.points = [aDecoder decodeObjectForKey:@"points"];
        self.registerTime = [aDecoder decodeObjectForKey:@"registerTime"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.aliasId forKey:@"aliasId"];
    [aCoder encodeObject:self.angelPoints forKey:@"angelPoints"];
    [aCoder encodeObject:self.authStatus forKey:@"authStatus"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.goldCoin forKey:@"goldCoin"];
    [aCoder encodeObject:self.hxId forKey:@"hxId"];
    [aCoder encodeObject:self.hxPwd forKey:@"hxPwd"];
    [aCoder encodeObject:self.inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.points forKey:@"points"];
    [aCoder encodeObject:self.registerTime forKey:@"registerTime"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

@end

@implementation AGUserTokenData

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]){
        
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
        self.refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];
    [aCoder encodeObject:self.refreshToken forKey:@"refreshToken"];
}

@end
