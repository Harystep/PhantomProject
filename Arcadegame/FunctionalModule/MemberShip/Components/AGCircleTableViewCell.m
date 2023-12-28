//
//  AGCircleTableViewCell.m
//  Arcadegame
//
//  Created by rrj on 2023/6/7.
//

#import "AGCircleTableViewCell.h"
#import "UIColor+THColor.h"
#import "Masonry.h"
#import <math.h>
#import "UIImageView+WebCache.h"

static CGFloat picHeightArray[4];

@interface AGCircleTableViewCell ()

@property (strong, nonatomic) UIView *mainContainer;
@property (strong, nonatomic) CarouselImageView *avatar;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UIImageView *level;
@property (strong, nonatomic) UILabel *postTime;
@property (strong, nonatomic) UILabel *viewCount;
@property (strong, nonatomic) UILabel *mainContent;
@property (strong, nonatomic) UIView *pictureContainer;
@property (strong, nonatomic) NSMutableArray<CarouselImageView *> *pictureCache;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIView *tagContainer;
@property (strong, nonatomic) UILabel *tagText;
@property (strong, nonatomic) UIView *tagView;

@end

@implementation AGCircleTableViewCell

+ (void)initialize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageResizeRatio = (screenWidth - 40)/334;
    picHeightArray[0] = 0;
    picHeightArray[1] = ceil(164 * imageResizeRatio);
    picHeightArray[2] = ceil(164 * imageResizeRatio);
    picHeightArray[3] = ceil(219 * imageResizeRatio);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mainContainer  = [[UIView alloc] init];
        mainContainer.backgroundColor = [UIColor getColor:@"262e42"];
        mainContainer.layer.cornerRadius = 20;
        
        CarouselImageView *avatar = [[CarouselImageView alloc] init];
        avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        avatar.layer.borderWidth = 2;
        avatar.layer.cornerRadius = 26;
        avatar.layer.masksToBounds = YES;
        avatar.userInteractionEnabled = YES;
        avatar.ignoreCache = YES;
        _avatar = avatar;
        
        UIView *briefView = [[UIView alloc] init];
        
        UILabel *userName = [[UILabel alloc] init];
        userName.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        userName.textColor = [UIColor whiteColor];
        //userName.text = @"娃娃机";
        _userName = userName;
        
        UIImageView *level = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_level_1"]];
        self.level = level;
        
        UILabel *postTime = [[UILabel alloc] init];
        postTime.font = [UIFont systemFontOfSize:14];
        postTime.textColor = [UIColor getColor:@"b5b7c1"];
        //postTime.text = @"5分钟前";
        _postTime = postTime;
        
        UILabel *viewCount = [[UILabel alloc] init];
        viewCount.font = [UIFont systemFontOfSize:14];
        viewCount.textColor = [UIColor getColor:@"b5b7c1"];
        //viewCount.text = @"152浏览";
        _viewCount = viewCount;
        
        UIButton *moreButton = [[UIButton alloc] init];
        moreButton.size = CGSizeMake(32.f, 32.f);
        //[moreButton setImage:IMAGE_NAMED(@"ag_list_dot_func_icon") forState:UIControlStateNormal];
        [moreButton setImage:IMAGE_NAMED(@"post_detail_more") forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *mainContent = [[UILabel alloc] init];
        mainContent.font = [UIFont systemFontOfSize:14];
        mainContent.textColor = [UIColor whiteColor];
        //mainContent.text = @"网页网易有道是中国领先的智能学习公司，致力于提供100%以用户为导向的学习产品和服务。";
        mainContent.numberOfLines = 0;
        self.mainContent = mainContent;
        
        UIView *pictureContainer = [[UIView alloc] init];
        self.pictureContainer = pictureContainer;
        
        UIButton *praiseButton = [[UIButton alloc] init];
        [praiseButton setImage:[UIImage imageNamed:@"circle-praise"] forState:UIControlStateNormal];
        [praiseButton setTitle:@"152" forState:UIControlStateNormal];
        [praiseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.praiseButton = praiseButton;
        
        UIButton *commentButton = [[UIButton alloc] init];
        [commentButton setImage:[UIImage imageNamed:@"circle-comment"] forState:UIControlStateNormal];
        [commentButton setTitle:@"254" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commentButton = commentButton;
        
        UIView *tagView = [[UIView alloc] init];
        tagView.layer.borderColor = ((UIColor *)[UIColor getColor:@"3ce2ce"]).CGColor;
        tagView.layer.borderWidth = 1;
        tagView.layer.cornerRadius = 5;
        tagView.backgroundColor = [UIColor getColor:@"3ce3c9" alpha:0.22];
        self.tagView = tagView;
        
        UILabel *tagText = [[UILabel alloc] init];
        tagText.font = [UIFont systemFontOfSize:14];
        tagText.textColor = [UIColor whiteColor];
        //tagText.text = @"#电影游戏";
        self.tagText = tagText;
        
        [self.contentView addSubview:mainContainer];
        [mainContainer addSubview:avatar];
        [mainContainer addSubview:briefView];
        [briefView addSubview:userName];
        [briefView addSubview:level];
        [briefView addSubview:postTime];
        [briefView addSubview:viewCount];
        [mainContainer addSubview:moreButton];
        [mainContainer addSubview:mainContent];
        [mainContainer addSubview:pictureContainer];
        [mainContainer addSubview:commentButton];
        [mainContainer addSubview:praiseButton];
        [mainContainer addSubview:tagView];
        [tagView addSubview:tagText];
        
        [mainContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(0);
        }];
        
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(52, 52));
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(8);
        }];
        
        [briefView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatar.mas_right).offset(8);
            make.centerY.equalTo(avatar);
        }];
        
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(briefView);
        }];
        
        [level mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userName);
            make.left.equalTo(userName.mas_right).offset(2);
            make.size.mas_equalTo(CGSizeMake(50, 18));
            make.right.lessThanOrEqualTo(briefView);
        }];
        
        [postTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userName);
            make.top.equalTo(userName.mas_bottom).offset(2);
        }];
        
        [viewCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(postTime.mas_right).offset(10);
            make.centerY.equalTo(postTime);
            make.right.lessThanOrEqualTo(briefView);
            make.bottom.mas_equalTo(0);
        }];
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8.f);
            make.right.mas_equalTo(-10.f);
        }];
        
        [mainContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.equalTo(avatar.mas_bottom).offset(10);
        }];
        
        [pictureContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainContent.mas_bottom).offset(9);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_equalTo(-46);
        }];
        
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pictureContainer.mas_bottom).offset(14);
            make.left.equalTo(pictureContainer);
        }];
        
        [praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentButton.mas_right).offset(18);
            make.centerY.equalTo(commentButton);
        }];
        
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-9);
            make.height.mas_equalTo(26);
            make.centerY.equalTo(commentButton);
        }];
        
        [tagText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tagView);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidSelectedAction:)];
        [self.avatar addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.avatar layoutIfNeeded];
    [self.avatar setImageWithObject:[NSString stringSafeChecking:self.mCFLData.memberBaseDto.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    self.userName.text = [NSString stringSafeChecking:self.mCFLData.memberBaseDto.nickname];
    
    if([NSString isNotEmptyAndValid:self.mCFLData.memberBaseDto.level] &&
       [self.mCFLData.memberBaseDto.level integerValue] > 0) {
        self.level.hidden = NO;
        self.level.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", self.mCFLData.memberBaseDto.level]];
    }
    else {
        self.level.hidden = YES;
    }
    
    self.postTime.text = [NSString stringSafeChecking:self.mCFLData.dateStr];
    self.viewCount.text = [NSString stringWithFormat:@"%@浏览", [HelpTools checkNumberInfo:self.mCFLData.seeNum]];
    
    [self.praiseButton setTitle:[HelpTools checkNumberInfo:self.mCFLData.likeNum] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HelpTools checkNumberInfo:self.mCFLData.commentNum] forState:UIControlStateNormal];
    
    if([NSString isNotEmptyAndValid:self.mCFLData.discussList]) {
        
        self.tagText.text = [NSString stringWithFormat:@"#%@", self.mCFLData.discussList];
        self.tagText.hidden = NO;
        self.tagView.hidden = NO;
    }
    else {
        self.tagText.hidden = YES;
        self.tagView.hidden = YES;
    }
    
    [self.pictureCache makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //self.mainContent.text = [NSString stringSafeChecking:self.mCFLData.content];
    self.mainContent.attributedText = [AGCircleTableViewCell checkContentString:self.mCFLData.content];
    
    NSArray *mediaArray = [[NSString stringSafeChecking:self.mCFLData.media] componentsSeparatedByString:@";"];
    if(!mediaArray || !mediaArray.count) {
        
        if([NSString isNotEmptyAndValid:self.mCFLData.media]) {
            
            mediaArray = @[self.mCFLData.media];
        }
    }
    mediaArray = [NSArray filterEmptyStringFromArray:mediaArray];
    
    if (mediaArray.count > 0) {
        if (mediaArray.count == 1) {
            CarouselImageView *firstPicture = [self getCachedImageViewAtIndex:0 setURLString:mediaArray[0]];
            [self.pictureContainer addSubview:firstPicture];
            [firstPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.pictureContainer);
                make.height.mas_equalTo(picHeightArray[1]);
            }];
        } else if (mediaArray.count == 2) {
            CarouselImageView *firstPicture = [self getCachedImageViewAtIndex:0 setURLString:mediaArray[0]];
            CarouselImageView *secondPicture = [self getCachedImageViewAtIndex:1 setURLString:mediaArray[1]];
            [self.pictureContainer addSubview:firstPicture];
            [self.pictureContainer addSubview:secondPicture];
            
            [firstPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self.pictureContainer);
                make.height.mas_equalTo(picHeightArray[2]);
            }];
            
            [secondPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self.pictureContainer);
                make.height.width.equalTo(firstPicture);
                make.left.equalTo(firstPicture.mas_right).offset(6);
            }];
        } else {
            CarouselImageView *firstPicture = [self getCachedImageViewAtIndex:0 setURLString:mediaArray[0]];
            CarouselImageView *secondPicture = [self getCachedImageViewAtIndex:1 setURLString:mediaArray[1]];
            CarouselImageView *thirdPicture = [self getCachedImageViewAtIndex:2 setURLString:mediaArray[2]];
            [self.pictureContainer addSubview:firstPicture];
            [self.pictureContainer addSubview:secondPicture];
            [self.pictureContainer addSubview:thirdPicture];
            
            [firstPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.equalTo(self.pictureContainer);
                make.width.height.mas_equalTo(picHeightArray[3]);
            }];
            
            [secondPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(self.pictureContainer);
                make.left.equalTo(firstPicture.mas_right).offset(6);
            }];
            
            [thirdPicture mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.equalTo(self.pictureContainer);
                make.top.equalTo(secondPicture.mas_bottom).offset(3);
                make.left.equalTo(secondPicture);
                make.height.equalTo(secondPicture);
            }];
        }
    }
}

