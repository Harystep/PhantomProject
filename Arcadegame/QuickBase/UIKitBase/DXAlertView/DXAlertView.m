//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define AL_RGB_COLOR_ALPHA(a, b, c, d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define kAlertWidth 245.0f
#define kAlertHeight 160.0f

@interface DXAlertView ()
{
    BOOL _leftLeave;
    BOOL _isAlwaysShow;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation DXAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 20.0f
#define kTitleHeight 25.0f

#define kContentOffset 15.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        title = title?title:@"";
        content = content?content:@"";
        
        UIViewController *topVC = [self appRootViewController];
        CGRect contentRect = topVC.view.bounds;
        contentRect.size.width -= kContentOffset*2;
        
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        
        UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
        CGFloat titleWidth = contentRect.size.width - kContentOffset*2;
        CGFloat titleHeight = [self calculationTextHeightWithText:title withTextFont:titleFont withSuperWidth:titleWidth];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentOffset, kTitleYOffset, titleWidth, titleHeight)];
        self.alertTitleLabel.font = titleFont;
        self.alertTitleLabel.numberOfLines = 0;
        self.alertTitleLabel.textColor = AL_RGB_COLOR_ALPHA(45, 48, 51, 1);
        [self addSubview:self.alertTitleLabel];
        
        UIFont *contentFont = [UIFont systemFontOfSize:16.0f];
        CGFloat contentWidth = contentRect.size.width - kContentOffset*2;
        CGFloat contentHeight = [self calculationTextHeightWithText:content withTextFont:contentFont withSuperWidth:contentWidth];
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentOffset, CGRectGetMaxY(self.alertTitleLabel.frame) + kContentOffset, contentWidth, contentHeight)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.lineBreakMode = self.alertTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.alertContentLabel.textColor = AL_RGB_COLOR_ALPHA(144, 148, 153, 1);
        self.alertContentLabel.font = contentFont;
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 44.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake(kContentOffset, CGRectGetMaxY(self.alertContentLabel.frame) + kContentOffset + 5, contentRect.size.width - kContentOffset*2, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            CGFloat buttonWidth = (contentRect.size.width - kContentOffset*2 - 10)/2;
            leftBtnFrame = CGRectMake(kContentOffset, CGRectGetMaxY(self.alertContentLabel.frame) + kContentOffset + 5, buttonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + 10, CGRectGetMinY(leftBtnFrame), buttonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        //UIImage *rightnNrmalImage = [UIImage imageNamed:@"alertView_confirm_btn_normal.png"];
        //UIImage *rightHighImage = [UIImage imageNamed:@"alertView_confirm_btn_high.png"];
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor exeColor]] forState:UIControlStateNormal];
        //[self.rightBtn setBackgroundImage:[rightnNrmalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, rightnNrmalImage.size.width/2, 0, rightnNrmalImage.size.width/2)] forState:UIControlStateNormal];
        //[self.rightBtn setBackgroundImage:[rightHighImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, rightHighImage.size.width/2, 0, rightHighImage.size.width/2)] forState:UIControlStateHighlighted];
        //[self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redButtonColor]] forState:UIControlStateHighlighted];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.leftBtn setTitleColor:[UIColor exeColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 4.0;
        self.leftBtn.clipsToBounds = self.rightBtn.clipsToBounds = YES;
        
        self.leftBtn.layer.borderWidth = 1.0f;
        self.leftBtn.layer.borderColor = [[UIColor exeColor] CGColor];
        
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        //[self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        contentRect.size.height = CGRectGetMaxY(self.rightBtn.frame) + kContentOffset;
        self.frame = contentRect;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (CGFloat)calculationTextHeightWithText:(NSString *)text
                            withTextFont:(UIFont *)textFont
                          withSuperWidth:(CGFloat)superWidth{
    
    CGSize textSize = [text sizeWithFont:textFont constrainedToSize:CGSizeMake(superWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    return textSize.height;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    
    if(!_isAlwaysShow){
        [self dismissAlert];
    }
    
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)showAlways{
    _isAlwaysShow = YES;
    [self showAlertView];
}

- (void)show{
    _isAlwaysShow = NO;
    [self showAlertView];
}

- (void)showAlertView{
    UIViewController *topVC = [self appRootViewController];
    //CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    //self.frame = afterFrame;//CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    self.center = CGPointMake(topVC.view.bounds.size.width/2, topVC.view.bounds.size.height/2);
    //[topVC.view addSubview:self];
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:self];
}

- (void)bringToVisible{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    [window bringSubviewToFront:self.backImageView];
    [window bringSubviewToFront:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    //UIViewController *topVC = [self appRootViewController];
    //CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0f;
        self.backImageView.alpha = 0.0f;
        /*
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
         */
    } completion:^(BOOL finished) {
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    //UIViewController *topVC = [self appRootViewController];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:window.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.0f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3f;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            //[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            //[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f/*, @0.5f, @0.75f*/, @0.4f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]/*,[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]*/];
    
    [self.layer addAnimation:popAnimation forKey:@"show"];
    
    [window addSubview:self.backImageView];
    //[topVC.view addSubview:self.backImageView];
    //self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    //CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
        self.backImageView.alpha = 0.4f;
    }];
    
    /*
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        //self.transform = CGAffineTransformMakeRotation(0);
        //self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    */
    
    [super willMoveToSuperview:newSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return image;
}

@end
