//
//  JDFeedbackViewController.m
//  HXL
//
//  Created by Roc on 14-7-3.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDFeedbackViewController.h"

@interface JDFeedbackViewController ()

@end

@implementation JDFeedbackViewController

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
    [self setNavigationTitle:@"意见反馈"];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    
    [self setNetworkState:NETWORK_STATE_NORMAL];
}

- (void)setContentView
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.contentView setUserInteractionEnabled:YES];
    [self.contentView addGestureRecognizer:tapGesture];
    
    contentField = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 100.0)];
    contentField.layer.cornerRadius = 2;//设置视图圆角
    contentField.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    contentField.layer.borderColor = cgColor;
    contentField.layer.borderWidth = 1.0;
    [contentField setTextColor:[UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:1.0]];
    [contentField setFont:[UIFont systemFontOfSize:16.0]];
    [contentField setDelegate:self];
    [self.contentView addSubview:contentField];
    
    [self setupBottomView];
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 49.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [submitButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_btn_bg_r"]]];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitButton];
    [self.contentView addSubview:bottomView];
}

- (void)onSubmitButtonClicked
{
    if (([contentField text])&&([contentField text].length > 0)) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"1" forKey:@"id"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]) {
            [params setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] objectForKey:@"tel"] forKey:@"tel"];
            [params setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] objectForKey:@"nick_name"] forKey:@"nick_names"];
        } else {
            [params setObject:@"" forKey:@"tel"];
            [params setObject:@"匿名用户" forKey:@"nick_names"];
        }
        
    } else {
        [self showToast:@"请填写意见"];
    }
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard
{
    if (keyBoardShowing) {
        [contentField resignFirstResponder];
        
        CGRect frame = bottomView.frame;
        int offset = frame.origin.y + 216.0;//键盘高度216
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = bottomView.frame.size.width;
        float height = bottomView.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(0.0f, offset, width, height);
            bottomView.frame = rect;
        }
        [UIView commitAnimations];
        keyBoardShowing = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (keyBoardShowing) {
        return;
    }
    CGRect frame = bottomView.frame;
    int offset = frame.origin.y - 216.0;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = bottomView.frame.size.width;
    float height = bottomView.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, offset, width, height);
        bottomView.frame = rect;
    }
    [UIView commitAnimations];
    keyBoardShowing = YES;
}

- (void)showToast:(NSString *)message
{
    iToast *toast = [iToast makeText:message];
    [toast setDuration:3000];
    [toast setGravity:iToastGravityBottom];
    [toast show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
