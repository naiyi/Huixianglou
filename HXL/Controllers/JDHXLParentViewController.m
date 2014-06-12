//
//  JDHXLParentViewController.m
//  HXL
//
//  Created by Roc on 14-6-9.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHXLParentViewController.h"

@interface JDHXLParentViewController ()

@end

@implementation JDHXLParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, IS_iOS7 ? App_Height : App_Height - Nav_Height)];
        [self.loadingView setBackgroundColor:BACKGROUND_COLOR];
        UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90.0, 200.0, 140.0, 65.0)];
        [loadingImageView setImage:[UIImage imageNamed:@"loading_bg"]];
        [self.loadingView addSubview:loadingImageView];
        
        self.notavilableView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, IS_iOS7 ? App_Height : App_Height - Nav_Height)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IS_iOS7 ? @"navigation_bg" : @"navigation_bg_44"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(118.5, 10.0, 83.0, 25.0)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    
    [self.navigationItem setTitleView:self.titleLabel];
}

- (void)setNavigationRightButtonWithImage:(UIImage *)image Target:(id)target Action:(SEL)selector
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 12.0, 20.0, 20.0)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
}

- (void)setNavigationLeftButtonWithImage:(UIImage *)image Target:(id)target Action:(SEL)selector
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 12.0, 20.0, 20.0)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
}

- (void)setNavigationTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

- (void)setNavigationTitleView:(UIView *)view
{
    [self.navigationItem setTitleView:view];
}

- (void)setNetworkState:(int)state
{
    switch (state) {
        case NETWORK_STATE_LOADING:
            [self.contentView removeFromSuperview];
            [self.notavilableView removeFromSuperview];
            [self.view addSubview:self.loadingView];
            break;
        case NETWORK_STATE_NOTAVILABLE:
            [self.loadingView removeFromSuperview];
            [self.contentView removeFromSuperview];
            [self.view addSubview:self.notavilableView];
            break;
        case NETWORK_STATE_NORMAL:
            self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, IS_iOS7 ? App_Height : App_Height - Nav_Height)];
            [self setContentView];
            [self.loadingView removeFromSuperview];
            [self.notavilableView removeFromSuperview];
            [self.view addSubview:self.contentView];
            break;
    }
}

- (void)setContentView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
