//
//  AGGameHeadView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGGameHeadView : UIView

@property (strong, nonatomic) NSData *data;

@end

/**
 * AGGameHeadButton
 */
@interface AGGameHeadButton: UIButton

@property (strong, nonatomic) NSString *headImageName;
@property (strong, nonatomic) NSString *headvalueString;

@end

/**
 * AGGameHeadFuncView
 */
@interface AGGameHeadFuncView: UIView

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *subTitleString;

@property (copy, nonatomic) void(^didSelecedHandle)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
