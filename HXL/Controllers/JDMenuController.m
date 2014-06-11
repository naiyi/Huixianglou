//
//  JDMenuController.m
//  HXL
//
//  Created by 刘斌 on 14-6-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDMenuController.h"

@implementation JDMenuController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    //[self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    UIView *titleView = [[UIView alloc] init];
    [self setNavigationTitleView:titleView];
}
- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
