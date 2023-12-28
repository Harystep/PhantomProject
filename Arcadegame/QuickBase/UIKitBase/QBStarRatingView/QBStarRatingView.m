//
//  QBStarRatingView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/12.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBStarRatingView.h"
#import "QBStarView.h"

static const NSInteger kQBStarBaseTag = 1500;

@interface QBStarRatingView ()

@property (nonatomic, strong) NSArray<UIImage *> *starImagesArray;
@property (nonatomic, assign) NSInteger numberOfStar;
@property (nonatomic, assign) CGFloat perSpacing;

@end

@implementation QBStarRatingView

- (instancetype)initWithFrame:(CGRect)frame{
    
    return [self initWithFrame:frame withNumberOfStar:5];
}

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray<UIImage *> *)images{
    
    if(self = [self initWithFrame:frame withNumberOfStar:5]){
        
        self.starImagesArray = images;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withNumberOfStar:(NSInteger)number images:(NSArray<UIImage *> *)images{
    
    if(self = [self initWithFrame:frame withNumberOfStar:number]){
        
        self.starImagesArray = images;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withNumberOfStar:(NSInteger)number{
    
    if(self = [super initWithFrame:frame]){
        
        self.canDecimals = YES;
        self.canDragSelect = YES;
        self.numberOfStar = number;
        self.perSpacing = (self.spacing > 0)?:((CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) * number) / (number - 1));
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat originX = 0.f;
    
    for (int i = 0; i < self.numberOfStar; ++i) {
        
        QBStarView *starView = [self viewWithTag:kQBStarBaseTag + i];
        
        if(!starView){
            
            starView = [[QBStarView alloc] initWithWithImages:self.starImagesArray];
            starView.tag = kQBStarBaseTag + i;
            [self addSubview:starView];
        }
        
        starView.frame = CGRectMake(originX, 0.f, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        originX = CGRectGetMaxX(starView.frame) + self.perSpacing;
        
        NSInteger focusIndex = floorf(self.starRating);
        if(i < focusIndex){
            
            starView.rating = 1.f;
        }
        else if(i > focusIndex){
            
            starView.rating = 0.f;
        }
        else {
            
            starView.rating = self.starRating - focusIndex;
        }
    }
}

#pragma mark - Setter

- (void)setStarRating:(CGFloat)starRating{
    
    if(starRating < 0 ||
       starRating > self.numberOfStar){
        
        return;
    }
    
    if(!self.canDecimals){
        
        _starRating = floorf(starRating);
    }
    else {
        
        _starRating = starRating;
        if(self.isHalfStar){
            
            if(starRating - floorf(starRating) > 0.5){
                
                _starRating = ceilf(starRating);
            }
            else {
                
                _starRating = floorf(starRating) + 0.5;
            }
        }
    }
    [self setNeedsLayout];
}

#pragma mark - Private

- (void)getStarRatingForTouch:(UITouch *)touch{
    
    CGPoint currentPoint = [touch locationInView:self];
    
    CGFloat x = (currentPoint.x) / (CGRectGetHeight(self.frame) + self.perSpacing);
    
    CGFloat proRating = 0.f;
    
    if(self.isHalfStar ||
       self.canDecimals){
        
        proRating = x * 2 - floorf(x);
        if(proRating >= ceilf(x)){
            
            proRating = ceilf(x);
        }
        [self checkRatingValue:proRating];
        
        
        if(self.isHalfStar){
            
            if(proRating - floorf(x) > 0.5){
                
                proRating = ceilf(x);
            }
            else {
                
                proRating = floorf(x) + 0.5;
            }
        }
    }
    else {
        proRating = ceilf(x);
        [self checkRatingValue:proRating];
    }
    
    self.starRating = proRating;
}

- (void)checkRatingValue:(CGFloat)value{
    
    
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(!self.isRevealModel){
        
         [self getStarRatingForTouch:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(!self.isRevealModel &&
       self.canDragSelect){
        
        [self getStarRatingForTouch:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(!self.isRevealModel &&
       self.qbStarTouchedHandle){
        
        self.qbStarTouchedHandle(self.starRating);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(!self.isRevealModel &&
       self.qbStarTouchedHandle){
        
        self.qbStarTouchedHandle(self.starRating);
    }
}

@end
