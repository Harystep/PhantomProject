//
//  AGHomePostTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/16.
//

#import <UIKit/UIKit.h>
#import "AGCicleHomeRecommendData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HomePostTableViewCorner) {
    
    KHomePostTableViewCorner_top,
    KHomePostTableViewCorner_Bottom,
    KHomePostTableViewCorner_All,
    KHomePostTableViewCorner_None,
};

@interface AGHomePostTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) HomePostTableViewCorner corner;
@property (strong, nonatomic) AGCicleHomeRGroupDynamicData *mData;

@end

NS_ASSUME_NONNULL_END
