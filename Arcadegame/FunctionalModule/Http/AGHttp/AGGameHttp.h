//
//  AGGameHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "BaseManage.h"
#import "AGGameData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_GAME_ROOMGROUP_URLAPI = @"/room/group/list";
static const NSString *AG_GAME_LIST_URLAPI = @"/room/list";
static const NSString *AG_GAME_ROOMENTER_URLAPI = @"/room/enter/v2";
static const NSString *AG_GAME_VIDEO = @"/home/getRoomVideo";

@interface AGGameHttp : BaseManage

@end

/**
 * AGGameRoomGroupListHttp
 */
@interface AGGameRoomGroupListHttp : BaseManage

- (void)requestGameRoomGroupListResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (strong, nonatomic) AGGameRoomGroupListData *mBase;

@end

/**
 * AGGameRoomListHttp
 */
@interface AGGameRoomListHttp : BaseManage

- (void)requestGameRoomListResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) AGGameRoomListListData *mBase;

@end

/**
 * AGGameRoomEnterHttp
 */
@interface AGGameRoomEnterHttp : BaseManage

- (void)requestGameRoomEnterResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (strong, nonatomic) AGGameRoonEnterData *mBase;
@property (strong, nonatomic) NSString *roomID;

@end

/**
 * AGGameVideoHttp
 */
@interface AGGameVideoHttp : BaseManage

- (void)requestGameVideoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (strong, nonatomic) AGGameVideoData *mBase;
@property (strong, nonatomic) NSString *roomID;

@end

NS_ASSUME_NONNULL_END
