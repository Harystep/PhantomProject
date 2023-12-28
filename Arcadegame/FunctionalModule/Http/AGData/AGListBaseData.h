//
//  AGListBaseData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGListBaseData : NSObject

@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) NSString *page_size;
@property (strong, nonatomic) NSString *total_pages;
@property (strong, nonatomic) NSString *total_records;

@end

NS_ASSUME_NONNULL_END
