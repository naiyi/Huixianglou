//
//  JDAboutusViewController.m
//  HXL
//
//  Created by Roc on 14-7-3.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDAboutusViewController.h"

@interface JDAboutusViewController ()

@end

@implementation JDAboutusViewController

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
    [self setNavigationTitle:@"关于我们"];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *params = @{@"id" : @"1"};
    [[JDOHttpClient sharedClient] getJSONByServiceName:ABOUT_US modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        about_us = (NSString *)dataModel.data;
        [self setNetworkState:NETWORK_STATE_NORMAL];
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
}

- (void)setContentView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120.0, 40.0, 80.0, 110.0)];
    [imageView setImage:[UIImage imageNamed:@"about_us_icon"]];
    [self.contentView addSubview:imageView];
    
    aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    [aboutLabel setNumberOfLines:0];
    [aboutLabel setBackgroundColor:[UIColor clearColor]];
    if (about_us) {
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size = CGSizeMake(300,2000);
        CGSize labelsize = [about_us sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        aboutLabel.frame = CGRectMake(0.0, 0.0, labelsize.width, labelsize.height );
        aboutLabel.backgroundColor = [UIColor clearColor];
        aboutLabel.textColor = [UIColor blackColor];
        aboutLabel.text = about_us;
        aboutLabel.font = font;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15.0, 160.0, 300.0, self.contentView.frame.size.height - 175.0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setContentSize:aboutLabel.frame.size];
    [scrollView addSubview:aboutLabel];
    [self.contentView addSubview:scrollView];
    
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
