//
//  JDSettingsViewController.m
//  HXL
//
//  Created by Roc on 14-6-9.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDSettingsViewController.h"
#import "JDAboutusViewController.h"
#import "JDFeedbackViewController.h"
#import "SDImageCache.h"
#import "iVersion.h"

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

- (void)viewDidAppear:(BOOL)animated
{
    [clearEdit setText:[self calculateCacheSize]];
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
    UITapGestureRecognizer *about_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(about_usClicked)];
    [aboutusLabel addGestureRecognizer:about_tap];
    [aboutusLabel setUserInteractionEnabled:YES];
    [settingItem2 addSubview:aboutusLabel];
    
    feedbackLable = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 45.0, 285.0, 45.0)];
    [feedbackLable setBackgroundColor:[UIColor clearColor]];
    [feedbackLable setFont:[UIFont systemFontOfSize:18.0]];
    [feedbackLable setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [feedbackLable setTextAlignment:NSTextAlignmentLeft];
    [feedbackLable setText:@"意见反馈"];
    UITapGestureRecognizer *feedback_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedBackClicked)];
    [feedbackLable addGestureRecognizer:feedback_tap];
    [feedbackLable setUserInteractionEnabled:YES];
    [settingItem2 addSubview:feedbackLable];
    clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 90.0, 185.0, 45.0)];
    [clearLabel setBackgroundColor:[UIColor clearColor]];
    [clearLabel setFont:[UIFont systemFontOfSize:18.0]];
    [clearLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [clearLabel setTextAlignment:NSTextAlignmentLeft];
    [clearLabel setText:@"清除缓存"];
    UITapGestureRecognizer *clean_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanClicked)];
    [clearLabel addGestureRecognizer:clean_tap];
    [clearLabel setUserInteractionEnabled:YES];
    [settingItem2 addSubview:clearLabel];
    clearEdit = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 90.0, 85.0, 45.0)];
    [clearEdit setBackgroundColor:[UIColor clearColor]];
    [clearEdit setFont:[UIFont systemFontOfSize:18.0]];
    [clearEdit setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [clearEdit setTextAlignment:NSTextAlignmentRight];
    [clearEdit setText:[self calculateCacheSize]];
    UITapGestureRecognizer *clean_tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanClicked)];
    [clearEdit addGestureRecognizer:clean_tap1];
    [clearEdit setUserInteractionEnabled:YES];
    [settingItem2 addSubview:clearEdit];
    [self.contentView addSubview:settingItem2];
    
    settingItem3 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 235.0, 300.0, 94.0)];
    [settingItem3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_item3"]]];
    checkupdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 285.0, 45.0)];
    [checkupdateLabel setBackgroundColor:[UIColor clearColor]];
    [checkupdateLabel setFont:[UIFont systemFontOfSize:18.0]];
    [checkupdateLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [checkupdateLabel setTextAlignment:NSTextAlignmentLeft];
    [checkupdateLabel setText:@"检查更新"];
    UITapGestureRecognizer *check_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkClicked)];
    [checkupdateLabel addGestureRecognizer:check_tap];
    [checkupdateLabel setUserInteractionEnabled:YES];
    [settingItem3 addSubview:checkupdateLabel];
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 45.0, 285.0, 45.0)];
    [scoreLabel setBackgroundColor:[UIColor clearColor]];
    [scoreLabel setFont:[UIFont systemFontOfSize:18.0]];
    [scoreLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [scoreLabel setTextAlignment:NSTextAlignmentLeft];
    [scoreLabel setText:@"给我打分"];
    UITapGestureRecognizer *rate_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptForRating)];
    [scoreLabel addGestureRecognizer:rate_tap];
    [scoreLabel setUserInteractionEnabled:YES];
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

- (void)about_usClicked
{
    JDAboutusViewController *about_us = [[JDAboutusViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:about_us animated:YES];
}

- (void)checkClicked
{
    [iVersion sharedInstance].ignoredVersion = nil;
    [[iVersion sharedInstance] checkForNewVersion];
}

- (void)feedBackClicked
{
    JDFeedbackViewController *feedback = [[JDFeedbackViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:feedback animated:YES];
}

- (NSString *) calculateCacheSize {
    float diskFileSize = [JDHXLUtil getDiskCacheFileSize]/1000.0f;
    NSString *sizeUnit = @"K";
    if (diskFileSize > 1000.0f) {
        diskFileSize = diskFileSize/1000.0f;
        sizeUnit = @"M";
    }
    NSString *ret = [NSString stringWithFormat:@"%.2f%@", diskFileSize, sizeUnit];
    return ret;
}

- (void)cleanClicked
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"确定要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    } else {
        [[SDImageCache sharedImageCache] clearDisk];    // 图片缓存
        [JDHXLUtil deleteJDOCacheDirectory];    // 文件缓存
        [JDHXLUtil createJDOCacheDirectory];
        [JDHXLUtil deleteURLCacheDirectory];    // URL在sqlite的缓存(cache.db)
        [clearEdit setText:@"0.00K"];
    }
}

#pragma mark - 评价应用相关
- (void)promptForRating{
    
    [[iRate sharedInstance] promptIfNetworkAvailable];
    HUD = [[MBProgressHUD alloc] initWithView:self.contentView];
    [self.contentView addSubview:HUD];
    HUD.margin = 15.f;
    HUD.removeFromSuperViewOnHide = true;
    HUD.labelText = @"连接AppStore";
    [HUD show:true];
}

- (void)iRateCouldNotConnectToAppStore:(NSError *)error{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_icon_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"无法连接";
    [HUD hide:true afterDelay:1.0];
    HUD = nil;
}

- (BOOL)iRateShouldPromptForRating{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_icon_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"连接成功";
    [HUD hide:true afterDelay:1.0];
    HUD = nil;
    [[iRate sharedInstance] performSelector:@selector(openRatingsPageInAppStore) withObject:nil afterDelay:1.0f];
    //    [[iRate sharedInstance] openRatingsPageInAppStore];
    return false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
