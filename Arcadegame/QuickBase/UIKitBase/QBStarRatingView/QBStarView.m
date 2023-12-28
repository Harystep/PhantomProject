//
//  QBStarView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/12.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBStarView.h"

@interface QBStarView ()

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

@end

@implementation QBStarView

- (instancetype)initWithWithImages:(NSArray<UIImage *> *)images{
    
    if(self = [super init]){
        self.backgroundColor = [UIColor clearColor];
        
        if(images &&
           images.count >= 2){
            
            self.selectedImage = [images objectAtIndex:0];
            self.unselectedImage = [images objectAtIndex:1];
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if(self.rating == 1.f){
        
        [self.selectedImage drawInRect:rect];
    }
    else if(self.rating == 0.f){
        
        [self.unselectedImage drawInRect:rect];
    }
    else {
        
        CGFloat leftWidth = rect.size.width * self.rating;
        CGFloat rightWidth = rect.size.width * (1.0 - self.rating);
        
        UIImage *leftImage = [self croppedImageWithImage:self.selectedImage rating:self.rating isLeft:YES];
        UIImage *rightImage = [self croppedImageWithImage:self.unselectedImage rating:(1.0 - self.rating) isLeft:NO];
        
        [leftImage drawInRect:(CGRect){CGPointZero, {leftWidth, rect.size.height}}];
        [rightImage drawInRect:(CGRect){{leftWidth, 0.f}, {rightWidth, rect.size.height}}];
    }
}

- (void)setRating:(CGFloat)rating{
    _rating = rating;
    
    [self setNeedsDisplay];
}

#pragma mark -

- (UIImage *)croppedImageWithImage:(UIImage *)image rating:(CGFloat)rating isLeft:(BOOL)isLeft{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * rating, image.size.height), NO, 0);
    
    if(isLeft){
        
        [image drawAtPoint:CGPointMake(0.f, 0.f)];
    }
    else {
        [image drawAtPoint:CGPointMake(image.size.width * rating - image.size.width, 0.f)];
    }
    
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

#pragma mark - Getter

- (UIImage *)selectedImage{
    
    if(!_selectedImage){
        
        _selectedImage = [UIImage imageNamed:@"qb_star_selected"];
    }
    
    return _selectedImage;
}

- (UIImage *)unselectedImage{
    
    if(!_unselectedImage){
        
        _unselectedImage = [UIImage imageNamed:@"qb_star_unselected"];
    }
    
    return _unselectedImage;
}

@end
