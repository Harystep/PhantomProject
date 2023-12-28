//
//  ABAddressPickerView.m
//  QuickBase
//
//  Created by Abner on 2019/5/23.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ABAddressPickerView.h"

typedef NS_ENUM(NSInteger, PICKER_GRADE) {
    
    PICKER_GRADE_PROVENCE = 1,
    PICKER_GRADE_CITY,
    PICKER_GRADE_ZONE,
};

const static NSString *kAddrSelectedProvence = @"kAddrSelectedProvence";
const static NSString *kAddrSelectedZone = @"kAddrSelectedZone";
const static NSString *kAddrSelectedCity = @"kAddrSelectedCity";

const static NSString *kDicSelectedIndex = @"kDicSelectedIndex";
const static NSString *kDicValue = @"kDicValue";

@interface ABAddressPickerView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) PICKER_GRADE pickerGrade;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *provenceSourceDataArray;
@property (nonatomic, strong) NSDictionary *addressSourceDataDic;
@property (nonatomic, strong) NSMutableDictionary *addrSelectedDtatDic;

@property (nonatomic, strong, readwrite) NSDictionary *addressValueDic;

@property (nonatomic, strong) UIButton *provenceButton;
@property (nonatomic, strong) UIButton *zoneButton;
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation ABAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.addrSelectedDtatDic = @{
                                     kAddrSelectedProvence:@{
                                             kDicSelectedIndex:@(-1),
                                             kDicValue:@""}.mutableCopy,
                                     kAddrSelectedZone:@{
                                             kDicSelectedIndex:@(-1),
                                             kDicValue:@""}.mutableCopy,
                                     kAddrSelectedCity:@{
                                             kDicSelectedIndex:@(-1),
                                             kDicValue:@""}.mutableCopy,
                                     }.mutableCopy;
        
        [self addSubview:self.provenceButton];
        [self addSubview:self.zoneButton];
        [self addSubview:self.cityButton];
        
        [self.provenceButton setTitle:@"请选择" forState:UIControlStateNormal];
        [self.provenceButton.titleLabel sizeToFit];
        self.provenceButton.frame = CGRectMake(15.f, 0.f, self.provenceButton.titleLabel.bounds.size.width, CGRectGetHeight(self.provenceButton.frame));
        
        self.cityButton.hidden = YES;
        self.zoneButton.hidden = YES;
        self.provenceButton.selected = YES;
        
        [self initialVarToGrade:PICKER_GRADE_PROVENCE];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.provenceButton.frame) + 5.f, CGRectGetWidth(self.frame), 0.5f)];
        lineView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self addSubview:lineView];
        
        self.sliderView.frame = CGRectMake(CGRectGetMinX(self.provenceButton.frame), CGRectGetMaxY(self.provenceButton.frame) + 5.f - 0.5f, CGRectGetWidth(self.provenceButton.frame), CGRectGetHeight(self.sliderView.frame));
        [self addSubview:self.sliderView];
        
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(lineView.frame));
        [self addSubview:self.tableView];
        
        [self.tableView registerClass:[ABAddressPickerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ABAddressPickerTableViewCell class])];
    }
    
    return self;
}

- (NSDictionary *)addressValueDic{
    
    _addressValueDic = @{
                         kAddrPickerProvence:[NSString stringSafeChecking:self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue]],
                         kAddrPickerZone:[NSString stringSafeChecking:self.addrSelectedDtatDic[kAddrSelectedZone][kDicValue]],
                         kAddrPickerCity:[NSString stringSafeChecking:self.addrSelectedDtatDic[kAddrSelectedCity][kDicValue]],
                         }.copy;
    
    return _addressValueDic;
}

#pragma mark -

- (void)checkAndShowNextButton{
    
    NSString *provenceString = self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue];
    NSString *zoneString = self.addrSelectedDtatDic[kAddrSelectedZone][kDicValue];
    NSString *cityString = self.addrSelectedDtatDic[kAddrSelectedCity][kDicValue];
    
    switch (self.pickerGrade) {
        case PICKER_GRADE_ZONE:
            
            [self buttonTitleChangedFrom:zoneString forButton:self.zoneButton byButton:self.cityButton];
            [self silderViewFrameChangedFrom:self.zoneButton];
            break;
            
        case PICKER_GRADE_CITY:
            
            [self buttonTitleChangedFrom:cityString forButton:self.cityButton byButton:self.provenceButton];
            
            [self initialVarToGrade:PICKER_GRADE_ZONE];
            [self setButtonIsVisableToGrade:PICKER_GRADE_ZONE];
            break;
            
        case PICKER_GRADE_PROVENCE:
            
            [self buttonTitleChangedFrom:provenceString forButton:self.provenceButton byButton:nil];
            
            [self initialVarToGrade:PICKER_GRADE_CITY];
            [self setButtonIsVisableToGrade:PICKER_GRADE_CITY];
            break;
            
        default:
            break;
    }
}

