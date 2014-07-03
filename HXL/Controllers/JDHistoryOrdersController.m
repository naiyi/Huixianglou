//
//  JDHistoryOrdersController.m
//  HXL
//
//  Created by Roc on 14-6-24.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHistoryOrdersController.h"
#import "JDHistoryOrderTableViewCell.h"

@interface JDHistoryOrdersController ()

@end

@implementation JDHistoryOrdersController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"历史订单"];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    NSDictionary *params = @{@"tel": [user_info objectForKey:@"tel"]};
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[JDOrderModel class] forAttribute:@"data" onClass:[JDHXLArrayModel class]];
    [config addArrayMapper:mapper];
    
    [[JDOHttpClient sharedClient] getJSONByServiceName:GET_HISTORY_ORDER_LIST modelClass:@"JDHXLArrayModel" config:config params:params success:^(JDHXLArrayModel *dataModel) {
        orderDatas = dataModel.data;
        [self setNetworkState:NETWORK_STATE_NORMAL];
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
}


- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)setContentView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 12.0, 300.0, self.contentView.frame.size.height - 22.0) style:UITableViewStylePlain];
    [orderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [orderTableView setBackgroundColor:[UIColor clearColor]];
    [orderTableView setDelegate:self];
    [orderTableView setDataSource:self];
    [self.contentView addSubview:orderTableView];
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"HistoryOrderCellIdentifier";
    JDHistoryOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JDHistoryOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    int bg = 0;
    if (indexPath.row == orderDatas.count - 1) {
        bg = 1;
    }
    [cell setModel:[orderDatas objectAtIndex:indexPath.row] andBG:bg];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
