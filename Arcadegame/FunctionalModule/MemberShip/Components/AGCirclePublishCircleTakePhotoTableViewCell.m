//
//  AGCirclePublishCircleTakePhotoTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCirclePublishCircleTakePhotoTableViewCell.h"

static const NSInteger kImageBaseTag = 1000;

@interface AGCirclePublishCircleTakePhotoTableViewCell ()

@property (strong, nonatomic) UIView *mContainerView;
@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation AGCirclePublishCircleTakePhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.contentScrollView];
        [self.contentScrollView addSubview:self.takePhotoButton];
        
        self.takePhotoButton.origin = CGPointMake(14.f, 0.f);
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height);
    self.contentScrollView.frame = CGRectMake(0.f, 10.f, self.mContainerView.width, self.mContainerView.height - 10.f * 2);
}

- (void)setImagePaths:(NSMutableArray<NSString *> *)imagePaths{
    
    if(_imagePaths && _imagePaths.count){
        
        [_imagePaths addObjectsFromArray:imagePaths];
    }
    else {
        
        _imagePaths = imagePaths;
    }
    
    DLOG(@"setImagePaths:imagePaths:%@<>_imagePathsL%@", imagePaths, _imagePaths);
    
    for (UIView *subView in self.contentScrollView.subviews) {
        if(subView.tag >=  kImageBaseTag){
            [subView removeFromSuperview];
        }
    }
    
    CGFloat originX = 12.f;
    for (int i = 0; i < self.imagePaths.count; ++i) {
        NSString *imagePath = self.imagePaths[i];
        CarouselImageView *imageView = [self.contentScrollView viewWithTag:kImageBaseTag + i];
        if(!imageView){
            imageView = [CarouselImageView new];
            imageView.size = self.takePhotoButton.size;
            imageView.tag = kImageBaseTag + i;
            imageView.clipsToBounds = NO;
            imageView.ignoreCache = YES;
            imageView.userInteractionEnabled = YES;
            [self.contentScrollView addSubview:imageView];
            
            UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(imageView.width - 18.f, 0.f, 32.f, 32.f)];
            [closeButton setImage:IMAGE_NAMED(@"x") forState:UIControlStateNormal];
            [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            closeButton.tag = imageView.tag;
            [imageView addSubview:closeButton];
        }
        
        [imageView setImageWithObject:imagePath withPlaceholderImage:nil interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        
        imageView.left = originX;
        imageView.top = self.takePhotoButton.top;
        
        originX = imageView.right + 12.f;
    }
    
    self.takePhotoButton.left = originX;
    
    self.contentScrollView.contentSize = CGSizeMake(self.takePhotoButton.right + 12.f, self.contentScrollView.height);
}

#pragma mark - Selector
- (void)takePhotoButtonAction:(UIButton *)button{
    
    if(self.imagePaths && self.imagePaths.count >= kMaxCountTag){
        
        [HelpTools showHUDOnlyWithText:[NSString stringWithFormat:@"最多上传%@张图片!", @(kMaxCountTag)] toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if(self.didSelectedTakePhotoHandle){
        
        self.didSelectedTakePhotoHandle(self.indexPath);
    }
}

- (void)closeButtonAction:(UIButton *)button{
    
    NSInteger index = button.superview.tag - kImageBaseTag;
    if(index >= 0 &&
       index < self.imagePaths.count){
        
        [self.imagePaths removeObjectAtIndex:index];
        
        __block BOOL shouldMoveLeft = NO;
        [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(obj.tag >= kImageBaseTag){
                
                if(obj.tag == (kImageBaseTag + index)){
                    
                    [obj removeFromSuperview];
                    shouldMoveLeft = YES;
                }
                else if(shouldMoveLeft){
                    obj.left -= (obj.width + 5.f);
                    obj.tag -= 1;
                }
            }
        }];
        
        if(shouldMoveLeft){
            
            if(!self.imagePaths.count){
                
                self.takePhotoButton.left = 16.f;
            }
            else {
                
                self.takePhotoButton.left -= (self.takePhotoButton.width + 5.f);
            }
            
            CGSize contentSize = self.contentScrollView.contentSize;
            contentSize.width -= self.takePhotoButton.width;
            self.contentScrollView.contentSize = contentSize;
        }
    }
}

#pragma mark - Getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (UIButton *)takePhotoButton{
    
    if(!_takePhotoButton){
        
        _takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 110.f)];
        [_takePhotoButton setImage:IMAGE_NAMED(@"circle_publish_takepho_icon") forState:UIControlStateNormal];
        _takePhotoButton.backgroundColor = UIColorFromRGB(0x5E657B);
        _takePhotoButton.layer.cornerRadius = 10.f;
        
        [_takePhotoButton addTarget:self action:@selector(takePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _takePhotoButton;
}

- (UIScrollView *)contentScrollView{
    
    if(!_contentScrollView){
        
        _contentScrollView = [UIScrollView new];
    }
    
    return _contentScrollView;
}

@end
