//
//  QBPasswordFieldView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/8/15.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QBPasswordFieldView : UIView

/**
 TextField 输入框回调
 */
@property (nonatomic, copy) void(^textFieldDidChangedHandle)(NSString *cString, NSString *passwordString);

/**
 密码值，只有完全输完的时候才有值
 */
@property (nonatomic, strong) NSString *passwordString;

/**
 边框颜色，如果需要同时设置圆角，先设置颜色再设置圆角
 */
@property (nonatomic, strong) UIColor *textBorderColor;

/**
 设置圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 输完密码是否自动隐藏键盘（默认为YES）
 */
@property (nonatomic, assign) BOOL shouldAutoHideKeyboard;

/**
 初始化

 @param frame 大小
 @param length 密码长度
 */
- (instancetype)initWithFrame:(CGRect)frame withPasswordLength:(NSInteger)length;

/**
 清除密码
 */
- (void)cleanPassword;

@end

NS_ASSUME_NONNULL_END
