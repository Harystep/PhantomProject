//
//  AGSegmentControl.h
//  Arcadegame
//
//  Created by rrj on 2023/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AGSegmentItem;

typedef void (^AGSegmentCallback)(AGSegmentItem* segment, NSUInteger index);
typedef NS_ENUM(NSUInteger, AGSegmentControlStyle) {
    AGSegmentControlStyleLight,
    AGSegmentControlStyleColorful
};

@interface AGSegmentItem : NSObject

- (instancetype)initWithTitle:(NSString *)title callback:(AGSegmentCallback)callback;

@property (strong, nonatomic) AGSegmentCallback callback;
@property (strong, nonatomic) NSString *title;


@end

@interface AGSegmentControl : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithSegments:(NSArray<AGSegmentItem *> *)segments;
- (instancetype)initWithSegments:(NSArray<AGSegmentItem *> *)segments style:(AGSegmentControlStyle)style;

@property (assign, nonatomic) NSInteger selectedIndex;
- (void)resetSegments:(NSArray<AGSegmentItem *> *)segments;

@end

NS_ASSUME_NONNULL_END
