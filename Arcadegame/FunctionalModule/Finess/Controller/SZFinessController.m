//
//  SZFinessController.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessController.h"
#import "JXCategoryView.h"
#import "SZFinessContentView.h"
#import "SZFinessSmallView.h"

#define kTopHeight (kStatusBarHeight + 5)

@interface SZFinessController ()<JXCategoryViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView        *scrollView;
@property (nonatomic,assign) int pageIndex;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SZFinessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
}

- (void)setupSubviews {
        
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryView.titles];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if(idx == 0) {
            SZFinessContentView *classView = [[SZFinessContentView alloc] init];
            classView.frame = CGRectMake(SCREENWIDTH * idx, 44, SCREENWIDTH, CGRectGetHeight(self.scrollView.frame)-kStatusBarHeight);
            [self.scrollView addSubview:classView];
            if (idx == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kProductCategoryIndex0" object:@{@"id":@"0"}];
            }
        } else {
            SZFinessSmallView *classView = [[SZFinessSmallView alloc] init];
            classView.frame = CGRectMake(SCREENWIDTH * idx, 44, SCREENWIDTH, CGRectGetHeight(self.scrollView.frame)-kStatusBarHeight);
            [self.scrollView addSubview:classView];
            if (idx == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kProductCategoryIndex0" object:@{@"id":@"0"}];
            }
        }
    }];
    self.pageIndex = 0;
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)setupCategoryView {
    if (self.categoryView) {
        [self.categoryView removeFromSuperview];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc]
                         initWithFrame:CGRectMake((SCREENWIDTH - 150)/2.0, kTopHeight, 150, 44)];
    
    self.categoryView.titleColor = UIColor.lightGrayColor;
    self.categoryView.titleSelectedColor = UIColor.whiteColor;
    self.categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
    self.categoryView.titleFont = [UIFont boldSystemFontOfSize:13];
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    NSMutableArray *itemArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i ++) {
        NSDictionary *dic = self.dataArr[i];
        [itemArr addObject:dic[@"name"]];
    }
    self.categoryView.titles = itemArr;
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorColor = [ZCConfigColor whiteColor];
//    lineView.indicatorWidth = AUTO_MARGIN(5);
//    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    
}


- (void)setupScrollView {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * self.categoryView.titles.count, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view insertSubview:self.scrollView belowSubview:self.categoryView];
    self.categoryView.contentScrollView = self.scrollView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.scrollView layoutIfNeeded];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"index:%tu", index);
    
}

- (void)configureSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupCategoryView];
        [self setupScrollView];
        [self setupSubviews];
    });
}


- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@{@"name":@"端游"}];
        [_dataArr addObject:@{@"name":@"小游戏"}];
    }
    return _dataArr;
}

@end
