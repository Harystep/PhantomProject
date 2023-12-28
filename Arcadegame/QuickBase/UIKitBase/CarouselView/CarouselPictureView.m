//
//  CarouselPictureView.m
//  
//
//  Created by Abner on 14-7-1.
//

#import "CarouselPictureView.h"
#import "CarouselScrollBar.h"
#import "CarouselImageView.h"

#define PAGECONTROL_NOD_WIDTH 13
#define SCROLLBAR_ORIGIN_X 20.0
#define SCROLLBAR_HEIGHT 5.0
#define SCROLLBAR_BOTTOM 6.0
#define TOTAL_PAGE_COUNT [self.picturesArray count]

static NSInteger IMAGEVIEW_BASE_TAG = 101080;
static NSInteger ZOOMSCROLLVIEW_BASE_TAG = 10390;
static NSTimeInterval PIC_CYCLE_TIME = 4.0f;

@interface CarouselPictureView()<UIScrollViewDelegate>{
    NSTimer *_picTiming;
    UILabel *_contentLable;
    UIPageControl *_pageControl;
    CarouselScrollBar *_carouselScrollBar;
    
    NSMutableArray *_curImages; //存放当前滚动的三张图片
    NSMutableArray *_indexArray;
    int _curPageIndex;//当前图片的索引
    BOOL _pageControlBeingUsed;//是否用户拖动图片
    
    shortTapPictureBlock _shortTapBlock;
    longPressPictureBlock _longPressBlock;
    CurrentPictureIndexBlock _currentIndexBlock;
    
    id _scrollBarBackGround;
    id _scrollBarSliderBackGround;
}

@property(nonatomic, CP_STRONG) UIScrollView *pictureScrollView;
@property(nonatomic, CP_STRONG) NSArray *picturesArray;
@property(nonatomic, CP_STRONG) UIView *overlayerView;

@end

@implementation CarouselPictureView
@synthesize delegate = _delegate;
@synthesize defaultImage = _defaultImage;
@synthesize subscriptTextFont = _subscriptTextFont;
@synthesize subscriptTextColor = _subscriptTextColor;
@synthesize carouselViewStyle,isAutoCarousel,autoCarouselTime,scrollBarOriginX,scrollBarEdgeOff,scrollBarHeight;
@synthesize pageControlLocation,currentPicIndex,isCoherentAnimation,isScrollBarAutoAppear;
//-----------------
@synthesize picturesArray = _picturesArray;
@synthesize pictureScrollView = _pictureScrollView;
@synthesize overlayerView = _overlayerView;

