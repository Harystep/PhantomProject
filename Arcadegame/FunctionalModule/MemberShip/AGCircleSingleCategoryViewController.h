//
//  AGCircleSingleCategoryViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "BaseViewController.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleSingleCategoryViewController : BaseViewController

@property (strong, nonatomic) AGCicleHomeOtherDtoData *chodData;
@property (copy, nonatomic) void(^noticeReloadListData)(void);

@end

NS_ASSUME_NONNULL_END
