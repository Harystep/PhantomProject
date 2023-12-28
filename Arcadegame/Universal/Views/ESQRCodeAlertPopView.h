//
//  ESQRCodeAlertPopView.h
//  EShopClient
//
//  Created by Abner on 2019/7/24.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESAlertPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESQRCodeAlertPopView : ESAlertPopBaseView

- (instancetype)initWithQRContnet:(NSString *)content;
@property (nonatomic, copy) void(^longPressHandle)(UIImage *image);

@end

NS_ASSUME_NONNULL_END
