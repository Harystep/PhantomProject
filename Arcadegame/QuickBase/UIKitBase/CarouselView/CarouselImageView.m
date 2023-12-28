//
//  CarouselImageView.m
//  NetWorkDemo
//
//  Created by Abner on 14-7-22.
//  Copyright (c) 2014年 Abner. All rights reserved.
//

#import "CarouselImageView.h"

#import "SDImageCache.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

@interface CarouselImageView(){
    CarouselInterceptImageModel _carouselInterceptModle;
    CorrectRectBlock _rectBlock;
    
    CGRect _interceptRect;
}

@end

@implementation CarouselImageView

- (void)dealloc{
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _carouselInterceptModle = INTERCEPT_FIXEDWIDTH_TOP;
        _interceptRect = CGRectZero;
        _rectBlock = nil;
        
        self.shouldAnimation = YES;
    }
    return self;
}

- (instancetype)init{
    
    if(self = [super init]){
        
        _carouselInterceptModle = INTERCEPT_FIXEDWIDTH_TOP;
        _interceptRect = CGRectZero;
        _rectBlock = nil;
        
        self.shouldAnimation = YES;
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _carouselInterceptModle = INTERCEPT_FIXEDWIDTH_TOP;
    _interceptRect = CGRectZero;
    _rectBlock = nil;
    
    self.shouldAnimation = YES;
}

#pragma mark - Interface
- (void)setImageWithObject:(id)imageObject
   withPlaceholderImage:(UIImage *)defaultImage
    interceptImageModel:(CarouselInterceptImageModel)carouselInterceptModle
            correctRect:(CorrectRectBlock)rectBlock{
    
    _carouselInterceptModle = carouselInterceptModle;
    _rectBlock = [rectBlock copy];
    
    [self checkImageDataType:imageObject withDefaultImage:defaultImage];
}

- (void)setImageWithObject:(id)imageObject
   withPlaceholderImage:(UIImage *)defaultImage
     interceptImageRect:(CGRect)interceptRect
            correctRect:(CorrectRectBlock)rectBlock{
    
    _interceptRect = interceptRect;
    _rectBlock = [rectBlock copy];
    
    [self checkImageDataType:imageObject withDefaultImage:defaultImage];
}

#pragma mark - SetImage
- (void)setImageWithUrl:(NSString *)urlString defaultImage:(UIImage *)defaultImage{
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // [self sd_cancelCurrentAnimationImagesLoad];
    [self sd_cancelCurrentImageLoad];
    
    if(!self.image){
        
        [self setDefaultIamge:defaultImage result:nil];
    }
    
    CI_BLOCK_WEAK __typeof(self)blockSelf = self;
    CI_BLOCK_WEAK __typeof(_rectBlock)tempRectBlock = _rectBlock;
    
    CGRect viewRect = self.frame;
    CGAffineTransform viewTransform = self.transform;
    
    [SDWebImageManager sharedManager].cacheKeyFilter = [SDWebImageCacheKeyFilter cacheKeyFilterWithBlock:^NSString * _Nullable(NSURL * _Nonnull url) {
         __strong __typeof(blockSelf)strongSelf = blockSelf;
        
        if(strongSelf){
            
            return [NSString stringWithFormat:@"%@_%@", [NSString stringSafeChecking:strongSelf.cacheKey], [url absoluteString]];
        }
        
        return [url absoluteString];
    }];
    
    id<SDWebImageOperation> operation = [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        //[[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        
        if(error){
            DLOG(@"loadImageWithURL:%@\nerror:%@", imageURL, error);
        }
        
        __strong __typeof(blockSelf)strongSelf = blockSelf;
        
        if(!strongSelf) return;
        
        if(image){
            
            if(!strongSelf.ignoreCache &&
               SDImageCacheTypeNone != cacheType){
                
                strongSelf.image = image;
                
                if(tempRectBlock){
                    tempRectBlock(strongSelf.frame.size);
                }
                return;
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                [strongSelf checkImageSize:image forViewRect:viewRect animated:YES viewTransform:viewTransform result:^(CGSize correctSize, UIImage *newImage) {

                    ci_dispatch_main_async_safe((^{
                        
                        if(!strongSelf) return;
                        
                        strongSelf.image = newImage;
                        
                        NSString *cacheKey = [imageURL absoluteString];
                        if([NSString isNotEmptyAndValid:strongSelf.cacheKey]){
                            
                            cacheKey = [NSString stringWithFormat:@"%@_%@", [NSString stringSafeChecking:strongSelf.cacheKey], [imageURL absoluteString]];
                        }
                        
                        if(!strongSelf.ignoreCache){
                            
                            [[SDImageCache sharedImageCache] removeImageForKey:cacheKey withCompletion:nil];
                        }
                        
                        if(strongSelf.shouldAnimation){
                            
                            CATransition *transition = [CATransition animation];
                            transition.type = kCATransitionFade; // there are other types but this is the nicest
                            transition.duration = 0.34; // set the duration that you like
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            //[self.layer addAnimation:transition forKey:nil];
                        }
                        
                        if(!strongSelf.ignoreCache){
                            
                            [[SDImageCache sharedImageCache] storeImage:newImage forKey:cacheKey completion:nil];
                        }
                        [strongSelf setNeedsLayout];
                        
                        if(tempRectBlock){
                            tempRectBlock(correctSize);
                        }
                    }));
                }];
            });
        }
    }];
    
    [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
}