- (void)dealloc{
#if !__has_feature(objc_arc)
    [_pictureScrollView release];
    [_picturesArray release];
    [_indexArray release];
    [_curImages release];
    if(_pageControl){
       [_pageControl release];
        _pageControl = nil;
    }
    
    if(_carouselScrollBar){
        [_carouselScrollBar release];
        _carouselScrollBar = nil;
    }
    
    if(_contentLable){
        [_contentLable release];
    }
    
    [super dealloc];
#endif
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray
           shortTap:(shortTapPictureBlock)shortTap
          longPress:(longPressPictureBlock)longPress{
    
    self = [self initWithFrame:frame];
    if(self){
        _shortTapBlock = [shortTap copy];
        _longPressBlock = [longPress copy];
        self.picturesArray = [NSArray arrayWithArray:dataArray];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray
           shortTap:(shortTapPictureBlock)shortTap{
    
    self = [self initWithFrame:frame];
    if(self){
        _shortTapBlock = [shortTap copy];
        _longPressBlock = nil;
        self.picturesArray = [NSArray arrayWithArray:dataArray];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray
          longPress:(longPressPictureBlock)longPress{
    
    self = [self initWithFrame:frame];
    if(self){
        _shortTapBlock = nil;
        _longPressBlock = [longPress copy];
        self.picturesArray = [NSArray arrayWithArray:dataArray];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray{
    
    self = [self initWithFrame:frame];
    if(self){
        _shortTapBlock = nil;
        _longPressBlock = nil;
        self.picturesArray = [NSArray arrayWithArray:dataArray];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.frame = CGRectMake(0, 0, self.frame.size.width, 180);
        self.backgroundColor = [UIColor clearColor];
        
        self.isAutoCarousel = NO;
        self.isCoherentAnimation = YES;
        self.isScrollBarAutoAppear = YES;
        self.currentPicIndex = 1;
        self.scrollBarOriginX = SCROLLBAR_ORIGIN_X;
        self.scrollBarEdgeOff = SCROLLBAR_BOTTOM;
        self.scrollBarHeight = SCROLLBAR_HEIGHT;
        
        self.subscriptTextFont = [UIFont systemFontOfSize:15];
        self.subscriptTextColor = [UIColor blackColor];
        self.pageControlStyle = PAGECONTROL_STYLE_NONE;
        self.pageControlLocation = PAGECONTROL_LOCATION_BOTTOM_CENTER;
        self.carouselViewStyle = CAROUSELVIEW_STYLE_DEFAULT;
        self.autoCarouselTime = PIC_CYCLE_TIME;
        _currentIndexBlock = nil;
        _indexArray = [[NSMutableArray alloc]initWithCapacity:3];
        _curImages = [[NSMutableArray alloc]initWithCapacity:3];
        
        _pictureScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pictureScrollView.backgroundColor = [UIColor clearColor];
        self.pictureScrollView.showsHorizontalScrollIndicator = NO;
        self.pictureScrollView.pagingEnabled = YES;
        self.pictureScrollView.delegate = self;
        [self addSubview:self.pictureScrollView];
    }
    return self;
}

#pragma mark - DrawRect
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // DLOG(@"drawRect:%d", self.pageControlStyle);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    DLOG(@"layoutSubviews:%d", self.pageControlStyle);
    self.pictureScrollView.frame = self.bounds;
}

#pragma mark - SetDataForView && ReloadView
- (void)resetPictureViewWithData:(NSArray *)dataArray {
    
    if(dataArray && [dataArray count]>0){
        [self reloadView];
        
        if((self.currentPicIndex <= 0) || (self.currentPicIndex > TOTAL_PAGE_COUNT)){
            self.currentPicIndex = 1;
        }
        _curPageIndex = (self.currentPicIndex - 1);
        
        [self viewWithData];
    }
}

- (void)setPictureData:(NSArray *)dataArray{
    if(dataArray && [dataArray count]>0){
        self.picturesArray  = [NSArray arrayWithArray:dataArray];
    }
}

- (void)reloadView{
    // [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)setPicturesArray:(NSArray *)picturesArray {
    
    if([self checkShouldResetUIWithObject:picturesArray]) {
        
        _picturesArray = picturesArray;
        [self resetPictureViewWithData:picturesArray];
    }
    else {
        _picturesArray = picturesArray;
    }
    
//    [self resetPictureViewWithData:picturesArray];
}

- (BOOL)checkShouldResetUIWithObject:(NSArray *)object {
    
    if(!object || !self.picturesArray) return YES;
    DLOG(@"*******checkShouldResetUIWithObject:%@<>%@", NSStringFromCGSize(self.pictureScrollView.frame.size), NSStringFromCGSize(self.bounds.size));
    if(!CGRectEqualToRect(self.pictureScrollView.frame, self.bounds)) {
        
        return YES;
    }
    
    DLOG(@"*******checkShouldResetUIWithObject 1");
    
    NSSet *set0 = [NSSet setWithArray:self.picturesArray];
    NSSet *set1 = [NSSet setWithArray:object];
    
    return ![set0 isEqualToSet:set1];
}

#pragma mark - processDataForView
- (void)viewWithData{
    if(self.overlayerView){
        [self.overlayerView removeFromSuperview];
        self.overlayerView = nil;
    }
    
    if(self.picturesArray.count == 0){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:self.defaultImage];
        [self.pictureScrollView addSubview:imageView];
        CP_RELEASE(imageView);
        
        [self setPageControl:1];
    }
    else {
        [self refreshScrollView];
        [self setPageControl:TOTAL_PAGE_COUNT];
        [self startAutoCarousel];
    }
    
    if(_carouselScrollBar && self.isScrollBarAutoAppear){
        [_carouselScrollBar disappearScrollBar:NO];
    }
}

#pragma mark - Privated
-(void)refreshScrollView{
    NSArray *subViewsArray = [self.pictureScrollView subviews];
    if(subViewsArray.count > 0){
        [subViewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithPageindex];
    
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:self.defaultImage];
    [backImageView setFrame:self.bounds];
    [self.pictureScrollView addSubview:backImageView];
    CP_RELEASE(backImageView);
    backImageView = nil;
    
    if(TOTAL_PAGE_COUNT == 1 && !self.isAutoCarousel){
        _pageControlBeingUsed = YES;
    }
    
    for(int i = 0;i < ((TOTAL_PAGE_COUNT == 1)?1:3); ++i){
        int imageIndex = [[_indexArray objectAtIndex:i] intValue];
        
        UIScrollView *zoomScrollView = nil;
        BOOL isZooming = NO;
        if((self.carouselViewStyle == CAROUSELVIEW_STYLE_ZOMMING) ||
           (self.carouselViewStyle == CAROUSELVIEW_STYLE_SCAN_AND_ZOMMING)){
            
            isZooming = YES;
            
            zoomScrollView = [[UIScrollView alloc] initWithFrame:CGRectOffset(CGRectMake(0, 0, self.pictureScrollView.frame.size.width, self.pictureScrollView.frame.size.height), self.pictureScrollView.frame.size.width*i, 0)];
            zoomScrollView.backgroundColor = [UIColor blackColor];
            zoomScrollView.minimumZoomScale = 1.0;
            zoomScrollView.maximumZoomScale = 5.0;
            zoomScrollView.delegate = self;
            zoomScrollView.tag = ZOOMSCROLLVIEW_BASE_TAG + imageIndex;
        }
        
        CarouselImageView *imageView = [[CarouselImageView alloc] init];
        if(isZooming){
            imageView.frame = CGRectMake(0, 0, zoomScrollView.frame.size.width, zoomScrollView.frame.size.height);
        }
        else {
            
            if(PAGECONTROL_STYLE_SEPARATED_NOD == self.pageControlStyle){
                
                imageView.frame = CGRectOffset(CGRectMake(15.f, 10.f, self.pictureScrollView.frame.size.width - 15.f * 2, self.pictureScrollView.frame.size.height - 20.f * 2 - 10.f), self.pictureScrollView.frame.size.width*i, 0);
                imageView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
                imageView.layer.shadowOffset = CGSizeMake(0, 0);
                imageView.layer.shadowOpacity = 0.85;
                imageView.layer.cornerRadius = 10.f;
            }
            else {
                
                imageView.frame = CGRectOffset(CGRectMake(0, 0, self.pictureScrollView.frame.size.width, self.pictureScrollView.frame.size.height), self.pictureScrollView.frame.size.width*i, 0);
            }
        }
        imageView.alpha = 1.0f;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = IMAGEVIEW_BASE_TAG + imageIndex;
        [imageView setBackgroundColor:[UIColor clearColor]];
        imageView.ignoreCache = self.ignoreCache;
        imageView.cacheKey = self.cacheKey;
        
        //[imageView setImageWithObject:[_curImages objectAtIndex:i] withPlaceholderImage:self.defaultImage interceptImageModel:INTERCEPT_FIXEDWIDTH_BOTTOM correctRect:nil];
        CarouselInterceptImageModel interceptModel = INTERCEPT_CENTER;
        if((self.carouselViewStyle == CAROUSELVIEW_STYLE_SCAN) ||
           (self.carouselViewStyle == CAROUSELVIEW_STYLE_SCAN_AND_ZOMMING)){
            // 大图预览模式
            interceptModel = INTERCEPT_FULLFORIMAGE_SIZE;
            imageView.shouldAnimation = NO;
        }
        
        CP_BLOCK_WEAK __typeof(imageView)__blockImageView = imageView;
        [imageView setImageWithObject:[_curImages objectAtIndex:i] withPlaceholderImage:self.defaultImage interceptImageModel:interceptModel correctRect:^(CGSize size) {

            if(isZooming){
                [__blockImageView setFrame:CGRectMake((zoomScrollView.frame.size.width-size.width)/2, __blockImageView.frame.origin.y, size.width, size.height)];
            }
            else {
//                [__blockImageView setFrame:CGRectOffset(CGRectMake((self.pictureScrollView.frame.size.width-size.width)/2, __blockImageView.frame.origin.y, size.width, size.height),  self.pictureScrollView.frame.size.width*i, 0)];
            }

            if((self.carouselViewStyle == CAROUSELVIEW_STYLE_SCAN) ||
               (self.carouselViewStyle == CAROUSELVIEW_STYLE_SCAN_AND_ZOMMING)){

                __blockImageView.center = CGPointMake(__blockImageView.center.x, self.pictureScrollView.center.y);
            }
        }];
        
        [self addSingleOverLayerView:imageView];
        
        if(isZooming){
            [zoomScrollView addSubview:imageView];
            [self.pictureScrollView addSubview:zoomScrollView];
        }
        else {
            [self.pictureScrollView addSubview:imageView];
        }
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shortTapAction:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGestureRecognizer.minimumPressDuration = 0.3f;
        [imageView addGestureRecognizer:longPressGestureRecognizer];
        
        CP_RELEASE(tapGestureRecognizer);
        CP_RELEASE(longPressGestureRecognizer);
        CP_RELEASE(imageView);
        imageView = nil;
        if(zoomScrollView){
            CP_RELEASE(zoomScrollView);
        }
        
        [self.pictureScrollView setContentOffset:CGPointMake((TOTAL_PAGE_COUNT == 1)?0:(self.pictureScrollView.frame.size.width), 0)];
    }
    
    [self.pictureScrollView setContentSize:CGSizeMake(self.pictureScrollView.bounds.size.width * ((TOTAL_PAGE_COUNT == 1)?1:3), self.pictureScrollView.bounds.size.height)];
}

//更新curImages数组
-(NSArray*)getDisplayImagesWithPageindex{
    int pre = [self validPageValue:_curPageIndex - 1];
    int nex = [self validPageValue:_curPageIndex + 1];
    
    if(_curImages.count > 0){
        [_curImages removeAllObjects];
    }
    
    /*
     curImages始终保证三张图片，curPageIndex表示当前显示的那一张，pre表示前一张，nex表示后一张
     如此可以实现轮回播中放最后一张跟第一张图片之间无缝切换
     */
    [_curImages addObject:[self.picturesArray objectAtIndex:pre]];
    [_curImages addObject:([self.picturesArray objectAtIndex:_curPageIndex])];
    [_curImages addObject:([self.picturesArray objectAtIndex:nex])];
    
    if(_indexArray.count>0){
        [_indexArray removeAllObjects];
    }
    [_indexArray addObject:[NSNumber numberWithInt:pre]];
    [_indexArray addObject:[NSNumber numberWithInt:_curPageIndex]];
    [_indexArray addObject:[NSNumber numberWithInt:nex]];
    
    return _curImages;
}

//控制当前数字不超过imagesArray的界限
-(int)validPageValue:(NSInteger)value{
    if(value == -1){
        value = TOTAL_PAGE_COUNT-1;
    }
    if(value == TOTAL_PAGE_COUNT){
        value = 0;
    }
    
    return value;
}

- (void)addSingleOverLayerView:(UIView *)imageView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(carouselPictureForSingleOverLayerView:index:)]){
        UIView *overLayerView = [self.delegate carouselPictureForSingleOverLayerView:[self.picturesArray objectAtIndex:_curPageIndex] index:_curPageIndex];
        
        if(overLayerView){
            UIView *memOverLayerView = [imageView viewWithTag:overLayerView.tag];
            if(!memOverLayerView){
                
                [imageView addSubview:overLayerView];
            }
        }
    }
}

#pragma mark - SetPageControl
- (void)setPageControl:(NSInteger)numberOfPages{
    id unitObject = nil;
    if([self.picturesArray count] > 0){
        unitObject = [self.picturesArray objectAtIndex:_curPageIndex];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(carouselPictureOverLayerView:index:)]){
        UIView *overLayerView = [self.delegate carouselPictureOverLayerView:unitObject index:_curPageIndex];
        if(overLayerView){
            self.overlayerView = nil;
            [self addSubview:overLayerView];
            [self bringSubviewToFront:_carouselScrollBar];
        }
        
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(carouselPictureOverLayerView:pictureObject:index:)]){
        UIView *overLayerView = [self.delegate carouselPictureOverLayerView:nil pictureObject:unitObject index:_curPageIndex];
        if(overLayerView){
            self.overlayerView = overLayerView;
            [self addSubview:self.overlayerView];
            [self bringSubviewToFront:_carouselScrollBar];
        }
    }
    
    switch (self.pageControlStyle) {
        case PAGECONTROL_STYLE_SEPARATED_NOD:
        case PAGECONTROL_STYLE_NOD :{
            if(!_pageControl){
                _pageControl = [[UIPageControl alloc] init];
                _pageControl.backgroundColor = [UIColor clearColor];
                [self addSubview:_pageControl];
                
                if(self.currentPageIndicatorTintColor){
                    
                    _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
                }
                
                if(self.pageIndicatorTintColor){
                    
                    _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
                }
            }
            CGSize pageControlSize = [_pageControl sizeForNumberOfPages:numberOfPages];
            _pageControl.frame = CGRectMake(0, 0, pageControlSize.width, PAGECONTROL_NOD_WIDTH);
            _pageControl.numberOfPages = numberOfPages;
            _pageControl.currentPage = _curPageIndex;
            if(numberOfPages > 1){
                [_pageControl addTarget:self action:@selector(changePageNum:) forControlEvents:UIControlEventValueChanged];
            }
            
            [self setLocationOfPageControl:_pageControl];
            break;
        }
        case PAGECONTROL_STYLE_SLIDER:{
            if(!_carouselScrollBar){
                _carouselScrollBar = [[CarouselScrollBar alloc] initWithSize:CGSizeMake(self.pictureScrollView.frame.size.width-2*self.scrollBarOriginX, self.scrollBarHeight)
                                                               scrollBarType:SCROLLBAR_CIRCLECORNER_TYPE
                                                             andCurrentIndex:_curPageIndex];
                
                [self addSubview:_carouselScrollBar];
            }
            [self setSlideViewWithNums:numberOfPages];
            
            break;
        }
        case PAGECONTROL_STYLE_SLIDER_QUA:{
            if(!_carouselScrollBar){
                _carouselScrollBar = [[CarouselScrollBar alloc] initWithSize:CGSizeMake(self.pictureScrollView.frame.size.width-2*self.scrollBarOriginX, self.scrollBarHeight)
                                                               scrollBarType:SCROLLBAR_SQUARE_TYPE
                                                             andCurrentIndex:_curPageIndex];
                
                [self addSubview:_carouselScrollBar];
            }
            [self setSlideViewWithNums:numberOfPages];
            
            break;
        }
        case PAGECONTROL_STYLE_NUMBER:{
            if(!_contentLable){
                
                NSString *contentString = [NSString stringWithFormat:@"%ld/%ld", TOTAL_PAGE_COUNT * 10, TOTAL_PAGE_COUNT * 10];
                
                CGFloat width = [HelpTools sizeForString:contentString withFont:self.subscriptTextFont viewWidth:self.pictureScrollView.frame.size.width].width;
                _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.subscriptTextFont.lineHeight)];
                _contentLable.textAlignment = NSTextAlignmentCenter;
                _contentLable.backgroundColor = [UIColor clearColor];
                [self addSubview:_contentLable];
            }
            _contentLable.text = [NSString stringWithFormat:@"%d/%ld", (_curPageIndex+1), numberOfPages];
            _contentLable.font = self.subscriptTextFont;
            _contentLable.textColor = self.subscriptTextColor;
            
            [self setLocationOfPageControl:_contentLable];
            break;
        }
        default:
            break;
    }
}

