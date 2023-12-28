//
//  AGBaseData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGBaseData : NSObject

@property (strong, nonatomic) NSString *errCode;
@property (strong, nonatomic) NSString *errMsg;
@property (assign, nonatomic) NSString *msg;
@property (assign, nonatomic) NSString *code;

@end

NS_ASSUME_NONNULL_END
