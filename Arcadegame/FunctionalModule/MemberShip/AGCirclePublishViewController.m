//
//  AGCirclePublishViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCirclePublishViewController.h"

#import "AGCirclePublishCircleTextInputTableViewCell.h"
#import "AGCirclePublishCircleTakePhotoTableViewCell.h"
#import "AGCirclePublishCircleChekMarkTableViewCell.h"
#import "AGCirclePublishCircleConfirmTableViewCell.h"
#import "AGCirclePublishCircleNameTableViewCell.h"
#import "AGCircleALLCategoryViewController.h"
#import "BLImagePickerViewController.h"

#import "AGServiceHttp.h"
#import "AGCircleHttp.h"

@interface AGCirclePublishViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) AGCirclePublishCircleNameItem *mCPCNItem;
@property (strong, nonatomic) NSMutableArray<AGCirclePublishItem *> *mCPDataSource;

@property (strong, nonatomic) AGCirclePublishHttp *mCPHttp;

@end

@implementation AGCirclePublishViewController {
    
    int _selectedImageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = self.chodData ? [NSString stringSafeChecking:self.chodData.name] : @"幻影游乐圈";
    _selectedImageIndex = 0;
    
    if(self.chodData) {
        self.mCPCNItem = [AGCirclePublishCircleNameItem getCPCNItemWithTitle:self.chodData.name withGroupID:self.chodData.ID];
    }
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[AGCirclePublishCircleTextInputTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCirclePublishCircleTextInputTableViewCell class])];
    [self.mTableView registerClass:[AGCirclePublishCircleTakePhotoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCirclePublishCircleTakePhotoTableViewCell class])];
    [self.mTableView registerClass:[AGCirclePublishCircleChekMarkTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCirclePublishCircleChekMarkTableViewCell class])];
    [self.mTableView registerClass:[AGCirclePublishCircleConfirmTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCirclePublishCircleConfirmTableViewCell class])];
    [self.mTableView registerClass:[AGCirclePublishCircleNameTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCirclePublishCircleNameTableViewCell class])];
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.mCPDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    AGCirclePublishItem *item = self.mCPDataSource[indexPath.row];
    
    switch (item.type) {
        case kAGCirclePublishItemType_Name:
            
            return 46.f;
        case kAGCirclePublishItemType_Blank:
            
            return 12.f;
        case kAGCirclePublishItemType_Text:
            
            return 160.f;
        case kAGCirclePublishItemType_TakePho:
            
            return 110.f + 10.f * 2;
        case kAGCirclePublishItemType_Mark:
            
            return 40.f + 20.f * 2;
        case kAGCirclePublishItemType_Confirm:
            
            return 46.f + 10.f * 2 + 100.f;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGCirclePublishItem *item = self.mCPDataSource[indexPath.row];
    
    if(kAGCirclePublishItemType_Name == item.type){
        
        AGCirclePublishCircleNameTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCirclePublishCircleNameTableViewCell class]) forIndexPath:indexPath];
        
        tableCell.mCPCNItem = self.mCPCNItem;
        
        return tableCell;
    }
    
    if(kAGCirclePublishItemType_Text == item.type){
        
        AGCirclePublishCircleTextInputTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCirclePublishCircleTextInputTableViewCell class]) forIndexPath:indexPath];
        tableCell.palaceholder = [NSString stringSafeChecking:item.defaultValue];
        tableCell.indexPath = indexPath;
        
        return tableCell;
    }
    
    if(kAGCirclePublishItemType_TakePho == item.type){
        
        AGCirclePublishCircleTakePhotoTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCirclePublishCircleTakePhotoTableViewCell class]) forIndexPath:indexPath];
        
        __WeakObject(self);
        tableCell.didSelectedTakePhotoHandle = ^(NSIndexPath * _Nonnull indexPath) {
            __WeakStrongObject();
            [__strongObject gotoTakePhoto];
        };
        
        return tableCell;
    }
    
    if(kAGCirclePublishItemType_Mark == item.type){
        
        AGCirclePublishCircleChekMarkTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCirclePublishCircleChekMarkTableViewCell class]) forIndexPath:indexPath];
        tableCell.palaceholder = [NSString stringSafeChecking:item.defaultValue];
        tableCell.indexPath = indexPath;
        
        return tableCell;
    }
    
    if(kAGCirclePublishItemType_Confirm == item.type){
        
        AGCirclePublishCircleConfirmTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCirclePublishCircleConfirmTableViewCell class]) forIndexPath:indexPath];
        tableCell.indexPath = indexPath;
        
        __WeakObject(self);
        tableCell.didSelectedHandle = ^() {
            __WeakStrongObject();
            
            [__strongObject requestPublishData];
        };
        
        return tableCell;
    }
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableCell.backgroundColor = [UIColor clearColor];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AGCirclePublishItem *item = self.mCPDataSource[indexPath.row];
    
    if(kAGCirclePublishItemType_Name == item.type) {
        
        if(self.chodData) {
            
        }
        else {
            
            [self gotoCircleALLCategoryVC];
        }
    }
}

