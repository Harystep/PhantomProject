//
//  ESImageBrowserView.h
//  EShopClient
//
//  Created by Abner on 2019/6/10.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESImageBrowserView : UIView

- (void)show;
- (void)hide;

- (void)setImagesArray:(NSArray *)imagesArray withCurrentIndex:(NSInteger)index withCacheKey:(NSString *)cacheKey;

@end

NS_ASSUME_NONNULL_END
