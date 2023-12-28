//
//  AGSettingTableViewCell.h
//  Arcadegame
//
//  Created by Sean on 2023/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGSettingItem : NSObject

@property (strong, nonatomic) NSString *settingIcon;
@property (strong, nonatomic) NSString *settingName;
@property (strong, nonatomic) NSString *settingTitle;

- (instancetype)initWithType:(NSString *)title name:(NSString *)name icon:(NSString *)icon;

@end

@interface AGSettingTableViewCell : UITableViewCell

@property (strong, nonatomic) AGSettingItem *setting;

@end

NS_ASSUME_NONNULL_END
