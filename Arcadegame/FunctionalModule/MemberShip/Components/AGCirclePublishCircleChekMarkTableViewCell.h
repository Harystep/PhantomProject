//
//  AGCirclePublishCircleChekMarkTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGCirclePublishCircleChekMarkTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (strong, nonatomic) NSString *palaceholder;

@property (nonatomic, copy) void(^textDidChangedHandle)(NSString *text, NSIndexPath *indexPath);
- (NSString *)inputContent;

@end

NS_ASSUME_NONNULL_END
