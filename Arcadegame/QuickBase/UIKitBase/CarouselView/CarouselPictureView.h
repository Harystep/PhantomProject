//
//  CarouselPictureView.h
//  
//
//  Created by Abner on 14-7-1.
//

#import <UIKit/UIKit.h>
@protocol CarouselPictureDelegate;

#if __has_feature(objc_arc)
#define CP_AUTORELEASE(expression) expression
#define CP_RELEASE(expression)
#define CP_RETAIN(expression)
#define CP_BLOCK_WEAK __weak
#define CP_STRONG strong
#define CP_WEAK assign
#else
#define CP_AUTORELEASE(expression) [expression autorelease]
#define CP_RELEASE(expression) [expression release]
#define CP_RETAIN(expression) [expression retain]
#define CP_BLOCK_WEAK __block
#define CP_STRONG retain
#define CP_WEAK assign
#endif

//pageControl样式
typedef enum{
    PAGECONTROL_STYLE_NONE = 0,     //无样式(默认)
    PAGECONTROL_STYLE_NOD,          //点(系统的小白点)
    PAGECONTROL_STYLE_NUMBER,       //下标(当前页/总页数)
    PAGECONTROL_STYLE_SLIDER,       //滚动条(边角为圆形,需要设置外观,用setScrollBarBackGround:sliderBack:方法)
    PAGECONTROL_STYLE_SLIDER_QUA,    //滚动条(边角为方形)
    PAGECONTROL_STYLE_SEPARATED_NOD,    //进度 图片上下分离 用点显示进度
}CarouselPageControlStyle;

//pageControl位置(scrollBar一直居中显示,设置该属性没用)
typedef enum{
    PAGECONTROL_LOCATION_BOTTOM_CENTER, //底部居中(默认)
    PAGECONTROL_LOCATION_BOTTOM_LEFT,   //底部左靠齐
    PAGECONTROL_LOCATION_BOTTOM_RIGHT,  //底部右靠齐
    PAGECONTROL_LOCATION_TOP_CENTER,    //顶部居中
    PAGECONTROL_LOCATION_TOP_LEFT,      //顶部左靠齐
    PAGECONTROL_LOCATION_TOP_RIGHT      //顶部右靠齐
}CarouselPageControlLocation;

//轮播模式
typedef enum{
    CAROUSELVIEW_STYLE_SCAN = 0,        //点击大图预览
    CAROUSELVIEW_STYLE_DEFAULT,         //普通模式(默认)
    CAROUSELVIEW_STYLE_ZOMMING,         //单张图片可缩放
    CAROUSELVIEW_STYLE_SCAN_AND_ZOMMING //大图预览并单张图片可缩放
}CarouselViewStyle;

//单击图片Block回调,也可以用delegate(返回该图片对象及位置)
typedef void(^shortTapPictureBlock)(id unitObject, NSInteger index);
//长按图片Block回调,也可以用delegate(返回该图片对象及位置)
typedef void(^longPressPictureBlock)(id unitObject, NSInteger index);
//图片预览时可能需要实时获取当前图片的序号,也可以用delegate(返回该图片对象及位置)
typedef void(^CurrentPictureIndexBlock)(id unitObject, NSInteger index);

@interface CarouselPictureView : UIView

//回调代理
@property(nonatomic, weak) id<CarouselPictureDelegate> delegate;
//pageControl样式
@property(nonatomic, CP_WEAK) CarouselPageControlStyle pageControlStyle;
//pageControl位置
@property(nonatomic, CP_WEAK) CarouselPageControlLocation pageControlLocation;
//轮播模式
@property(nonatomic, CP_WEAK) CarouselViewStyle carouselViewStyle;
//首次加载默认显示第几张图片,默认值为1(即第一张,下张依次递增)
@property(nonatomic, CP_WEAK) NSInteger currentPicIndex;
//是否要自动轮播
@property(nonatomic, CP_WEAK) BOOL isAutoCarousel;
//默认图片
@property(nonatomic, CP_STRONG) UIImage *defaultImage;
//自动轮播时间(默认时间为4秒)
@property(nonatomic, CP_WEAK) NSTimeInterval autoCarouselTime;
//scrollBar从第一张到最后一张的动画,如不需要设置为NO,默认为YES
@property(nonatomic, CP_WEAK) BOOL isCoherentAnimation;
//scrollBar距离屏幕左边的距离,默认20px(scrollBar一直居中显示)
@property(nonatomic, CP_WEAK) CGFloat scrollBarOriginX;
//视pageControl的位置,底部时,为距离下沿的距离;顶部时,为距离上沿的距离,默认为6px
@property(nonatomic, CP_WEAK) CGFloat scrollBarEdgeOff;
//scrollBar高度,默认为5px
@property(nonatomic, CP_WEAK) CGFloat scrollBarHeight;
//下标数字大小(默认15号系统字体)
@property(nonatomic, CP_STRONG) UIFont *subscriptTextFont;
//小标数字颜色(默认为黑色)
@property(nonatomic, CP_STRONG) UIColor *subscriptTextColor;
//pageControl样式为滚动条的时候,是否需要滚动条自动隐藏,如不需要设置为NO,默认为YES
@property(nonatomic, CP_WEAK) BOOL isScrollBarAutoAppear;
//UIPageControl的选中颜色
@property(nonatomic, CP_STRONG) UIColor *currentPageIndicatorTintColor;
//UIPageControl的未选中颜色
@property(nonatomic, CP_STRONG) UIColor *pageIndicatorTintColor;