- (void)setSlideViewWithNums:(NSInteger)numberOfPages{
    _carouselScrollBar.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-self.scrollBarEdgeOff-self.scrollBarHeight/2));
    [_carouselScrollBar setBackGround:_scrollBarBackGround sliderBack:_scrollBarSliderBackGround];
    _carouselScrollBar.scrollContentCount = numberOfPages;
    if(!self.isCoherentAnimation){
        _carouselScrollBar.isCoherentAnimation = self.isCoherentAnimation;
    }
}

- (void)setScrollBarBackGround:(id)backGround sliderBack:(id)sliderBack{
    _scrollBarBackGround = backGround;
    _scrollBarSliderBackGround = sliderBack;
}

- (void)setLocationOfPageControl:(UIView *)pageCtl{
    if((self.pageControlStyle == PAGECONTROL_STYLE_SLIDER) || (self.pageControlStyle == PAGECONTROL_STYLE_NONE)){
        return;
    }
    
    switch (self.pageControlLocation) {
        case PAGECONTROL_LOCATION_BOTTOM_CENTER:{
            pageCtl.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-self.scrollBarEdgeOff-pageCtl.frame.size.height/2));
            
            break;
        }
        case PAGECONTROL_LOCATION_BOTTOM_LEFT:{
            pageCtl.center = CGPointMake(self.scrollBarEdgeOff+pageCtl.frame.size.width/2, (self.frame.size.height-self.scrollBarEdgeOff-pageCtl.frame.size.height/2));
            
            break;
        }
        case PAGECONTROL_LOCATION_BOTTOM_RIGHT:{
            pageCtl.center = CGPointMake(self.frame.size.width-self.scrollBarEdgeOff-pageCtl.frame.size.width/2, (self.frame.size.height-self.scrollBarEdgeOff-pageCtl.frame.size.height/2));
            
            break;
        }
        case PAGECONTROL_LOCATION_TOP_CENTER:{
            pageCtl.center = CGPointMake(self.frame.size.width/2, (self.scrollBarEdgeOff+pageCtl.frame.size.height/2));
            
            break;
        }
        case PAGECONTROL_LOCATION_TOP_LEFT:{
            pageCtl.center = CGPointMake(self.scrollBarEdgeOff+pageCtl.frame.size.width/2, (self.scrollBarEdgeOff+pageCtl.frame.size.height/2));
            
            break;
        }
        case PAGECONTROL_LOCATION_TOP_RIGHT:{
            pageCtl.center = CGPointMake(self.frame.size.width-self.scrollBarEdgeOff-pageCtl.frame.size.width/2, (self.scrollBarEdgeOff+pageCtl.frame.size.height/2));
            
            break;
        }
        default:
            break;
    }
}