- (void)setButtonIsVisableToGrade:(PICKER_GRADE)pickerGrade{
    
    NSString *provenceString = self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue];
    NSString *zoneString = self.addrSelectedDtatDic[kAddrSelectedZone][kDicValue];
    NSString *cityString = self.addrSelectedDtatDic[kAddrSelectedCity][kDicValue];
    
    DLOG(@"setButtonIsVisableToGrade:%@<>%@<>%@", provenceString, cityString, zoneString);
    
    if(PICKER_GRADE_PROVENCE == pickerGrade){
        
        self.cityButton.hidden = [NSString isNotEmptyAndValid:cityString] ? NO : YES;
        self.zoneButton.hidden = [NSString isNotEmptyAndValid:zoneString] ? NO : YES;
        
        self.provenceButton.selected = YES;
        self.zoneButton.selected = NO;
        self.cityButton.selected = NO;
        
        CGFloat diffValue = [self buttonTitleChangedFrom:provenceString forButton:self.provenceButton byButton:nil];
        if(diffValue != 0.f){
            
            [self linkageChageButtonFrameFrom:PICKER_GRADE_PROVENCE];
        }
        
        [self silderViewFrameChangedFrom:self.provenceButton];
    }
    else if(PICKER_GRADE_CITY == pickerGrade){
        
        self.cityButton.hidden = NO;
        self.zoneButton.hidden = [NSString isNotEmptyAndValid:zoneString] ? NO : YES;
        
        self.provenceButton.selected = NO;
        self.zoneButton.selected = NO;
        self.cityButton.selected = YES;
        
        CGFloat diffValue = [self buttonTitleChangedFrom:cityString forButton:self.cityButton byButton:self.provenceButton];
        if(diffValue != 0.f){
            
            [self linkageChageButtonFrameFrom:PICKER_GRADE_CITY];
        }
        
        [self silderViewFrameChangedFrom:self.cityButton];
    }
    else if(PICKER_GRADE_ZONE == pickerGrade){
        
        self.cityButton.hidden = NO;
        self.zoneButton.hidden = NO;
        
        self.provenceButton.selected = NO;
        self.zoneButton.selected = YES;
        self.cityButton.selected = NO;
        
        CGFloat diffValue = [self buttonTitleChangedFrom:zoneString forButton:self.zoneButton byButton:self.cityButton];
        if(diffValue != 0.f){
            
            [self linkageChageButtonFrameFrom:PICKER_GRADE_ZONE];
        }
        
        [self silderViewFrameChangedFrom:self.zoneButton];
    }
}

- (void)initialVarToGrade:(PICKER_GRADE)pickerGrade{
    
    self.pickerGrade = pickerGrade;
}

- (void)linkageChageButtonFrameFrom:(PICKER_GRADE)pickerGrade{
    
    if(PICKER_GRADE_PROVENCE == pickerGrade){
        
        self.cityButton.frame = ({
            
            CGRect rect = self.cityButton.frame;
            rect.origin.x = CGRectGetMaxX(self.provenceButton.frame) + 8.f;
            rect;
        });
        
        self.zoneButton.frame = ({
            
            CGRect rect = self.zoneButton.frame;
            rect.origin.x = CGRectGetMaxX(self.cityButton.frame) + 8.f;
            rect;
        });
    }
    else if(PICKER_GRADE_CITY == pickerGrade){
        
        self.zoneButton.frame = ({
            
            CGRect rect = self.zoneButton.frame;
            rect.origin.x = CGRectGetMaxX(self.cityButton.frame) + 8.f;
            rect;
        });
    }
}

- (CGFloat)buttonTitleChangedFrom:(NSString *)titleString forButton:(UIButton *)forBtn byButton:(UIButton *)byBtn{
    
    titleString = [NSString isNotEmptyAndValid:titleString] ? titleString : @"请选择";
    
    CGFloat diffValue = 0.f;
    
    [forBtn setTitle:titleString forState:UIControlStateNormal];
    [forBtn.titleLabel sizeToFit];
    forBtn.frame = ({
        
        CGRect rect = forBtn.frame;
        diffValue = rect.size.width - forBtn.titleLabel.bounds.size.width;
        
        if(byBtn){
            
            rect.origin.x = CGRectGetMaxX(byBtn.frame) + 8.f;
        }
        
        rect.size.width = forBtn.titleLabel.bounds.size.width;
        rect;
    });
    
    return diffValue;
}

- (void)silderViewFrameChangedFrom:(UIButton *)button{
    
    CGRect rect = self.sliderView.frame;
    rect.origin.x = CGRectGetMinX(button.frame);
    rect.size.width = CGRectGetWidth(button.frame);
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.sliderView.frame = rect;
    }];
}

