//
//  AGHomeBaseView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "ABMultiContentBaseView.h"
#import "AGHomePostTableViewCell.h"
#import "AGCicleHomeRecommendData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeBaseView : ABMultiContentBaseView

@property (nonatomic, strong) NSArray<AGCicleHomeRGroupDynamicData *> *postArray;

@property (strong, nonatomic) UITableView *mTableView;
@property (copy, nonatomic) void(^didSelectedTableCellHandle)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
