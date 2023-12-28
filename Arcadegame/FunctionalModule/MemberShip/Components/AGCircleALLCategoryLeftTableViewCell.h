//
//  AGCircleALLCategoryLeftTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>
#import "AGHomeClassifyData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleALLCategoryLeftTableViewCell : UITableViewCell

@property (strong, nonatomic) AGHomeClassifyData *data;
@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
