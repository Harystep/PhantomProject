//
//  AGCirclePublishViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "BaseViewController.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AGCirclePublishItemType) {
    
    kAGCirclePublishItemType_Blank,
    kAGCirclePublishItemType_Name,
    kAGCirclePublishItemType_Text,
    kAGCirclePublishItemType_TakePho,
    kAGCirclePublishItemType_Mark,
    kAGCirclePublishItemType_Confirm,
};

@interface AGCirclePublishViewController : BaseViewController

@property (strong, nonatomic) AGCicleHomeOtherDtoData *chodData;

@end

/**
 * AGCirclePublishItem
 */
@interface AGCirclePublishItem : NSObject

@property (assign, nonatomic) AGCirclePublishItemType type;
@property (strong, nonatomic) NSString *defaultValue;
@property (strong, nonatomic) NSString *resultValue;

+ (instancetype)iniWithType:(AGCirclePublishItemType)type defaultValue:(NSString *)defaultValue;

@property (strong, nonatomic) NSString *data;

@end

NS_ASSUME_NONNULL_END