// 临时修复BUG
@property (nonatomic, assign) BOOL ignoreCache;
@property (nonatomic, strong) NSString *cacheKey;

/*
 * PS:dataArray内容:NSString(连接,本地图片名),NSURL,UIImage,CustomObject(自定义类型暂不支持)
 */
/*
 * PS:可直接用系统的initWithFrame实例化
 */
//图片单击以及长按效果初始化(dataArray没有时置空)
- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray
           shortTap:(shortTapPictureBlock)shortTap
          longPress:(longPressPictureBlock)longPress;

//图片单击效果初始化
- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray
           shortTap:(shortTapPictureBlock)shortTap;

//图片长按效果初始化
- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray
          longPress:(longPressPictureBlock)longPress;

//没有点击事件初始化
- (id)initWithFrame:(CGRect)frame
       picturesData:(NSArray *)dataArray;

//图片预览时可能需要实时获取当前图片的序号(返回该图片对象及位置)
- (void)getCurrentPictureIndex:(CurrentPictureIndexBlock)indexBlock;

//刷新界面
- (void)reloadView;
//设置数据,自动刷新无需调用刷新方法(刷新数据也调这个方法)
- (void)setPictureData:(NSArray *)dataArray;
//如果选用滚动条,调用这个方法(值可为imageName,UIImage,UIColor)
- (void)setScrollBarBackGround:(id)backGround sliderBack:(id)sliderBack;
//如果自动轮播,Controller消失的时候停止轮播与再启动方法
- (void) stopAutoCarousel;
- (void) startAutoCarousel;

@end


@protocol CarouselPictureDelegate <NSObject>

@optional
//图片预览时可能需要实时获取当前图片的序号(返回该图片对象及位置)
- (void)getCurrentPictureIndex:(id)unitObject index:(NSInteger)index;
//单击图片回调(返回该图片对象及位置)
- (void)shortTapPicture:(id)unitObject index:(NSInteger)index;
//长按图片回调(返回该图片对象及位置)
- (void)longPressPicture:(id)unitObject index:(NSInteger)index;
/*
 *  自定义样式
 *  如果需要自定义就实现这个方法,不需要时切勿使用该方法;如果要刷新请继续实现相应的方法
 *  可以通过这个方法自定义scrollBar、带有图片介绍的View等add在carouselPicture上
 *  unitObject:当前图片链接或该图片的对象; index:当前图片的位置(即第几张图片)
 */
//加载在整个CarouselView上面,此时将会没有pageControl(注意内存管理)
- (UIView *)carouselPictureOverLayerView:(id)unitObject index:(NSInteger)index;
//加载在单个PictureView上面(这个方法自动刷新View上的数据,不用再调用reload方法,注意内存管理)
- (UIView *)carouselPictureForSingleOverLayerView:(id)unitObject index:(NSInteger)index;
//轮播时刷新自定义View上的数据
- (void)reloadCarouselPictureOverLayerViewData:(id)unitObject index:(NSInteger)index;
//加载在整个CarouselView上面,有pageControl,无需调用reload方法,注意自行调整pageControl与该View的位置,使用时类似于TableViewCell(注意内存管理)
- (UIView *)carouselPictureOverLayerView:(UIView *)overLayerView pictureObject:(id)unitObject index:(NSInteger)index;

@end

