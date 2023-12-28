//
//  SZFinessContentView.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessContentView.h"
#import "SZFinessTopHeaderView.h"
#import "SZFinessItemCell.h"

@interface SZFinessContentView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SZFinessTopHeaderView *headView;

@end

@implementation SZFinessContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.leading.top.mas_equalTo(self);        
    }];
    
    self.headView = [[SZFinessTopHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH)];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 0;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return self.headView;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        UILabel *titleL = [[UILabel alloc] init];
        [headView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(headView.mas_leading).offset(12);
            make.top.mas_equalTo(headView.mas_top).offset(15);
        }];
        titleL.text = @"热玩";
        titleL.font = FONT_BOLD_SYSTEM(15);
        titleL.textColor = UIColor.whiteColor;
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return SCREENWIDTH;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SZFinessItemCell *cell = [SZFinessItemCell finessItemCellWithTableView:tableView indexPath:indexPath];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[SZFinessItemCell class] forCellReuseIdentifier:@"SZFinessItemCell"];
    }
    return _tableView;
}


@end