#pragma mark - Data

- (void)setAddressDicWithIndexPathRow:(NSInteger)row{
    
    NSArray *cellsDataArray = [self getCellsDataArray];
    
    if(row >= cellsDataArray.count) return;
    
    NSString *valueString = cellsDataArray[row];
    BOOL shouldHidePickerView = NO;
    
    switch (self.pickerGrade) {
        case PICKER_GRADE_PROVENCE:{
            
            NSString *lastValue = self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue];
            if(![lastValue isEqualToString:valueString]){
                
                for (NSString *key in self.addrSelectedDtatDic.allKeys) {
                    
                    if(![kAddrSelectedProvence isEqualToString:key]){
                        
                        self.addrSelectedDtatDic[key][kDicValue] = @"";
                        self.addrSelectedDtatDic[key][kDicSelectedIndex] = @(-1);
                    }
                }
            }
            
            self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue] = valueString;
            self.addrSelectedDtatDic[kAddrSelectedProvence][kDicSelectedIndex] = @(row);
            break;
        }
        case PICKER_GRADE_CITY:{
            
            NSString *lastValue = self.addrSelectedDtatDic[kAddrSelectedCity][kDicValue];
            if(![lastValue isEqualToString:valueString]){
                
                for (NSString *key in self.addrSelectedDtatDic.allKeys) {
                    
                    if(![kAddrSelectedProvence isEqualToString:key] &&
                       ![kAddrSelectedCity isEqualToString:key]){
                        
                        self.addrSelectedDtatDic[key][kDicValue] = @"";
                        self.addrSelectedDtatDic[key][kDicSelectedIndex] = @(-1);
                    }
                }
            }
            
            self.addrSelectedDtatDic[kAddrSelectedCity][kDicValue] = valueString;
            self.addrSelectedDtatDic[kAddrSelectedCity][kDicSelectedIndex] = @(row);
            break;
        }
        case PICKER_GRADE_ZONE:{
            
            shouldHidePickerView = YES;
            self.addrSelectedDtatDic[kAddrSelectedZone][kDicValue] = valueString;
            self.addrSelectedDtatDic[kAddrSelectedZone][kDicSelectedIndex] = @(row);
            break;
        }
        default:
            break;
    }
    
    [self checkAndShowNextButton];
    
    if(self.addressValueDidChangedHandle){
        
        self.addressValueDidChangedHandle();
    }
    
    if(shouldHidePickerView &&
       self.addressPickerShouldHideHandle){
        
        self.addressPickerShouldHideHandle();
    }
}

- (NSArray *)getCellsDataArray{
    
    NSMutableArray *cellsDataArray = nil;
    
    switch (self.pickerGrade) {
        case PICKER_GRADE_PROVENCE:{
            
            cellsDataArray = self.provenceSourceDataArray.mutableCopy;
            
            break;
        }
        case PICKER_GRADE_CITY:{
            
            NSString *key = self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue];
            
            cellsDataArray = [self.addressSourceDataDic[key][0] allKeys].mutableCopy;
            
            break;
        }
        case PICKER_GRADE_ZONE:{
            
            NSString *key = self.addrSelectedDtatDic[kAddrSelectedProvence][kDicValue];
            NSString *subKey = self.addrSelectedDtatDic[kAddrSelectedCity][kDicValue];
            
            cellsDataArray = [[self.addressSourceDataDic[key][0] valueForKey:subKey] mutableCopy];
            
            break;
        }
        default:
            break;
    }
    
    [cellsDataArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isEqualToString:@"其他"]){
            
            [cellsDataArray removeObjectAtIndex:idx];
            [cellsDataArray addObject:obj];
            *stop = YES;
        }
    }];
    
    return cellsDataArray;
}

- (NSInteger)getCellSelectedIndex{
    
    NSInteger selectedIndex;
    
    switch (self.pickerGrade) {
        case PICKER_GRADE_PROVENCE:{
            
            selectedIndex = [self.addrSelectedDtatDic[kAddrSelectedProvence][kDicSelectedIndex] integerValue];
            break;
        }
        case PICKER_GRADE_CITY:{
            
            selectedIndex = [self.addrSelectedDtatDic[kAddrSelectedCity][kDicSelectedIndex] integerValue];
            break;
        }
        case PICKER_GRADE_ZONE:{
            selectedIndex = [self.addrSelectedDtatDic[kAddrSelectedZone][kDicSelectedIndex] integerValue];
            break;
        }
        default:
            break;
    }
    
    return selectedIndex;
}

#pragma mark - Selector

