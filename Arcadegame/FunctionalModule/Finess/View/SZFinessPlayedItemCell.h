//
//  SZFinessPlayedItemCell.h
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZFinessPlayedItemCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)finessPlayedItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
