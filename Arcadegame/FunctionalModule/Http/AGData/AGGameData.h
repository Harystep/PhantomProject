//
//  AGGameData.h
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "AGBaseData.h"
#import "AGListBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGGameRoomData;
@class AGGameRoomListData;
@class AGGameRoomGroupData;
@class AGGameRoomGroupSubListData;

@interface AGGameData : AGBaseData

@end

/**
 * AGGameRoomGroupListData
 */
@interface AGGameRoomGroupListData : AGBaseData

@property (strong, nonatomic) NSArray<AGGameRoomGroupData *> *data;

@end

/**
 * AGGameRoomGroupData
 */
@interface AGGameRoomGroupData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSArray<AGGameRoomGroupSubListData *> *roomGroupList;

@end

/**
 * AGGameRoomGroupSubListData
 */
@interface AGGameRoomGroupSubListData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *groupName;

@end

/**
 * AGGameRoomListListData
 */
@interface AGGameRoomListListData : AGBaseData

@property (strong, nonatomic) AGGameRoomListData *data;

@end

/**
 * AGGameRoomListData
 */
@interface AGGameRoomListData : AGListBaseData

@property (strong, nonatomic) NSArray<AGGameRoomData *> *data;

@end

/**
 * AGGameRoomData
 */
@interface AGGameRoomData : NSObject

@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *roomImg;
@property (strong, nonatomic) NSString *machineId;
@property (strong, nonatomic) NSString *machineSn;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *machineType;
@property (strong, nonatomic) NSString *minLevel;
@property (strong, nonatomic) NSString *minGold;
@property (strong, nonatomic) NSString *multiple;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *cost;

@end

/**
 * AGGameRoonEnterData
 */
@interface AGGameRoonEnterData : AGBaseData

@end

/**
 * AGGameVideoData
 */
@interface AGGameVideoData : AGBaseData

@property (strong, nonatomic) NSArray *data;

@end

NS_ASSUME_NONNULL_END
