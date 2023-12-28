//
//  AGCirclePublishCircleNameTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AGCirclePublishCircleNameItem;

@interface AGCirclePublishCircleNameTableViewCell : UITableViewCell

@property (strong, nonatomic) AGCirclePublishCircleNameItem *mCPCNItem;

@end

/**
 * AGCirclePublishCircleNameItem
 */
@interface AGCirclePublishCircleNameItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *groupID;

+ (AGCirclePublishCircleNameItem *)getCPCNItemWithTitle:(NSString *)title withGroupID:(NSString *)groupID;

@end

NS_ASSUME_NONNULL_END
