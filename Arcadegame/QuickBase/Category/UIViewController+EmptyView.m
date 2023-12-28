//
//  UIViewController+EmptyView.m
//  Interactive
//
//  Created by Abner on 2016/11/8.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "UIViewController+EmptyView.h"

@implementation UIViewController (EmptyView)

- (void)setEmptyView:(NSString *)noticeString{
    
    if([self.view viewWithTag:919191]){
        
        [self replaseEmptyNotice:noticeString];
        
        return;
    }
    
    UIImageView *icionImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"img_nothing")];
    [self.view addSubview:icionImageView];
    icionImageView.tag = 919191;
    
    icionImageView.centerX = self.view.width / 2.f;
    icionImageView.centerY = self.view.height / 2.f - icionImageView.height;
    
    UIFont *noticeLabelFont = FONT_SYSTEM(16.f);
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding * 2, icionImageView.bottom + kPadding * 2, self.view.width - kPadding * 2 * 2, noticeLabelFont.lineHeight)];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor mainLowergrayColor];
    noticeLabel.text = [NSString stringSafeChecking:noticeString];
    noticeLabel.font = noticeLabelFont;
    noticeLabel.numberOfLines = 0;
    noticeLabel.tag = 909090;
    
    noticeLabel.height = [noticeLabel sizeThatFits:CGSizeMake(noticeLabel.width, CGFLOAT_MAX)].height;
    
    [self.view addSubview:noticeLabel];
}

- (void)replaseEmptyNotice:(NSString *)noticeString{
    
    UILabel *noticeLabel = (UILabel *)[self.view viewWithTag:909090];
    noticeLabel.text = [NSString stringSafeChecking:noticeString];
    
    noticeLabel.height = [noticeLabel sizeThatFits:CGSizeMake(noticeLabel.width, CGFLOAT_MAX)].height;
}

- (void)removeEmptyView{
    
    [[self.view viewWithTag:909090] removeFromSuperview];
    [[self.view viewWithTag:919191] removeFromSuperview];
}

@end
