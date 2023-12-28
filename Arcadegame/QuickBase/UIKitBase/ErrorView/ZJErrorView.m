//
//  KDErrorView.m
//  KuaiDaiMarket
//
//  Created by Abner on 2019/4/17.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ZJErrorView.h"
#import "NSMutableAttributedString+formate.h"

@interface ZJErrorView ()

@property (nonatomic, strong) UIImageView *errorLogoImageView;
@property (nonatomic, strong) UILabel *errorInfoLabel;

@end

@implementation ZJErrorView

- (instancetype)initWithKey:(NSString *)key{
    
    if(self = [super init]){
        
        if([NSString isNotEmptyAndValid:key]){
            
            NSDictionary *errorInfo = [[self getErrorViewConfig] valueForKey:key];
            
            if(errorInfo && errorInfo.count){
                
                NSString *errorImage = [NSString stringSafeChecking:errorInfo[@"errorImage"]];
                NSString *errorMessage = [NSString stringSafeChecking:errorInfo[@"errorMessage"]];
                NSString *errorMessageColor = [NSString stringSafeChecking:errorInfo[@"errorMessageColor"]];
                CGFloat errorMessageFont = [errorInfo[@"errorMessageFont"] floatValue];
                CGFloat errorPadding = [errorInfo[@"errorPadding"] floatValue];
                
                self.errorLogoImageView.origin = CGPointMake(0, 0);
                self.errorLogoImageView.image = IMAGE_NAMED(errorImage);
                [self.errorLogoImageView sizeToFit];
                
                errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                
                if(errorMessageFont){
                    
                    self.errorInfoLabel.font = [UIFont systemFontOfSize:errorMessageFont];
                }
                
                if([errorMessage rangeOfString:@"无需物流发货"].location != NSNotFound){
                    
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"该订单为"];
                    [attrString appendString:@"无需物流发货" font:[UIFont font15Bold] fontColor:[UIColor blackColor333333]];
                    self.errorInfoLabel.attributedText = attrString;
                }
                else {
                    self.errorInfoLabel.text = errorMessage;
                }
                [self.errorInfoLabel sizeToFit];
                
                self.errorInfoLabel.origin = CGPointMake((CGRectGetWidth(self.errorLogoImageView.frame) - CGRectGetWidth(self.errorInfoLabel.frame)) / 2.f, CGRectGetMaxY(self.errorLogoImageView.frame) + errorPadding);
                
                if(errorMessageColor.length){
                    
                    self.errorInfoLabel.textColor = UIColorFromRGB([HelpTools numberWithHexString:errorMessageColor]);
                }
                
                CGRect selfRect = CGRectZero;
                selfRect.size = CGSizeMake(CGRectGetWidth(self.errorLogoImageView.frame), CGRectGetMaxY(self.errorInfoLabel.frame));
                self.frame = selfRect;
                
                [self addSubview:self.errorLogoImageView];
                [self addSubview:self.errorInfoLabel];
            }
        }
    }
    
    return self;
}

- (NSDictionary *)getErrorViewConfig{
    
    return [[HelpTools readBaseConfigData] objectForKey:@"QBERRORVIEW"];
}

#pragma mark - Getter

- (UIImageView *)errorLogoImageView{
    
    if(!_errorLogoImageView){
        
        _errorLogoImageView = [UIImageView new];
    }
    
    return _errorLogoImageView;
}

- (UILabel *)errorInfoLabel{
    
    if(!_errorInfoLabel){
        
        _errorInfoLabel = [UILabel new];
        _errorInfoLabel.font = [UIFont font12];
        _errorInfoLabel.textColor = [UIColor blackColor];
        _errorInfoLabel.textAlignment = NSTextAlignmentCenter;
        _errorInfoLabel.numberOfLines = 0;
    }
    
    return _errorInfoLabel;
}

@end
