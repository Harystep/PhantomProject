//
//  ESBaseListData.h
//  EShopClient
//
//  Created by Abner on 2019/5/15.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESBaseListData : NSObject

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, assign) BOOL isFirstPage;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, assign) NSInteger firstPage;
@property (nonatomic, assign) NSInteger lastPage;

@end

NS_ASSUME_NONNULL_END