#pragma mark Selector
- (void)changePageNum:(UIPageControl *)pageCtl{
    if(TOTAL_PAGE_COUNT == 1) return;
    
    [self.pictureScrollView setContentOffset:CGPointMake(self.pictureScrollView.frame.size.width*pageCtl.currentPage, 0)];
}

- (void)reloadOverLayerViewData:(NSInteger)index{
    if(_pageControl){
        _pageControl.currentPage = index;
    }
    
    if((index >=0) && (index < self.picturesArray.count)){
        if(self.overlayerView && self.delegate && [self.delegate respondsToSelector:@selector(carouselPictureOverLayerView:pictureObject:index:)]){
            [self.delegate carouselPictureOverLayerView:self.overlayerView pictureObject:[self.picturesArray objectAtIndex:_curPageIndex] index:index];
        }
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(reloadCarouselPictureOverLayerViewData:index:)]){
            [self.delegate reloadCarouselPictureOverLayerViewData:[self.picturesArray objectAtIndex:_curPageIndex] index:index];
        }
    }
}

#pragma mark - GestureRecognizerAction
- (void)shortTapAction:(UITapGestureRecognizer *)gestureRecognizer{
    NSInteger pictureIndex = gestureRecognizer.view.tag - IMAGEVIEW_BASE_TAG;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(shortTapPicture:index:)]){
        [self.delegate shortTapPicture:[self.picturesArray objectAtIndex:pictureIndex] index:pictureIndex];
    }
    
    if(_shortTapBlock){
        _shortTapBlock([self.picturesArray objectAtIndex:pictureIndex], pictureIndex);
    }
}

