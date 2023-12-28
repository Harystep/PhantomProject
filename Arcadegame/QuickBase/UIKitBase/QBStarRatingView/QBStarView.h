//
//  QBStarView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/12.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QBStarView : UIView

@property (nonatomic, assign) CGFloat rating;

- (instancetype)initWithWithImages:(NSArray<UIImage *> *)images;

@end

NS_ASSUME_NONNULL_END
