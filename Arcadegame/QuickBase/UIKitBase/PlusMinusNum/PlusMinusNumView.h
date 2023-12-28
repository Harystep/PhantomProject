//
//  PlusMinusNumView.h
//  Abner
//
//  Created by Abner on 15/6/2.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlusMinusNumView : UIView

@property (nonatomic, assign) NSInteger numberValue;
@property (nonatomic, assign) NSInteger defaultValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) BOOL shouldEnable;

@property (nonatomic, copy) void(^plusMinusValueHandle)(NSInteger num, NSInteger viewTag, BOOL isPlus);

@end