- (void)setMCFLData:(AGCircleFollowLastData *)mCFLData {
    _mCFLData = mCFLData;
    
    [self setNeedsLayout];
}

+ (NSMutableAttributedString*)checkContentString:(NSString*)string {
    if(![NSString isNotEmptyAndValid:string]) {
        
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [paragraphStyle setLineSpacing:6.5];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont font15]}];
    
    return attributedString;
}

+ (CGFloat)calculateHeightWithCFLData:(AGCircleFollowLastData *)cflData {
    
    //NSString *detail = [NSString stringSafeChecking:cflData.content];
    NSAttributedString *detail = [self checkContentString:cflData.content];
    
    NSArray *mediaArray = [[NSString stringSafeChecking:cflData.media] componentsSeparatedByString:@";"];
    if(!mediaArray || !mediaArray.count) {
        
        if([NSString isNotEmptyAndValid:cflData.media]) {
            
            mediaArray = @[cflData.media];
        }
    }
    mediaArray = [NSArray filterEmptyStringFromArray:mediaArray];
    NSInteger picCount = mediaArray.count > 3 ? 3 : mediaArray.count;
    
    CGSize limitSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, FLT_MAX);
    //NSDictionary<NSAttributedStringKey, id> *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    //return 86 + ceil([detail boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height) + picHeightArray[picCount] + 55;
    return 86 + ceil([HelpTools sizeWithAttributeString:detail withShowSize:limitSize].height) + picHeightArray[picCount] + 55;
}