- (void)setDefaultIamge:(UIImage *)image result:(void(^)(void))resultHandle{
    
    self.image = image;
    if(resultHandle){
        
        resultHandle();
    }
    
    return;
    /*
    if(image){
        
        CI_BLOCK_WEAK __typeof(self)blockSelf = self;
        CGAffineTransform viewTransform = self.transform;
        CGRect viewRect = self.frame;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [blockSelf checkImageSize:image forViewRect:viewRect animated:NO viewTransform:viewTransform result:^(CGSize correctSize, UIImage *newImage) {
                
                ci_dispatch_main_async_safe(^{
                    
                    if(blockSelf && newImage){
                        
                        blockSelf.image = newImage;
                    }
                    
                    if(resultHandle)
                        resultHandle();
                    
                });
            }];
        });
    }
    else {
        
        if(resultHandle)
            resultHandle();
    }
     */
}

- (void)setImageWithImage:(UIImage *)image{
    
    if(!image){
        if(_rectBlock){
            
            _rectBlock(CGSizeZero);
        }
        
        return;
    }
    
    __block NSString *cacheKeyString = [NSString stringWithFormat:@"loacalimagecache_%@_%@_%ld", NSStringFromCGSize(image.size), [NSString stringSafeChecking:self.cacheKey], [UIImageJPEGRepresentation(image, 1) length]];
    UIImage *cacheImage = nil;
    //[[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKeyString];
    
    if(!self.ignoreCache && cacheImage){
        
        self.image = cacheImage;
        return;
    }
    
    CI_BLOCK_WEAK __typeof(self)blockSelf = self;
    CI_BLOCK_WEAK __typeof(_rectBlock)tempRectBlock = _rectBlock;
    CGRect viewRect = self.frame;
    CGAffineTransform viewTransform = self.transform;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [blockSelf checkImageSize:image forViewRect:viewRect animated:YES viewTransform:viewTransform result:^(CGSize correctSize, UIImage *newImage) {
            
            ci_dispatch_main_async_safe(^{
                
                if(blockSelf && newImage){
                    if(!self.ignoreCache){
                        
                        [[SDImageCache sharedImageCache] removeImageForKey:cacheKeyString withCompletion:nil];
                    }
                    
                    blockSelf.image = newImage;
                    
                    if(!self.ignoreCache){
                        
                        [[SDImageCache sharedImageCache] storeImage:newImage forKey:cacheKeyString completion:nil];
                    }
                }
                
                if(tempRectBlock){
                    tempRectBlock(correctSize);
                }
            });
        }];
    });
}