- (void)addressButtonAction:(UIButton *)button{
    
    switch (button.tag) {
        case 1:{
            [self initialVarToGrade:PICKER_GRADE_PROVENCE];
            [self setButtonIsVisableToGrade:PICKER_GRADE_PROVENCE];
            
            break;
        }
        case 2:{
            [self initialVarToGrade:PICKER_GRADE_CITY];
            [self setButtonIsVisableToGrade:PICKER_GRADE_CITY];
            
            break;
        }
        case 3 :{
            [self initialVarToGrade:PICKER_GRADE_ZONE];
            [self setButtonIsVisableToGrade:PICKER_GRADE_ZONE];
            
            break;
        }
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    NSInteger cellRow = [self getCellSelectedIndex];
    if(cellRow >= 0){
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellRow inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *cellsDataArray = [self getCellsDataArray];
    
    return cellsDataArray ? cellsDataArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *cellsDataArray = [self getCellsDataArray];
    
    ABAddressPickerTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ABAddressPickerTableViewCell class]) forIndexPath:indexPath];
    
    tableCell.textLabel.text = cellsDataArray[indexPath.row];
    tableCell.isSelected = ([self getCellSelectedIndex] == indexPath.row) ? YES : NO;
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setAddressDicWithIndexPathRow:indexPath.row];
    
    [tableView reloadData];
}

#pragma mark - Getter

- (UITableView *)tableView{
    
    if(!_tableView){
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        if([HelpTools iPhoneNotchScreen]){
            
            _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _tableView;
}

- (NSDictionary *)addressSourceDataDic{
    
    if(!_addressSourceDataDic){
        
        NSString *addressPath = [[NSBundle bundleForClass:[ABAddressPickerView class]] pathForResource:@"ABAddress" ofType:@"plist"];

        _addressSourceDataDic = [[NSDictionary alloc] initWithContentsOfFile:addressPath];;
    }
    
    return _addressSourceDataDic;
}

- (NSArray *)provenceSourceDataArray{
    
    if(!_provenceSourceDataArray){
        
        NSString *provencePath = [[NSBundle bundleForClass:[ABAddressPickerView class]] pathForResource:@"ABProvence" ofType:@"plist"];
        _provenceSourceDataArray = [[NSArray alloc] initWithContentsOfFile:provencePath];
    }
    
    return _provenceSourceDataArray;
}

- (UIButton *)provenceButton{
    
    if(!_provenceButton){
        
        _provenceButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 24.f)];
        [_provenceButton setTitleColor:[UIColor eshopColor] forState:UIControlStateSelected];
        [_provenceButton setTitleColor:[UIColor blackColor333333] forState:UIControlStateNormal];
        [_provenceButton.titleLabel setFont:[UIFont font14]];
        _provenceButton.tag = 1;
        
        [_provenceButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _provenceButton;
}

- (UIButton *)cityButton{
    
    if(!_cityButton){
        
        _cityButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 24.f)];
        [_cityButton setTitleColor:[UIColor eshopColor] forState:UIControlStateSelected];
        [_cityButton setTitleColor:[UIColor blackColor333333] forState:UIControlStateNormal];
        [_cityButton.titleLabel setFont:[UIFont font14]];
        _cityButton.tag = 2;
        
        [_cityButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cityButton;
}

- (UIButton *)zoneButton{
    
    if(!_zoneButton){
        
        _zoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 24.f)];
        [_zoneButton setTitleColor:[UIColor eshopColor] forState:UIControlStateSelected];
        [_zoneButton setTitleColor:[UIColor blackColor333333] forState:UIControlStateNormal];
        [_zoneButton.titleLabel setFont:[UIFont font14]];
        _zoneButton.tag = 3;
        
        [_zoneButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _zoneButton;
}

- (UIView *)sliderView{
    
    if(!_sliderView){
        
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 1.f)];
        _sliderView.backgroundColor = [UIColor eshopColor];
    }
    
    return _sliderView;
}

@end


/**
 * ABAddressPickerTableViewCell
 */

@interface ABAddressPickerTableViewCell ()

@property (nonatomic, strong)  UIImageView *iconIamgeView;

@end

@implementation ABAddressPickerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.iconIamgeView];
        
        self.textLabel.font = [UIFont font14];
        self.textLabel.textColor = [UIColor blackColor333333];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    
    if(self.isSelected){
        
        self.textLabel.textColor = [UIColor eshopColor];
    }
    else {
        self.textLabel.textColor = [UIColor blackColor333333];
    }
    
    self.iconIamgeView.hidden = !self.isSelected;
    self.iconIamgeView.origin = CGPointMake(CGRectGetMaxX(self.textLabel.frame) + 10.f, 0);
    self.iconIamgeView.centerY = self.textLabel.centerY = CGRectGetHeight(self.frame) / 2.f;
}

#pragma mark - Getter

- (UIImageView *)iconIamgeView{
    
    if(!_iconIamgeView){
        
        _iconIamgeView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"universal_icon_duihao")];
    }
    
    return _iconIamgeView;
}

@end
