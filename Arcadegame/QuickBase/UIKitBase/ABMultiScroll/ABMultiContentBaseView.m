
//
//  ABMultiContentBaseView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/3.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ABMultiContentBaseView.h"

@implementation ABMultiContentBaseView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
    //DLOG(@"scrollViewDidScroll:%@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