- (void)longPressAction:(UIGestureRecognizer *)gestureRecognizer{
    NSInteger pictureIndex = gestureRecognizer.view.tag - IMAGEVIEW_BASE_TAG;
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if(self.delegate && [self.delegate respondsToSelector:@selector(longPressPicture:index:)]){
            [self.delegate longPressPicture:[self.picturesArray objectAtIndex:pictureIndex] index:pictureIndex];
        }
        
        if(_longPressBlock){
            _longPressBlock([self.picturesArray objectAtIndex:pictureIndex], pictureIndex);
        }
    }
}

#pragma mark - AutoCarousel
- (void)stopAutoCarousel{
    if(_picTiming){
        [_picTiming invalidate];
        _picTiming = nil;
    }
}

- (void)startAutoCarousel{
    /*change by zlq picturesArray count为零时调用本方法会崩溃 ＝1时没有必要滚动
     由(self.picturesArray.count != 1) 改成(self.picturesArray.count > 1
     */
    if((self.picturesArray.count > 1) && self.isAutoCarousel){
        if(!_picTiming){
            _picTiming = [NSTimer scheduledTimerWithTimeInterval:self.autoCarouselTime target:self selector:@selector(autoCarouselAction:) userInfo:nil repeats:YES];
        }
    }
}

