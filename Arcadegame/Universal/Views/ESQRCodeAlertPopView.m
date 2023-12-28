//
//  ESQRCodeAlertPopView.m
//  EShopClient
//
//  Created by Abner on 2019/7/24.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESQRCodeAlertPopView.h"

@interface ESQRCodeAlertPopView ()

@property (nonatomic, strong) UIImageView *QRImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ESQRCodeAlertPopView

- (instancetype)initWithQRContnet:(NSString *)content{
    
    if(self = [super initConfirmButton:nil cancelButton:nil isShowCloseButton:YES]){
        
        self.height = self.width;
        [self addSubview:self.contentLabel];
        [self addSubview:self.QRImageView];
        
        self.contentLabel.origin = CGPointMake(0.f, self.height - self.contentLabel.height - 21.f);
        
        CGFloat imageHeight = self.contentLabel.top - 26.f * 2 - self.closeButton.bottom;
        self.QRImageView.origin = CGPointMake(0.f, 26.f + self.closeButton.bottom);
        self.QRImageView.size = CGSizeMake(imageHeight, imageHeight);
        self.QRImageView.image = IMAGE_NAMED(@"qrcodeIamge");
        
        self.contentLabel.centerX = self.QRImageView.centerX = self.width / 2.f;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
        [self addGestureRecognizer:longGesture];
    }
    
    return self;
}

- (void)longGestureAction:(UILongPressGestureRecognizer *)gesture{
    [self hide];
    
    if(self.longPressHandle){
        
        self.longPressHandle(self.QRImageView.image);
    }
}

#pragma mark - Getter

- (UIImageView *)QRImageView{
    
    if(!_QRImageView){
        
        _QRImageView = [UIImageView new];
    }
    
    return _QRImageView;
}

- (UILabel *)contentLabel{
    
    if(!_contentLabel){
        
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont font14];
        _contentLabel.textColor = [UIColor blackColor333333];
        _contentLabel.text = @"长按识别下载商家版APP\n可以下载保存图片";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    
    return _contentLabel;
}

@end
