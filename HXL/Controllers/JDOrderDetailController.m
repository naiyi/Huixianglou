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
        [self setNetworkState:NETWORK_STATE_NORMAL];
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
}

- (void)setContentView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
