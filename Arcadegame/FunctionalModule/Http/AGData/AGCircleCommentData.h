//
//  AGCircleCommentData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCircleCommentMemberBaseDtoData;

@interface AGCircleCommentData : AGBaseData

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) AGCircleCommentMemberBaseDtoData *memberBaseDto;

@end

/**
 * AGCircleCommentListData
 */
@interface AGCircleCommentListData : AGBaseData

@property (strong, nonatomic) NSArray<AGCircleCommentData *> *data;

@end

/**
 * AGCircleCommentMemberBaseDtoData
 */
@interface AGCircleCommentMemberBaseDtoData : NSObject

@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *levelName;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *nickname;

@end

NS_ASSUME_NONNULL_END
