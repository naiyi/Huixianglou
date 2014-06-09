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
    [super viewDidLoad];
    [self setNavigationTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title"]]];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"user_btn_bg"] Target:self Action:@selector(onUserButtonClicked)];
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    
    centerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 60.0, 320.0, 275.0)];
    [centerScrollView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:centerScrollView];
    
    addrAndTelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 335.0, 320.0, 96.0)];
    [addrAndTelView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.980 blue:0.906 alpha:1.0]];
    [self.view addSubview:addrAndTelView];
    [self setupAddrAndTelView];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 431.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.view addSubview:bottomView];
    [self setupBottomView];
}

- (void)setupAddrAndTelView
{
    
}

- (void)setupBottomView
{
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
