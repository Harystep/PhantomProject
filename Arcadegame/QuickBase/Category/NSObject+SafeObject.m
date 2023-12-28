//
//  NSObject+SafeObject.m
//  Abner
//
//  Created by Abner on 15/3/10.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "NSObject+SafeObject.h"

@implementation NSObject (SafeObject)

- (BOOL)isNSString{
    return ([self isKindOfClass:[NSString class]] ||
            [self isKindOfClass:[NSMutableString class]])?YES:NO;
}

- (BOOL)isNSArray{
    return ([self isKindOfClass:[NSArray class]] ||
            [self isKindOfClass:[NSMutableArray class]])?YES:NO;
}

- (BOOL)isNSMutableArray{
 
    return [self isKindOfClass:[NSMutableArray class]]?YES:NO;
}

- (BOOL)isNSDictionary{
    return ([self isKindOfClass:[NSDictionary class]] ||
            [self isKindOfClass:[NSMutableDictionary class]])?YES:NO;
}

//Checking if object is empty
- (id)isEmpty{
    
    if([self isNSString]){
        return [(NSString *)self isEqualToString:@""]?nil:self;
    }
    else if([self isNSArray]){
        return [(NSArray *)self count]?self:nil;
    }
    else if([self isNSDictionary]){
        return [(NSDictionary *)self count]?self:nil;
    }
    else if([NSObject isValid:self]){
        return self;
    }
    
    return nil;
}

//NSArray safe object at index
- (id)objectAtIndexForSafe:(NSInteger)index{
    
    if(![self isNSArray]){
        return nil;
    }
    
    if((index >= 0) && (index < [(NSArray *)self count])){
        id object = [(NSArray *)self objectAtIndex:index];
        if(!object || [object isKindOfClass:[NSNull class]]){
            return nil;
        }
        
        return object;
    }
    
    return nil;
}

//NSMutableArray safe remove object at index
- (BOOL)removeObjectAtIndexForSafe:(NSInteger)index{
    
    if(![self isNSMutableArray]){
        return NO;
    }
    
    if((index >= 0) && (index < [(NSArray *)self count])){
        
        [(NSMutableArray *)self removeObjectAtIndex:index];
        
        return YES;
    }
    
    return NO;
}

//Checking if object is nil or null
+ (id)isValid:(id)object{
    
    if([object isNSString]){
        return ((nil == object) || [object isEqual:[NSNull null]] || [(NSString *)object isEqualToString:@"(null)"])?nil:object;
    }
    else {
        return ((nil == object) || [object isEqual:[NSNull null]])?nil:object;
    }
    
    return nil;
}

+ (NSString *)stringSafeChecking:(id)object{
    if([NSObject isValid:object] && [object isNSString]){
        return (NSString *)object;
    }
    
    return @"";
}

//Checking if object is empty or nil or null
+ (id)isNotEmptyAndValid:(id)object{
    if([NSObject isValid:object] && [(NSObject *)object isEmpty]){
        return object;
    }
    
    return nil;
}

+ (BOOL)isNumberString:(id)object{
    
    if([NSObject isNotEmptyAndValid:object] &&
       [object isNSString]){
        
        BOOL isNumber = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"] evaluateWithObject:object];
        
        return isNumber;
    }
    
    return NO;
}


//filter the empty string form array
+ (id)filterEmptyStringFromArray:(id)object {
    
    if(![object isNSArray] && ![object isNSMutableArray]){
        return object;
    }
    
    NSMutableArray *selfMutableCopy = [object mutableCopy];
    NSMutableArray *emptyObjects = [NSMutableArray new];
    for (id subObject in object) {
        
        if([subObject isNSString] && ![NSObject isNotEmptyAndValid:subObject]){
            
            [emptyObjects addObject:subObject];
        }
    }
    
    if(emptyObjects.count) {
        
        [selfMutableCopy removeObjectsInArray:emptyObjects];
    }
    
    return selfMutableCopy;
}

@end
