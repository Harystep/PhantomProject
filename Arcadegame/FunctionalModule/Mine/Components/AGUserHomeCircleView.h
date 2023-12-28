//
//  AGUserHomeCircleView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "ABMultiContentBaseView.h"
#import "AGCircleMemberData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGUserHomeCircleView : ABMultiContentBaseView

@property (strong, nonatomic) NSArray<AGCircleMemberOtherGroupData *> *data;

@end

/**
 * AGUserHomeCircleTableViewCell
 */
@interface AGUserHomeCircleTableViewCell : UITableViewCell

@property (strong, nonatomic) AGCircleMemberOtherGroupData *data;

@end

NS_ASSUME_NONNULL_END
