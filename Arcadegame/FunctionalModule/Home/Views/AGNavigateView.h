//
//  AGNavigateView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGNavigateView : UIView

@property (copy, nonatomic) void(^navigateLeftDidSelected)(void);
@property (assign, nonatomic) CGFloat fixedTop;
@property (assign, nonatomic) CGFloat fixedHeight;

- (void)setAGLeftNaviButtonHide:(BOOL)isHide;
- (void)setAGNaviTitle:(NSString *)title;


@property (nonatomic, assign) BOOL shouldChangeStatusStyle;

- (void)agNavigateViewDidScrollOffsetY:(CGFloat)scrollOffsetY;
- (void)setNaviLeftWithImages:(NSArray<NSString *> *)images andHighImages:(NSArray<NSString *> *)selectedImages;

@end

NS_ASSUME_NONNULL_END