- (CarouselImageView *)getCachedImageViewAtIndex:(NSUInteger)index setURLString:(NSString *)urlString {
    CarouselImageView *imageView;
    NSMutableArray<CarouselImageView *> *pictureCache = self.pictureCache;
    if (pictureCache.count < index + 1) {
        imageView = [[CarouselImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 10.f;
        imageView.layer.masksToBounds = YES;
        imageView.ignoreCache = YES;
        pictureCache[index] = imageView;
    } else {
        imageView = pictureCache[index];
    }
    
    //[imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    if(!CGRectEqualToRect(imageView.frame, CGRectZero)) {
        
        [imageView setImageWithObject:[NSString stringSafeChecking:urlString] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    }
    
    return imageView;
}

- (NSMutableArray<CarouselImageView *> *)pictureCache {
    if (!_pictureCache) {
        _pictureCache = [NSMutableArray arrayWithCapacity:3];
    }
    
    return _pictureCache;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Selector
- (void)moreButtonAction:(UIButton *)button {
    
    if(self.moreDidSelectedHandle) {
        
        self.moreDidSelectedHandle(self.mCFLData);
    }
}

- (void)tapDidSelectedAction:(id)sender {
    
    if(self.didHeadIconSelectedHandle) {
        
        self.didHeadIconSelectedHandle(self.mCFLData);
    }
}

@end
