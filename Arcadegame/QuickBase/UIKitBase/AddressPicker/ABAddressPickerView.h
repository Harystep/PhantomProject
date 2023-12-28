//
//  ABAddressPickerView.h
//  QuickBase
//
//  Created by Abner on 2019/5/23.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static NSString *kAddrPickerProvence = @"kAddrPickerProvence";
const static NSString *kAddrPickerZone = @"kAddrPickerZone";
const static NSString *kAddrPickerCity = @"kAddrPickerCity";

/**
 *  一网乡汇地址选择器
 */

@interface ABAddressPickerView : UIView

@property (nonatomic, strong, readonly) NSDictionary *addressValueDic;

@property (nonatomic, copy) void(^addressValueDidChangedHandle)(void);
@property (nonatomic, copy) void(^addressPickerShouldHideHandle)(void);

@end


/**
 * ABAddressPickerTableViewCell
 */

@interface ABAddressPickerTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
