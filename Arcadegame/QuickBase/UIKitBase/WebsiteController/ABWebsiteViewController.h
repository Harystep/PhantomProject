//
//  ABWebsiteViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/7/5.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABWebsiteViewController : BaseViewController

- (instancetype)initWithUrl:(NSString *)urlString;
@property (strong, nonatomic) NSString *naviTitleString;

@end

NS_ASSUME_NONNULL_END
