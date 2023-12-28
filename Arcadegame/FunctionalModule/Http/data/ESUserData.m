//
//  ESUserData.m
//  EShopClient
//
//  Created by Abner on 2019/6/18.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESUserData.h"

@implementation ESUserData

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]){
        
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.memId = [aDecoder decodeObjectForKey:@"memId"];
        self.memPhone = [aDecoder decodeObjectForKey:@"memPhone"];
        self.memPortrait = [aDecoder decodeObjectForKey:@"memPortrait"];
        self.memNickname = [aDecoder decodeObjectForKey:@"memNickname"];
        self.memStatus = [aDecoder decodeIntegerForKey:@"memStatus"];
        self.ryToken = [aDecoder decodeObjectForKey:@"ryToken"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.memId forKey:@"memId"];
    [aCoder encodeObject:self.memPhone forKey:@"memPhone"];
    [aCoder encodeObject:self.memPortrait forKey:@"memPortrait"];
    [aCoder encodeObject:self.memNickname forKey:@"memNickname"];
    [aCoder encodeInteger:self.memStatus forKey:@"memStatus"];
    [aCoder encodeObject:self.ryToken forKey:@"ryToken"];
}

+ (void)updateUserDataWith:(ESUserData *)userData{
    
    ESUserData *currentUserData = [HelpTools userData];
    
    currentUserData.memId = userData.memId;
    currentUserData.memPhone = userData.memPhone;
    currentUserData.memPortrait = userData.memPortrait;
    currentUserData.memStatus = userData.memStatus;
    
    if([NSString isNotEmptyAndValid:userData.memNickname]){
        
        currentUserData.memNickname = userData.memNickname;
    }
    else {
        
        currentUserData.memNickname = @"一网乡汇会员";
    }
    
    [HelpTools saveUserData:currentUserData];
}

@end

/// ESUserThirdData
@implementation ESUserThirdData

@end