- (void)autoCarouselAction:(NSTimer *)timer{
    [self.pictureScrollView setContentOffset:CGPointMake(self.pictureScrollView.frame.size.width*2, 0) animated:YES];
}

#pragma mark - RealTime CurrentIndex
- (void)getCurrentPictureIndex:(CurrentPictureIndexBlock)indexBlock{
    if(indexBlock){
        _currentIndexBlock = [indexBlock copy];
    }
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView != self.pictureScrollView){
        return;
    }
    
    if(!_pageControlBeingUsed){
        float x = scrollView.contentOffset.x;
        
        if(_carouselScrollBar){
            [_carouselScrollBar reloadScrollBarLocation:x scrollWidth:scrollView.frame.size.width currentIndex:_curPageIndex];
        }
        
        if(_contentLable){
            _contentLable.text = [NSString stringWithFormat:@"%d/%d",(_curPageIndex+1),TOTAL_PAGE_COUNT];
        }
        
        //向左拖拽的时候，x是从320开始递增的，拖到下一张的时候刚好是640
        if(x >= 2*scrollView.frame.size.width){
            _curPageIndex = [self validPageValue:_curPageIndex+1];//显示下一张
            [self refreshScrollView];
            [self reloadOverLayerViewData:_curPageIndex];
        }
        
        //向右拖拽的时候，x是从320开始递减的，拖到前一张的时候刚好是0
        //因为scrollView具有回弹效果，所以拖拽一半时，scrollView还是会滚动到底的
        if(x <= 0){
            _curPageIndex = [self validPageValue:_curPageIndex - 1];//显示下一张
            [self refreshScrollView];
            [self reloadOverLayerViewData:_curPageIndex];
        }
        
        //实时更新CurrentIndex
        if(self.delegate && [self.delegate respondsToSelector:@selector(getCurrentPictureIndex:index:)]){
            if((_curPageIndex >= 0) && (_curPageIndex < [self.picturesArray count])){
                [self.delegate longPressPicture:[self.picturesArray objectAtIndex:_curPageIndex] index:_curPageIndex];
            }
            else {
                NSLog(@"CarouselPictureView currentIndex error");
            }
        }
        
        if(_currentIndexBlock){
            if((_curPageIndex >= 0) && (_curPageIndex < [self.picturesArray count])){
                _currentIndexBlock([self.picturesArray objectAtIndex:_curPageIndex], _curPageIndex);
            }
            else {
                NSLog(@"CarouselPictureView currentIndex error");
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if((TOTAL_PAGE_COUNT == 1) || (scrollView != self.pictureScrollView)){
        return;
    }
    
    _pageControlBeingUsed = NO;
    [self stopAutoCarousel];
    
    if(self.isScrollBarAutoAppear && _carouselScrollBar){
        [_carouselScrollBar appearScrollBar:YES];
    }
}

//停止拖拽时候执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if((TOTAL_PAGE_COUNT == 1) || (scrollView != self.pictureScrollView)){
        return;
    }
    
    [self startAutoCarousel];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if((TOTAL_PAGE_COUNT == 1) || (scrollView != self.pictureScrollView)){
        return;
    }
    _pageControlBeingUsed = NO;
}

//图片缩放相关
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(scrollView != self.pictureScrollView){
        return [scrollView viewWithTag:(IMAGEVIEW_BASE_TAG + (scrollView.tag - ZOOMSCROLLVIEW_BASE_TAG))];
    }
    
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(scrollView != self.pictureScrollView){
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
        
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:(IMAGEVIEW_BASE_TAG + (scrollView.tag - ZOOMSCROLLVIEW_BASE_TAG))];
        imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    }
}

@end