#pragma mark Privated
- (void)checkImageDataType:(id)imageObject withDefaultImage:(UIImage *)defaultImage{
    
    //self.image = nil;
   /*
    if(!imageObject){
        
        [self setImageWithImage:defaultImage];
    }
    if([imageObject isKindOfClass:[NSString class]]){
        
        if(![(NSString *)imageObject length]){
            
            [self setImageWithImage:defaultImage];
        }
        if([(NSString *)imageObject rangeOfString:@"://"].location == NSNotFound){
            
            [self setImageWithImage:[UIImage imageNamed:(NSString *)imageObject]];
        }
        else {
            
            [self setImageWithUrl:(NSString *)imageObject defaultImage:defaultImage];
        }
    }
    else if([imageObject isKindOfClass:[NSURL class]]){
        
        [self setImageWithUrl:[(NSURL *)imageObject absoluteString] defaultImage:defaultImage];
    }
    else if([imageObject isKindOfClass:[UIImage class]]){
        
        [self setImageWithImage:(UIImage *)imageObject];
    }
    */
    
    if(!imageObject){
        
        [self setImageWithImage:defaultImage];
    }
    else if([imageObject isKindOfClass:[NSString class]]){
        
        if(![(NSString *)imageObject length]){
            
            if(defaultImage) {
                [self setImageWithImage:defaultImage];
            }
            else {
                self.image = nil;
            }
        }
        else if([(NSString *)imageObject rangeOfString:@"://"].location != NSNotFound){
            
            [self setImageWithUrl:(NSString *)imageObject defaultImage:defaultImage];
        }
        else if([(NSString *)imageObject isAbsolutePath]){
            
            [self setImageWithImage:[UIImage imageWithContentsOfFile:(NSString *)imageObject]];
        }
        else {
            [self setImageWithImage:[UIImage imageNamed:(NSString *)imageObject]];
        }
    }
    else if([imageObject isKindOfClass:[NSURL class]]){
        
        [self setImageWithUrl:[(NSURL *)imageObject absoluteString] defaultImage:defaultImage];
    }
    else if([imageObject isKindOfClass:[UIImage class]]){
        
        [self setImageWithImage:(UIImage *)imageObject];
    }
}

- (void)checkImageSize:(UIImage *)image
           forViewRect:(CGRect)imageViewRect
              animated:(BOOL)animated
         viewTransform:(CGAffineTransform)transform
                result:(void(^)(CGSize correctSize, UIImage *newImage))resultHanddle{
    
    CGSize correctSize = CGSizeZero;
    CGFloat imageWidth = image.size.width * image.scale;
    CGFloat imageHeight = image.size.height * image.scale;
    CGFloat imageViewWidth = imageViewRect.size.width;
    CGFloat imageViewHeight = imageViewRect.size.height;
    
    UIImage *newImage = nil;
    
    if(_carouselInterceptModle == INTERCEPT_FULL_SIZE ||
       _carouselInterceptModle == INTERCEPT_FULLFORIMAGE_SIZE){
        
        newImage = image;
        correctSize = [self showImageFullSize:CGSizeMake(image.size.width * image.scale, image.size.height * image.scale) WithViewSize:imageViewRect.size];
    }
    else {
        if(imageWidth/imageHeight == imageViewWidth/imageViewHeight){
            
            newImage = image;
            correctSize = imageViewRect.size;
        }
        else if(imageWidth/imageHeight < imageViewWidth/imageViewHeight){
            //竖长图
            imageHeight = (imageWidth*imageViewHeight)/imageViewWidth;
            
            CGRect correctRect = [self correctImageForView:image correctWidth:imageWidth correctHeight:imageHeight];
            
            newImage = [self imageFromImage:image inRect:correctRect transform:transform];
            
            correctSize = CGSizeMake(imageViewWidth, imageViewHeight);
        }
        else {
            //横长图
            imageWidth = (imageViewWidth*imageHeight)/imageViewHeight;
            
            CGRect correctRect = [self correctImageForView:image correctWidth:imageWidth correctHeight:imageHeight];
            newImage = [self imageFromImage:image inRect:correctRect transform:transform];
            
            correctSize = CGSizeMake(imageViewWidth, imageViewHeight);
        }
    }
    
    if(resultHanddle){
        
        resultHanddle(correctSize, newImage);
    }
}

