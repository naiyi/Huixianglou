//
//  JDUserViewController.m
//  HXL
//
//  Created by Roc on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDUserViewController.h"
#import "JDSettingsViewController.h"

@interface JDUserViewController ()

@end

@implementation JDUserViewController

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
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    [self setNavigationTitle:@"个人中心"];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    if (userinfo) {
        [self setUpUserView];
    } else {
        [self setUpLoginView];
    }
}

- (void)setUpLoginView
{
    [self setNetworkState:NETWORK_STATE_NORMAL];
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 14.0, 300.0, self.contentView.frame.size.height - 24.0 - 49.0)];
    [centerView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.contentView addSubview:centerView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 12.0, 80.0, 17.0)];
    [nameLabel setText:@"联系人"];
    [nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [centerView addSubview:nameLabel];
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 13.0, 100.0, 17.0)];
    [nameField setPlaceholder:@"请输入名字"];
    [nameField setFont:[UIFont systemFontOfSize:16.0]];
    [nameField setTextAlignment:NSTextAlignmentLeft];
    [nameField setTextColor:[UIColor blackColor]];
    [centerView addSubview:nameField];
    UIImageView *divider1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 38.0, 300.0, 1.0)];
    [divider1 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider1];
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 51.0, 80.0, 17.0)];
    [telLabel setText:@"手机号码"];
    [telLabel setFont:[UIFont systemFontOfSize:16.0]];
    [telLabel setTextAlignment:NSTextAlignmentLeft];
    [telLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [centerView addSubview:telLabel];
    telField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 52.0, 100.0, 17.0)];
    [telField setPlaceholder:@"请输入电话"];
    [telField setFont:[UIFont systemFontOfSize:16.0]];
    [telField setTextAlignment:NSTextAlignmentLeft];
    [telField setTextColor:[UIColor blackColor]];
    [centerView addSubview:telField];
    UIImageView *divider2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 77.0, 300.0, 1.0)];
    [divider2 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider2];
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 89.0, 80.0, 17.0)];
    [codeLabel setText:@"验证码"];
    [codeLabel setFont:[UIFont systemFontOfSize:16.0]];
    [codeLabel setTextAlignment:NSTextAlignmentLeft];
    [codeLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [centerView addSubview:codeLabel];
    codeField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 90.0, 100.0, 17.0)];
    [codeField setPlaceholder:@"请输入验证码"];
    [codeField setFont:[UIFont systemFontOfSize:16.0]];
    [codeField setTextAlignment:NSTextAlignmentLeft];
    [codeField setTextColor:[UIColor blackColor]];
    [centerView addSubview:codeField];
    UIImageView *divider4 = [[UIImageView alloc] initWithFrame:CGRectMake(200.0, 78.0, 1.0, 38.0)];
    [divider4 setImage:[UIImage imageNamed:@"divider_v"]];
    [centerView addSubview:divider4];
    codeButton = [[UIButton alloc] initWithFrame:CGRectMake(201.0, 89.0, 99.0, 38.0)];
    [codeButton setBackgroundColor:[UIColor clearColor]];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0] forState:UIControlStateNormal];
    [codeButton setTitleEdgeInsets:UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
    [[codeButton titleLabel] setFont:[UIFont systemFontOfSize:16.0]];
    [centerView addSubview:codeButton];
    UIImageView *divider3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 115.0, 300.0, 1.0)];
    [divider3 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider3];
    
    [self setupBottomView];
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 49.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    //[bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [loginButton setImage:[UIImage imageNamed:@"start_btn_bg_1"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(onLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setUserInteractionEnabled:NO];
    [bottomView addSubview:loginButton];
    [self.contentView addSubview:bottomView];
}

- (void)onLoginButtonClicked
{
    
}

- (void)setUpUserView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
