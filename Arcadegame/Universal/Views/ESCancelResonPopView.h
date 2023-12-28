//
//  ESCancelResonPopView.h
//  EShopClient
//
//  Created by Abner on 2019/7/10.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCancelResonPopView : ESPopBaseView

- (instancetype)initWithResonArray:(NSArray *)resonArray withTitle:(NSString *)title withInfo:(NSString *)info withSelectedText:(NSString *)text;

@property (nonatomic, copy) void(^confirmDidSelectedHandle)(NSString *reson, NSInteger index);

@end

NS_ASSUME_NONNULL_END