#pragma mark -
- (NSInteger)getIndexWithType:(AGCirclePublishItemType)type {
    
    __block NSInteger index = -1;
    [self.mCPDataSource enumerateObjectsUsingBlock:^(AGCirclePublishItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(type == obj.type) {
            
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

#pragma mark - GOTO
- (void)gotoCircleALLCategoryVC {
    
    AGCircleALLCategoryViewController *AGCALLCVC = [AGCircleALLCategoryViewController new];
    [self.navigationController pushViewController:AGCALLCVC animated:YES];
    
    __WeakObject(self);
    AGCALLCVC.didSelectedHandle = ^(AGCircleData * _Nonnull circleData) {
        __WeakStrongObject();
        
        __strongObject.mCPCNItem = [AGCirclePublishCircleNameItem getCPCNItemWithTitle:circleData.name withGroupID:circleData.ID];
        __strongObject.titleString = circleData.name;
        
        [__strongObject.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[__strongObject getIndexWithType:kAGCirclePublishItemType_Name] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
}

- (void)gotoTakePhoto {
    
    NSInteger index = [self getIndexWithType:kAGCirclePublishItemType_TakePho];
    if(!index)  return;
    
    __block AGCirclePublishCircleTakePhotoTableViewCell *tableCell = [self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if(!tableCell) return;
    
    BLImagePickerViewController *imgVc = [[BLImagePickerViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imgVc];
    imgVc.navColor = [UIColor whiteColor];
    imgVc.navTitleColor = [UIColor blackColor333333];
    
    imgVc.imageClipping = NO;
    imgVc.showCamera = YES;
    imgVc.maxNum = tableCell.imagePaths ? (kMaxCountTag - tableCell.imagePaths.count) : kMaxCountTag;
    imgVc.maxScale = 2.0;
    imgVc.minScale = 0.5;
    
    __WeakObject(self);
    [imgVc initDataProgress:^(CGFloat progress) {
        
        [HelpTools showLoadingForView:self.view.window];
        
    } finished:^(NSArray<UIImage *> *resultAry, NSArray<PHAsset *> *assetsArry, UIImage *editedImage) {
        __WeakStrongObject();
        
        NSMutableArray *imagePathArray = [NSMutableArray arrayWithCapacity:resultAry.count];
        for (int i = 0; i < resultAry.count; ++i) {
            
            UIImage *image = resultAry[i];
            NSString *cacheFilePath = [[PathTools getDataCacheFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"pics%@.png", @(__strongObject->_selectedImageIndex)]];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            BOOL isOK = [data writeToFile:cacheFilePath atomically:YES];
            if(isOK){
                
                [imagePathArray addObject:cacheFilePath];
            }
            
            __strongObject->_selectedImageIndex += 1;
        }
        
        [HelpTools hideLoadingForcibleWithVIew:self.view.window];
        
        if(imagePathArray.count != resultAry.count){
            
            [HelpTools showHUDOnlyWithText:@"图片选取失败, 请重新选择" toView:__strongObject.view];
        }
        else {
            //__strongObject.selectedImages = imagePathArray;
            
            tableCell.imagePaths = imagePathArray;
        }

    } cancle:^(NSString *cancleStr) {
        
        DLOG(@"取消了");
        [HelpTools hideLoadingForcibleWithVIew:self.view.window];
    }];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestPublishData {
    
    if(!self.mCPCNItem || !self.mCPCNItem.groupID) {
        
        [HelpTools showHUDOnlyWithText:@"请先选择圈子" toView:self.view];
        return;
    }
    
    NSInteger index_mark = [self getIndexWithType:kAGCirclePublishItemType_Mark];
    NSInteger index_text = [self getIndexWithType:kAGCirclePublishItemType_Text];
    NSInteger index_takePho = [self getIndexWithType:kAGCirclePublishItemType_TakePho];
    
    if(!index_mark || !index_text || !index_takePho) return;
    
    AGCirclePublishCircleTakePhotoTableViewCell *tableCell_takePho = [self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index_takePho inSection:0]];
    AGCirclePublishCircleChekMarkTableViewCell *tableCell_mark = [self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index_mark inSection:0]];
    AGCirclePublishCircleTextInputTableViewCell *tableCell_text = [self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index_text inSection:0]];
    
    if(!tableCell_takePho || !tableCell_mark || !tableCell_text) return;
    
    if(![NSString isNotEmptyAndValid:[tableCell_text inputContent]]) {
        
        [HelpTools showHUDOnlyWithText:@"请输入您的内容" toView:self.view];
        return;
    }
    
    [self requestUploadPicsWithPicpaths:tableCell_takePho.imagePaths content:[tableCell_text inputContent] mark:[tableCell_mark inputContent]];
}

- (void)requestUploadPicsWithPicpaths:(NSArray *)picPaths content:(NSString *)content mark:(NSString *)mark{
    
    if(!picPaths || !picPaths.count) {
        
        [self requestCirclePublishWithImages:nil content:content mark:mark];
        return;
    }
    
    __block NSMutableArray *mutablePicPaths = [NSMutableArray arrayWithCapacity:picPaths.count];
    __block NSInteger uploadCount = 0;
    
    for (int i = 0; i < picPaths.count; ++i) {
        
        NSString *picPath = picPaths[i];
        uploadCount += 1;
        
        __block AGServiceUploadImageHttp *suiHttp = [AGServiceUploadImageHttp new];
        [suiHttp setFilePath:picPath];
        
        __WeakObject(self);
        [HelpTools showLoadingForView:self.view];
        
        [suiHttp requestServiceUploadImageResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
                   
            __WeakStrongObject();
            [HelpTools hideLoadingForView:__strongObject.view];
            
            if(isSuccess){
                
                [mutablePicPaths addObject:[NSString stringSafeChecking:suiHttp.mBase.data]];
            }
            else {
                [HelpTools showHttpError:responseObject];
            }
            
            if(uploadCount == picPaths.count) {
                
                if(mutablePicPaths.count == 0) {
                    
                    [HelpTools showHUDOnlyWithText:@"图片上传失败，请稍后重试！" toView:__strongObject.view];
                }
                else {
                    if(mutablePicPaths.count != picPaths.count) {
                        
                        [HelpTools showHUDOnlyWithText:@"部分图片上传失败!" toView:__strongObject.view];
                    }
                    
                    [__strongObject requestCirclePublishWithImages:mutablePicPaths content:content mark:mark];
                }
            }
        }];
    }
}

- (void)requestCirclePublishWithImages:(NSArray *)images content:(NSString *)content mark:(NSString *)mark{
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCPHttp.groupId = self.mCPCNItem.groupID;
    self.mCPHttp.content = [NSString stringSafeChecking:content];
    self.mCPHttp.discuss = [NSString stringSafeChecking:mark];
    
    NSString *imageReStr = @"";
    if(images && images.count) {
        
        for (int i = 0; i < images.count; ++i) {
            
            imageReStr = [imageReStr stringByAppendingFormat:@"%@", images[i]];
            
            if(i != images.count - 1) {
                imageReStr = [imageReStr stringByAppendingString:@";"];
            }
        }
    }
    self.mCPHttp.images = imageReStr;
    
    [self.mCPHttp requestCirclePublishDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
       
        __WeakStrongObject();
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"发布成功" toView:__strongObject.view];
            [__strongObject.navigationController popViewControllerAnimated:YES];
        }
        else {
            [HelpTools showHttpError:responseObject];
        }
    }];
}

#pragma mark - Request Getter
- (AGCirclePublishHttp *)mCPHttp {
    
    if(!_mCPHttp) {
        
        _mCPHttp = [AGCirclePublishHttp new];
    }
    
    return _mCPHttp;
}

#pragma mark - Getter
- (UITableView *)mTableView{
    
    if(!_mTableView){
        
        _mTableView = [[UITableView alloc] initWithFrame:({
            CGRect rect = self.view.bounds;
            rect.origin.x = 0.f;
            rect.size.width = self.view.width - rect.origin.x * 2;
            rect.origin.y = CGRectGetHeight(self.mAGNavigateView.frame);
            rect.size.height -= CGRectGetHeight(self.mAGNavigateView.frame);
            rect.size.height -= ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 12.f);
            
            rect;
        })];
        _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor clearColor];
        //_mTableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
    }
    
    return _mTableView;
}

