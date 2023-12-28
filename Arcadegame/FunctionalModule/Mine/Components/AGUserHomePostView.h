//
//  AGUserHomePostView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "ABMultiContentBaseView.h"
#import "AGCircleMemberData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGUserHomePostView : ABMultiContentBaseView

@property (strong, nonatomic) NSArray<AGCircleMemberOtherGroupDynamicsData *> *data;

@end

/**
 * AGUserHomePostTableViewCell
 */
@interface AGUserHomePostTableViewCell : UITableViewCell

@property (strong, nonatomic) AGCircleMemberOtherGroupDynamicsData *data;

@end

NS_ASSUME_NONNULL_END
