//
//  ESPopBaseView.h
//  EShopClient
//
//  Created by Abner on 2019/5/20.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESPopBaseView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
