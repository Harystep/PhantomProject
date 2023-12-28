//
//  AGGameMultiBaseView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/18.
//

#import "ABMultiContentBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class AGGameRoomData;

@interface AGGameMultiBaseView : ABMultiContentBaseView

@property (strong, nonatomic) NSArray<AGGameRoomData *> *data;

@end

/**
 * AGGameCollectionViewCell
 */
@interface AGGameCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSData *data;

@end

/**
 * AGGameCollectionViewInfoView
 */
@interface AGGameCollectionViewInfoView : UIView

@property (strong, nonatomic) NSString *info;

@end

NS_ASSUME_NONNULL_END
