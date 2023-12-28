//
//  ABMultiContentView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/5/31.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABMultiContentViewDelegate, ABMultiContentViewDataSource;

@interface ABMultiContentView : UIView

@property (nonatomic, weak) id<ABMultiContentViewDelegate> delegate;
@property (nonatomic, weak) id<ABMultiContentViewDataSource> dataSource;

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index;

@end

/**
 ABMultiContentViewDelegate
 */
@protocol ABMultiContentViewDelegate <NSObject>

- (void)contentView:(ABMultiContentView *)contentView didScrollToIndex:(NSInteger)index;
- (void)contentView:(ABMultiContentView *)contentView willScrollToIndex:(NSInteger)index;

@end

/**
 ABMultiContentViewDataSource
 */
@protocol ABMultiContentViewDataSource <NSObject>

- (UIView *)contentView:(ABMultiContentView *)contentView pageIndex:(NSInteger)index;
- (NSInteger)numberOfItemsInContentView:(ABMultiContentView *)contentView;

@end

NS_ASSUME_NONNULL_END
