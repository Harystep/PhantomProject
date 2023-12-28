//
//  NetWorkListViewController.m
//  KuaiDaiMarket
//
//  Created by Abner on 2019/4/23.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "NetWorkListViewController.h"

@interface NetWorkListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation NetWorkListViewController

- (instancetype)initWithNetDataSource:(NSArray <NetWorkListData *> *)dataArray{
    
    if(self = [super init]){
        
        self.dataSourceArray = dataArray.copy;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -

- (void)autoDevelopmentEnvironment:(NSInteger)index{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NetWorkListData *data = [self.dataSourceArray objectAtIndex:index];
        
        [HelpTools sharedAppSingleton].baseUrlString = data.url;
        [HelpTools sharedAppSingleton].newsUrlString = data.newsUrl;
        
        if(self.dismissDidHandle){
            
            self.dismissDidHandle(index);
        }
    });
}

#pragma mark - UITableViewDataSource & UITbaleViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if(!tableCell){
        
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    NetWorkListData *data = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    tableCell.imageView.layer.cornerRadius = 4.f;
    tableCell.imageView.image = [self getImageWithText:data.desc];
    tableCell.textLabel.text = data.url;
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NetWorkListData *data = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    [HelpTools sharedAppSingleton].baseUrlString = data.url;
    [HelpTools sharedAppSingleton].newsUrlString = data.newsUrl;
    
    if(self.dismissDidHandle){
        
        self.dismissDidHandle(indexPath.row);
    }
}

#pragma mark -

- (UIImage *)getImageWithText:(NSString *)text{
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 74.f, 44.f)];
    imageLabel.backgroundColor = [UIColor orangeColor];
    imageLabel.textAlignment = NSTextAlignmentCenter;
    imageLabel.font = FONT_SYSTEM(14.f);
    imageLabel.text = text;
    
    return [HelpTools convertViewToImage:imageLabel];
}

#pragma mark -

- (UITableView *)tableView{
    
    if(!_tableView){
        
        _tableView = [UITableView new];
        _tableView.frame = self.view.bounds;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (NSArray *)testDataSourceArray{
    
    if(!_dataSourceArray){
        
        NetWorkListData *data1 = [NetWorkListData new];
        data1.desc = @"测试";
        data1.url = @"http://101.132.112.197:8084";
        data1.newsUrl = @"http://jrtest.zuoja.com";
        
        NetWorkListData *data2 = [NetWorkListData new];
        data2.desc = @"线上";
        data2.url = @"";
        data2.newsUrl = @"";
        
        _dataSourceArray = [NSArray arrayWithObjects:data1, data2, nil];
    }
    
    return _dataSourceArray;
}

@end

/*
 *  NetWorkListData
 */
@implementation NetWorkListData

+ (NetWorkListData *)dataWithUrl:(NSString *)url
                            desc:(NSString *)desc
                         newsUrl:(NSString *)newsUrl{
    
    NetWorkListData *data = [NetWorkListData new];
    data.newsUrl = newsUrl;
    data.desc = desc;
    data.url = url;
    
    return data;
}

@end


