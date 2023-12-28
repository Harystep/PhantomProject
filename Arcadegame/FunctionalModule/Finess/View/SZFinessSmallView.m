//
//  SZFinessSmallView.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessSmallView.h"
#import "SZFinessTopHeaderSmallView.h"
#import "SZFinessItemCell.h"
#import "SZFinessPlayedItemCell.h"
#import "SYBBaseProcotolController.h"

@interface SZFinessSmallView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SZFinessTopHeaderSmallView *headView;

@property (nonatomic,strong) NSArray *historyArr;

@end

@implementation SZFinessSmallView

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
    
    self.headView = [[SZFinessTopHeaderSmallView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 0;
    } else if (section == 1) {
        return 1;
//        return self.historyArr.count>0?1:0;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return self.headView;
    } else if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        UILabel *titleL = [[UILabel alloc] init];
        [headView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(headView.mas_leading).offset(12);
            make.top.mas_equalTo(headView.mas_top).offset(15);
        }];
        titleL.text = @"最近常玩";
        titleL.font = FONT_BOLD_SYSTEM(15);
        titleL.textColor = UIColor.whiteColor;
        return headView;
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
        return 200;
    } else if (section == 1) {
        return 50.;
    } else {
        return 50.;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {        
        SZFinessPlayedItemCell *cell = [SZFinessPlayedItemCell finessPlayedItemCellWithTableView:tableView indexPath:indexPath];
        return cell;
    } else {
        SZFinessItemCell *cell = [SZFinessItemCell finessItemCellWithTableView:tableView indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYBBaseProcotolController *baseVc = [[SYBBaseProcotolController alloc] init];
    [self.superViewController.navigationController pushViewController:baseVc animated:YES];
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
        [_tableView registerClass:[SZFinessPlayedItemCell class] forCellReuseIdentifier:@"SZFinessPlayedItemCell"];
    }
    return _tableView;
}

@end
