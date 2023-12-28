//
//  QBTableStyleCollectionLayout.m
//  QuickBase
//
//  Created by Abner on 2019/12/3.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBTableStyleCollectionLayout.h"

@interface QBTableStyleCollectionLayout ()

@property (nonatomic, strong) NSMutableArray *itemOfSizeDicArray;
@property (nonatomic, strong) NSMutableArray *itemAttributesArray;
@property (nonatomic, strong) NSMutableArray *sectionHeightArray;

@property (nonatomic, assign) CGFloat collectionSizeHeight;
@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation QBTableStyleCollectionLayout

- (instancetype)init{
    
    if(self = [super init]){
        
        [self initialData];
    }
    
    return self;
}

- (void)initialData{
    
    self.itemCount = 0;
    self.collectionSizeHeight = 0.f;
    self.contentInset = UIEdgeInsetsZero;
    self.columnSpacing = 0.f;
}

- (void)resetData{
    
    [self.itemAttributesArray removeAllObjects];
    [self.itemOfSizeDicArray removeAllObjects];
    [self.sectionHeightArray removeAllObjects];
    
    self.collectionSizeHeight = 0;
    self.itemCount = 0;
}

#pragma mark -

- (void)prepareLayout{
    [super prepareLayout];
    
    [self resetData];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (int i = 0; i < sectionCount; i++) {
        
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:i];
        self.itemCount += rowCount;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        NSInteger sectionLineCount = 0;
        CGSize itemSize = CGSizeZero;
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(sizeForCellOfCollectionView:forIndexPath:)]){
            
            itemSize = [self.delegate sizeForCellOfCollectionView:self.collectionView forIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            
            if(itemSize.width != 0){
                
                 sectionLineCount = CGRectGetWidth(self.collectionView.frame) / itemSize.width;
            }
        }
        
        CGFloat lineSpacingForSection = 0.f;
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(lineSpacingForSectionOfCollectionView:inSection:)]){
            
            lineSpacingForSection = [self.delegate lineSpacingForSectionOfCollectionView:self.collectionView inSection:i];
        }
        
        for (int k = 0; k < sectionLineCount; k++) {
            
            [dict setObject:@(self.contentInset.top + lineSpacingForSection) forKey:[NSString stringWithFormat:@"%ld",(long)k]];
        }
        [self.itemOfSizeDicArray addObject:dict];
        
//        DLOG(@"prepareLayout:%@<>%@<>%@", @(rowCount), @(i), @(sectionLineCount));
        for (NSInteger j = 0; j < rowCount; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [self.itemAttributesArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
        
        NSMutableDictionary *mdict = self.itemOfSizeDicArray[i];
        
        __block NSString *maxHeightline = @"0";
        [mdict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
            if ([mdict[maxHeightline] floatValue] < [obj floatValue] ) {
                maxHeightline = key;
            }
        }];
        
        [self.sectionHeightArray addObject:mdict[maxHeightline]];
        self.collectionSizeHeight += [mdict[maxHeightline] floatValue];
        
        //DLOG(@"prepareLayout<>contentSizeHeight:%@<>%@", @(self.collectionSizeHeight), @([mdict[maxHeightline] floatValue]));
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize itemSize = CGSizeZero;
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(sizeForCellOfCollectionView:forIndexPath:)]){
        
        itemSize = [self.delegate sizeForCellOfCollectionView:self.collectionView forIndexPath:indexPath];
    }
    
    CGRect itemFrame;
    itemFrame.size = itemSize;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.itemOfSizeDicArray objectAtIndex:indexPath.section]];
    
    __block NSString *lineMinHeight = @"0";
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([dict[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    
    int line = [lineMinHeight intValue];
    
    CGFloat lineSpacingForCell = 0.f;
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(lineSpacingForCellOfCollectionView:forIndexPath:)]){
        
        lineSpacingForCell = [self.delegate lineSpacingForCellOfCollectionView:self.collectionView forIndexPath:indexPath];
    }
    
    CGFloat columnSpacingForCell = 0.f;
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(columnSpacingForCellOfCollectionView:forIndexPath:)]){
        
        columnSpacingForCell = [self.delegate columnSpacingForCellOfCollectionView:self.collectionView forIndexPath:indexPath];
    }
    
    itemFrame.origin = CGPointMake(line * (itemSize.width + columnSpacingForCell) + columnSpacingForCell, [dict[lineMinHeight] floatValue] + self.collectionSizeHeight);
    
    dict[lineMinHeight] = @(itemFrame.size.height + lineSpacingForCell + [dict[lineMinHeight] floatValue]);
    
    [self.itemOfSizeDicArray replaceObjectAtIndex:indexPath.section withObject:dict];
    attr.frame = itemFrame;
    
//    DLOG(@"layoutAttributesForItemAtIndexPath:<%@>%@", @(line), NSStringFromCGPoint(itemFrame.origin));
    //DLOG(@"layoutAttributesForItemAtIndexPath:%@<%@>", NSStringFromCGRect(itemFrame), indexPath);
    
    return attr;
}

- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.collectionSizeHeight);
}

#pragma mark -

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    DLOG(@"layoutAttributesForElementsInRect:%@", self.itemAttributesArray);
    return self.itemAttributesArray;
}

#pragma mark - Getter

- (NSMutableArray *)itemOfSizeDicArray{
    
    if(!_itemOfSizeDicArray){
        
        _itemOfSizeDicArray = [NSMutableArray new];
    }
    
    return _itemOfSizeDicArray;
}

- (NSMutableArray *)itemAttributesArray{
    
    if(!_itemAttributesArray){
        
        _itemAttributesArray = [NSMutableArray new];
    }
    
    return _itemAttributesArray;
}

- (NSMutableArray *)sectionHeightArray{
    
    if(!_sectionHeightArray){
        
        _sectionHeightArray = [NSMutableArray new];
    }
    
    return _sectionHeightArray;
}

@end
