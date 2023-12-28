//
//  AGHomeClassifyData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import "AGBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGHomeClassifyData;

@interface AGHomeClassifyListData : AGBaseData

@property (nonatomic, strong) NSArray<AGHomeClassifyData *> *list;

- (void)resortHomeClassifyList;

@end

/**
 * AGHomeClassifyData
 */
@interface AGHomeClassifyData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger sort;
@property (assign, nonatomic) NSInteger flag;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
