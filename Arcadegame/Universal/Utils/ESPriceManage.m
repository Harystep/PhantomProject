//
//  ESPriceManage.m
//  EShopClient
//
//  Created by Abner on 2019/6/28.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESPriceManage.h"

@implementation ESPriceManage

+ (NSMutableAttributedString *)priceStringWithOriginString:(NSString *)string withLabel:(UILabel *)priveLabel withSmallFont:(UIFont *)smallFont{
    
    NSMutableAttributedString *priceString = nil;
    NSArray *priceArray = [string componentsSeparatedByString:@"-"];
    if(priceArray.count < 2){
        priceArray = [string componentsSeparatedByString:@"—"];
    }
    
    if(!priceArray || !priceArray.count){
        priceArray = @[[NSString stringSafeChecking:string]];
    }
    
    for(int i = 0; i < priceArray.count; ++i){
        
        CGFloat price = [priceArray[i] doubleValue];
        
        if(i == 0){
            NSString *subPriceString = priceArray[i];
            if(![NSString isNotEmptyAndValid:subPriceString]){
                priceString = [NSMutableAttributedString new];
            }
            else {
                //priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", @([HelpTools getValueIntegerPart:price])]];
                priceString = [HelpTools priceStringStartAtRMBSymbolFixWithDCNumberValue:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", @([HelpTools getValueIntegerPart:price])]]];
                
                NSInteger decimalPart = [HelpTools getValueDecimalPart:price withLength:2];
                if(decimalPart > 0){
                    
                    NSString *appendString = [NSString stringWithFormat:@".%02ld", (long)decimalPart];
                    [priceString appendString:appendString font:smallFont fontColor:priveLabel.textColor];
                }
            }
        }
        else {
            NSMutableAttributedString *fixPriceString = [HelpTools priceStringStartAtRMBSymbolFixWithDCNumberValue:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", @([HelpTools getValueIntegerPart:price])]]];
            
            [priceString appendAttributedString:fixPriceString];
            //[priceString appendString:[NSString stringWithFormat:@"￥%@", @([HelpTools getValueIntegerPart:price])] font:priveLabel.font fontColor:priveLabel.textColor];
            
            NSInteger decimalPart = [HelpTools getValueDecimalPart:price withLength:2];
            if(decimalPart > 0){
                
                NSString *appendString = [NSString stringWithFormat:@".%02ld", (long)decimalPart];
                [priceString appendString:appendString font:smallFont fontColor:priveLabel.textColor];
            }
        }
        
        if(i != (priceArray.count - 1)){
            
            [priceString appendString:@" -" font:priveLabel.font fontColor:priveLabel.textColor];
        }
    }
    
    return priceString;
}

@end
