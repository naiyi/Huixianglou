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
#import "DCKeyValueObjectMapping.h"
#import "JDHXLUtil.h"

#define Default_Image @"aaaaa"

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
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *params = @{@"id": @"1"};
    // 加载酒店信息
    [[JDOHttpClient sharedClient] getJSONByServiceName:HOTEL_INFO_SERVICE modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        DCKeyValueObjectMapping *mapper = [DCKeyValueObjectMapping mapperForClass:[JDHotelModel class]];
        self.hotelModel = [mapper parseDictionary:dataModel.data];
        [self setNetworkState:NETWORK_STATE_NORMAL];
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)setContentView{
    centerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, App_Height - 96.0 - 49.0 - Nav_Height + 4.0)];
    [centerScrollView setBackgroundColor:[UIColor redColor]];
    [centerScrollView setContentSize:CGSizeMake(320.0*self.hotelModel.img.count, centerScrollView.frame.size.height)];
    [centerScrollView setBounces:NO];
    [centerScrollView setPagingEnabled:YES];
    for (int i = 0; i < self.hotelModel.img.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320.0*i, 0.0, 320.0, centerScrollView.frame.size.height)];
        UIImageView *blockImageView = imageView;
        [imageView setImageWithURL:[NSURL URLWithString:[self.hotelModel.img objectAtIndex:0]] placeholderImage:[UIImage imageNamed:Default_Image] options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
            if(!cached){    // 非缓存加载时使用渐变动画
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [blockImageView.layer addAnimation:transition forKey:nil];
            }
        } failure:^(NSError *error) {
            
        }];
        [centerScrollView addSubview:imageView];
    }
    [self.contentView addSubview:centerScrollView];
    
    [self setupAddrAndTelView];
    [self setupBottomView];
}

- (void)setupAddrAndTelView
{
    addrAndTelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, centerScrollView.frame.origin.y + centerScrollView.frame.size.height, 320.0, 96.0)];
    [addrAndTelView setBackgroundColor:BACKGROUND_COLOR];
    UIView *whiteCenter = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 76.0)];
    [whiteCenter setBackgroundColor:[UIColor whiteColor]];
    [addrAndTelView addSubview:whiteCenter];
    UIImageView *addricon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_icon"]];
    UILabel *addrlabel = [[UILabel alloc] init];
    [addrlabel setText:self.hotelModel.address];
    [addrlabel setFont:[UIFont systemFontOfSize:16.0]];
    [addrlabel sizeToFit];
    [addricon setFrame:CGRectMake((320.0-addrlabel.frame.size.width-25.0)/2, 10.0, 20.0, 20.0)];
    [addrlabel setFrame:CGRectMake(addricon.frame.origin.x + addricon.frame.size.width + 5.0, 12.0, addrlabel.frame.size.width, 20.0)];
    [whiteCenter addSubview:addricon];
    [whiteCenter addSubview:addrlabel];
    UIImageView *telicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telephone_icon"]];
    UILabel *tellabel = [[UILabel alloc] init];
    [tellabel setText:self.hotelModel.tel];
    [tellabel setFont:[UIFont systemFontOfSize:16.0]];
    [tellabel sizeToFit];
    [telicon setFrame:CGRectMake((320.0-tellabel.frame.size.width-25.0)/2, 42.0, 20.0, 20.0)];
    [tellabel setFrame:CGRectMake(telicon.frame.origin.x + telicon.frame.size.width + 5.0, 44.0, tellabel.frame.size.width, 20.0)];
    [whiteCenter addSubview:telicon];
    [whiteCenter addSubview:tellabel];
    
    [self.contentView addSubview:addrAndTelView];
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, addrAndTelView.frame.origin.y + 96.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    //[bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
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
