//
//  NetWorkListViewController.h
//  KuaiDaiMarket
//
//  Created by Abner on 2019/4/23.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetWorkListData;

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkListViewController : UIViewController

- (instancetype)initWithNetDataSource:(NSArray <NetWorkListData *> *)dataArray;
- (void)autoDevelopmentEnvironment:(NSInteger)index;

@property (nonatomic, copy) void(^dismissDidHandle)(NSInteger type);

@end

/*
 *  NetWorkListData
 */
@interface NetWorkListData : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *newsUrl;

+ (NetWorkListData *)dataWithUrl:(NSString *)url
                            desc:(NSString *)desc
                         newsUrl:(NSString *)newsUrl;

@end

NS_ASSUME_NONNULL_END