- (NSMutableArray<AGCirclePublishItem *> *)mCPDataSource {
    
    if(!_mCPDataSource) {
        
        _mCPDataSource = @[
            [AGCirclePublishItem iniWithType:kAGCirclePublishItemType_Name defaultValue:@""],
            [AGCirclePublishItem iniWithType:kAGCirclePublishItemType_Blank defaultValue:@""],
            [AGCirclePublishItem iniWithType:kAGCirclePublishItemType_Text defaultValue:@"这一刻的想法"],
            [AGCirclePublishItem iniWithType:kAGCirclePublishItemType_TakePho defaultValue:@""],
            [AGCirclePublishItem iniWithType:kAGCirclePublishItemType_Mark defaultValue:@"输入话题"],
            [AGCirclePublishItem iniWithType:kAGCirclePublishItemType_Confirm defaultValue:@""]
        ].mutableCopy;
    }
    
    return _mCPDataSource;
}

@end

/**
 * AGCirclePublishItem
 */
@implementation AGCirclePublishItem

+ (instancetype)iniWithType:(AGCirclePublishItemType)type defaultValue:(NSString *)defaultValue {
    
    AGCirclePublishItem *item = [AGCirclePublishItem new];
    item.defaultValue = defaultValue;
    item.type = type;
    
    return item;
}

@end
