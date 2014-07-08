//
//  JDOrderDetailController.m
//  HXL
//
//  Created by Roc on 14-7-3.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDOrderDetailController.h"
#import "JDOrderDetailModel.h"
#import "JDHXLArrayModel.h"
#import "JDOrderDetailCell.h"
#import "JDOrderDetailBottomCell.h"

@interface JDOrderDetailController ()

@end

@implementation JDOrderDetailController

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
    [self setNavigationTitle:@"订单详情"];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    NSDictionary *params = @{@"tel" : [user_info objectForKey:@"tel"], @"order_id" : self.order_id};
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[JDOrderDetailModel class] forAttribute:@"data" onClass:[JDHXLArrayModel class]];
    [config addArrayMapper:mapper];
    
    [[JDOHttpClient sharedClient] getJSONByServiceName:ORDER_DETAIL modelClass:@"JDHXLArrayModel" config:config params:params success:^(JDHXLArrayModel *dataModel) {
        orderDetailDatas = dataModel.data;
        totalPrice = 0;
        for (int i = 0; i < orderDetailDatas.count; i++) {
            totalPrice = totalPrice + [[[orderDetailDatas objectAtIndex:i] price] integerValue];
        }
        [self setNetworkState:NETWORK_STATE_NORMAL];
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
}

- (void)setContentView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    
    UIImageView *top_bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 310.0, 12.0)];
    [top_bg1 setImage:[UIImage imageNamed:@"detail_top1"]];
    UIImageView *top_bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 310.0, 12.0)];
    [top_bg2 setImage:[UIImage imageNamed:@"detail_top2"]];
    UIImageView *top_bg3 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 310.0, 12.0)];
    [top_bg3 setImage:[UIImage imageNamed:@"detail_top3"]];
    
    [self.contentView addSubview:top_bg1];
    [self.contentView addSubview:top_bg2];
    
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 15.0, 320.0, self.contentView.frame.size.height - 25.0)];
    [orderTableView setDelegate:self];
    [orderTableView setDataSource:self];
    [orderTableView setBackgroundColor:[UIColor clearColor]];
    [orderTableView setShowsVerticalScrollIndicator:NO];
    [orderTableView setBounces:NO];
    [orderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.contentView addSubview:orderTableView];
    
    [self.contentView addSubview:top_bg3];
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"detailOrderCellIdentifier";
    if (indexPath.row < orderDetailDatas.count) {
        JDOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JDOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setModel:[orderDetailDatas objectAtIndex:indexPath.row] andOrderID:self.order_id andIndex:indexPath.row];
        cell.needGoodBad = self.needGoodBad;
        return cell;
    } else {
        JDOrderDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JDOrderDetailBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setModel:[NSString stringWithFormat:@"%d", totalPrice] andCount:[NSString stringWithFormat:@"%d", orderDetailDatas.count]];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderDetailDatas.count + 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