- (CGSize)showImageFullSize:(CGSize)imageSize WithViewSize:(CGSize)imageViewSize{
    CGSize correctSize = CGSizeZero;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    CGFloat proportion = imageWidth/imageHeight;
    CGFloat imageViewWidth = imageViewSize.width;
    CGFloat imageViewHeight = imageViewSize.height;
    
    if(_carouselInterceptModle == INTERCEPT_FULL_SIZE){
        imageViewHeight = imageViewWidth/proportion;
        
        correctSize = CGSizeMake(imageViewWidth, imageViewHeight);
    }
    else if(_carouselInterceptModle == INTERCEPT_FULLFORIMAGE_SIZE){
        if(imageHeight > imageViewHeight){
            imageHeight = imageViewHeight;
            imageWidth = imageHeight*proportion;
        }
        
        if(imageWidth > imageViewWidth){
            imageWidth = imageViewWidth;
            imageHeight = imageWidth/proportion;
        }
        
        correctSize = CGSizeMake(imageWidth, imageHeight);
    }
    else {
        
    }
    
    return correctSize;
}

- (CGRect)correctImageForView:(UIImage *)image correctWidth:(CGFloat)imageWidth correctHeight:(CGFloat)imageHeight{
    CGRect correctRect = CGRectZero;
    
    if(CGRectEqualToRect(_interceptRect, CGRectZero)){
        switch (_carouselInterceptModle) {
            case INTERCEPT_FIXEDWIDTH_TOP:{
                correctRect = CGRectMake(0, 0, imageWidth, imageHeight);
                break;
            }
            case INTERCEPT_FIXEDWIDTH_CENTER:{
                correctRect = CGRectMake(0, (image.size.height * image.scale - imageHeight)/2, imageWidth, imageHeight);
                break;
            }
            case INTERCEPT_FIXEDWIDTH_BOTTOM:{
                correctRect = CGRectMake(0, image.size.height * image.scale - imageHeight, imageWidth, imageHeight);
                break;
            }
            case INTERCEPT_FIXEDHEIGHT_LEFT:{
                correctRect = CGRectMake(0, 0, imageWidth, imageHeight);
                break;
            }
            case INTERCEPT_FIXEDHEIGHT_RIGHT:{
                correctRect = CGRectMake(image.size.width * image.scale - imageWidth, 0, imageWidth, imageHeight);
                break;
            }
            case INTERCEPT_FIXEDHEIGHT_CENTER:{
                correctRect = CGRectMake((image.size.width * image.scale - imageWidth)/2, 0, imageWidth, imageHeight);
                break;
            }
            case INTERCEPT_CENTER:{
                correctRect = CGRectMake((image.size.width * image.scale - imageWidth)/2, (image.size.height * image.scale - imageHeight)/2, imageWidth, imageHeight);
                break;
            }
            default:
                break;
        }
    }
    else {
        correctRect = _interceptRect;
    }
    
    return correctRect;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage*)imageFromImage:(UIImage*)image inRect:(CGRect)rect transform:(CGAffineTransform)transform{
    
    CGSize newSize = rect.size;
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, newSize.width / 2, newSize.height / 2);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, newSize.width / -2, newSize.height / -2);
    
    [image drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width * image.scale, image.size.height * image.scale)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    image = nil;
    
    return newImage;
}

@end
