//
//  NSObject+SafeObject.h
//  Abner
//
//  Created by Abner on 15/3/10.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  对 NSString、NSArray、NSDictionary 的验证
 */

@interface NSObject (SafeObject)

/**
 *  Checking if object is NSString or NSMutableString
 */
- (BOOL)isNSString;

/**
 *  Checking string is valid and return self or @""
 */
+ (NSString *)stringSafeChecking:(id)object;

/**
 *  Checking if object is NSArray or NSMutableArray
 */
- (BOOL)isNSArray;

/**
 *  Checking if object is NSMutableArray
 */
- (BOOL)isNSMutableArray;

/**
 *  Checking if object is NSDictionary or NSMutableDictionary
 */
- (BOOL)isNSDictionary;

/**
 *  Checking if object is empty or nil or null
 *
 *  @return If nil,description the object is empty or not valid
 */
+ (id)isNotEmptyAndValid:(id)object;

/**
*   Checking if object is empty
*
*   @return If nil,description the object is empty
*/
- (id)isEmpty;

/**
 *  Checking if object is nil or null
 *
 *  @return If nil,description the object is not valid
 */
+ (id)isValid:(id)object;

/**
 *  NSArray safe object at index
 *
 *  @return If nil,description the object is null or array bounds
 */
- (id)objectAtIndexForSafe:(NSInteger)index;

/**
 *  NSMutableArray safe remove object at index
 */
- (BOOL)removeObjectAtIndexForSafe:(NSInteger)index;

/**
 *  check is only number text
 */
+ (BOOL)isNumberString:(id)object;

/**
 *  filter the empty string form array
 */
+ (id)filterEmptyStringFromArray:(id)object;

@end
