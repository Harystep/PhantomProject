//
//  QBPlaceholderTextView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/20.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QBPlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;

/**
默认 grayColor
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 文字起始位置, 默认{5.f, 8.f}
 */
@property (nonatomic, assign) CGPoint originPoint;

@property (nonatomic, copy) void(^didTextDidChangeHandle)(QBPlaceholderTextView *textView);

@end

NS_ASSUME_NONNULL_END
