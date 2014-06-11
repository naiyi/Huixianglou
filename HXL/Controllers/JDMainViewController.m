//
//  JDHXLMainViewController.m
//  HXL
//
//  Created by Roc on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDMainViewController.h"
#import "JDUserViewController.h"
#import "JDSettingsViewController.h"
#import "JDMenuController.h"
#import "JDOHttpClient.h"
#import "JDHotelModel.h"
#import "JDHXLModel.h"
#import "DCKeyValueObjectMapping.h"

@interface JDMainViewController ()

@end

@implementation JDMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSDictionary *params = @{@"id": @"1"};
    // 加载酒店信息
    [[JDOHttpClient sharedClient] getJSONByServiceName:HOTEL_INFO_SERVICE modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        DCKeyValueObjectMapping *mapper = [DCKeyValueObjectMapping mapperForClass:[JDHotelModel class]];
        JDHotelModel *hoteldata = [mapper parseDictionary:dataModel.data];
    } failure:^(NSString *errorStr) {
        
    }];

    
    [super viewDidLoad];
    [self setNavigationTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title"]]];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"user_btn_bg"] Target:self Action:@selector(onUserButtonClicked)];
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    
    centerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, IS_iOS7 ? Nav_Height - 4.0 : - 4.0, 320.0, App_Height - 96.0 - 49.0 - Nav_Height + 4.0)];
    [centerScrollView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:centerScrollView];
    
    addrAndTelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, IS_iOS7 ? centerScrollView.frame.size.height + Nav_Height - 4.0 : centerScrollView.frame.size.height - 4.0, 320.0, 96.0)];
    [addrAndTelView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.980 blue:0.906 alpha:1.0]];
    [self.view addSubview:addrAndTelView];
    [self setupAddrAndTelView];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, addrAndTelView.frame.origin.y + 96.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.view addSubview:bottomView];
    [self setupBottomView];
}

- (void)setupAddrAndTelView
{
    
}

- (void)setupBottomView
{
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [startButton setImage:[UIImage imageNamed:@"start_btn_bg_1"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(onStartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:startButton];
}

- (void)onUserButtonClicked
{
    JDUserViewController *userViewController = [[JDUserViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:userViewController animated:YES];
}

- (void)onSettingButtonClicked
{
    JDSettingsViewController *settingsViewController = [[JDSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)onStartButtonClicked
{
    JDMenuController *menuController = [[JDMenuController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:menuController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
