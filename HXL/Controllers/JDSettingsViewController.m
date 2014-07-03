//
//  JDSettingsViewController.m
//  HXL
//
//  Created by Roc on 14-6-9.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDSettingsViewController.h"

@interface JDSettingsViewController ()

@end

@implementation JDSettingsViewController

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
    [self setNavigationTitle:@"设置"];
    [self setNetworkState:NETWORK_STATE_NORMAL];
}

- (void)setContentView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    NSString *username = nil;
    if (user) {
        username = [NSString stringWithFormat:@"%@  %@", [user objectForKey:@"nick_name"], [user objectForKey:@"tel"]];
    } else {
        username = @"";
    }
    
    settingItem1 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 15.0, 300.0, 51.0)];
    [settingItem1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_item1"]]];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 75.0, 25.0)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nameLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setText:@"当前账户"];
    [settingItem1 addSubview:nameLabel];
    nameEdit = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 10.0, 195.0, 25.0)];
    [nameEdit setBackgroundColor:[UIColor clearColor]];
    [nameEdit setFont:[UIFont systemFontOfSize:18.0]];
    [nameEdit setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [nameEdit setTextAlignment:NSTextAlignmentRight];
    [nameEdit setText:username];
    [settingItem1 addSubview:nameEdit];
    [self.contentView addSubview:settingItem1];
    
    settingItem2 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 81.0, 300.0, 139.0)];
    [settingItem2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_item2"]]];
    aboutusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 285.0, 45.0)];
    [aboutusLabel setBackgroundColor:[UIColor clearColor]];
    [aboutusLabel setFont:[UIFont systemFontOfSize:18.0]];
    [aboutusLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [aboutusLabel setTextAlignment:NSTextAlignmentLeft];
    [aboutusLabel setText:@"关于我们"];
    [settingItem2 addSubview:aboutusLabel];
    feedbackLable = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 45.0, 285.0, 45.0)];
    [feedbackLable setBackgroundColor:[UIColor clearColor]];
    [feedbackLable setFont:[UIFont systemFontOfSize:18.0]];
    [feedbackLable setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [feedbackLable setTextAlignment:NSTextAlignmentLeft];
    [feedbackLable setText:@"意见反馈"];
    [settingItem2 addSubview:feedbackLable];
    clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 90.0, 285.0, 45.0)];
    [clearLabel setBackgroundColor:[UIColor clearColor]];
    [clearLabel setFont:[UIFont systemFontOfSize:18.0]];
    [clearLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [clearLabel setTextAlignment:NSTextAlignmentLeft];
    [clearLabel setText:@"清除缓存"];
    [settingItem2 addSubview:clearLabel];
    [self.contentView addSubview:settingItem2];
    
    settingItem3 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 235.0, 300.0, 94.0)];
    [settingItem3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_item3"]]];
    checkupdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 285.0, 45.0)];
    [checkupdateLabel setBackgroundColor:[UIColor clearColor]];
    [checkupdateLabel setFont:[UIFont systemFontOfSize:18.0]];
    [checkupdateLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [checkupdateLabel setTextAlignment:NSTextAlignmentLeft];
    [checkupdateLabel setText:@"检查更新"];
    [settingItem3 addSubview:checkupdateLabel];
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 45.0, 285.0, 45.0)];
    [scoreLabel setBackgroundColor:[UIColor clearColor]];
    [scoreLabel setFont:[UIFont systemFontOfSize:18.0]];
    [scoreLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [scoreLabel setTextAlignment:NSTextAlignmentLeft];
    [scoreLabel setText:@"给我打分"];
    [settingItem3 addSubview:scoreLabel];
    [self.contentView addSubview:settingItem3];
    
    [self setupBottomView];
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 49.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
    logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [logoutButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_btn_bg_r"]]];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setTitle:@"注 销" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(onLogoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setUserInteractionEnabled:YES];
    [bottomView addSubview:logoutButton];
    [self.contentView addSubview:bottomView];
}

- (void)onLogoutButtonClicked
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user_info"];
    [nameEdit setText:@""];
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
