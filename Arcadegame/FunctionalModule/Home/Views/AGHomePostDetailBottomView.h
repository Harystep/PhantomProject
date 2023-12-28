//
//  AGHomePostDetailBottomView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGHomePostDetailBottomView : UIView

@property (copy, nonatomic) void(^didConfirmHandle)(void);
- (NSString *)inputContent;
- (void)cleanContent;

@end

NS_ASSUME_NONNULL_END
