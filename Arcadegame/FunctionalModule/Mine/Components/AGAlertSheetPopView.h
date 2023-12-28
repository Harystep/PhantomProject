//
//  AGAlertSheetPopView.h
//  Arcadegame
//
//  Created by Abner on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGAlertSheetPopView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
