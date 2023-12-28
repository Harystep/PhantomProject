//
//  AGHomeClassifyData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import "AGHomeClassifyData.h"

@implementation AGHomeClassifyListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"list":@"AGHomeClassifyData"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"list": @"data"};
}

- (void)resortHomeClassifyList {
    
    if(self.list && self.list.count) {
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
        [self.list sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
}

@end

/**
 * AGHomeClassifyData
 */
@implementation AGHomeClassifyData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end
