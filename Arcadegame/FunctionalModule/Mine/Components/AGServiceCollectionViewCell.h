//
//  AGServiceCollectionViewCell.h
//  Arcadegame
//
//  Created by Sean on 2023/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGServiceItem : NSObject

@property (strong, nonatomic) NSString *serviceType;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSString *serviceIcon;

- (instancetype)initWithType:(NSString *)type name:(NSString *)name icon:(NSString *)icon;

@end

@interface AGServiceCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AGServiceItem *serviceItem;

@end

NS_ASSUME_NONNULL_END
