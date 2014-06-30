//
//  JDUserViewController.m
//  HXL
//
//  Created by Roc on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDUserViewController.h"
#import "JDSettingsViewController.h"
#import "JDOHttpClient.h"
#import "JDHXLModel.h"
#import "JDCurrentOrdersController.h"
#import "JDHistoryOrdersController.h"

@interface JDUserViewController ()

@end

@implementation JDUserViewController

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
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    [self setNavigationTitle:@"个人中心"];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    if (userinfo) {
        [self getUserInfoFromNetWork];
    } else {
        [self setUpLoginView];
    }
}

- (void)setUpLoginView
{
    [userView removeFromSuperview];
    keyBoardShowing = NO;
    [self setNetworkState:NETWORK_STATE_NORMAL];
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 14.0, 300.0, self.contentView.frame.size.height - 24.0 - 49.0)];
    [centerView setUserInteractionEnabled:YES];
    [centerView setImage:[UIImage imageNamed:@"login_bg"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [centerView addGestureRecognizer:tapGesture];
    [self.contentView addSubview:centerView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 12.0, 80.0, 17.0)];
    [nameLabel setText:@"联系人"];
    [nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [centerView addSubview:nameLabel];
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 13.0, 150.0, 17.0)];
    [nameField setPlaceholder:@"请输入名字"];
    [nameField setFont:[UIFont systemFontOfSize:16.0]];
    [nameField setTextAlignment:NSTextAlignmentLeft];
    [nameField setTextColor:[UIColor blackColor]];
    [nameField setDelegate:self];
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
    telField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 52.0, 150.0, 17.0)];
    [telField setPlaceholder:@"请输入电话"];
    [telField setFont:[UIFont systemFontOfSize:16.0]];
    [telField setTextAlignment:NSTextAlignmentLeft];
    [telField setTextColor:[UIColor blackColor]];
    [telField setDelegate:self];
    [telField setKeyboardType:UIKeyboardTypeNumberPad];
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
    [codeField setDelegate:self];
    [codeField setKeyboardType:UIKeyboardTypeNumberPad];
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
    [codeButton addTarget:self action:@selector(onCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:codeButton];
    UIImageView *divider3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 115.0, 300.0, 1.0)];
    [divider3 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider3];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:nameField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:telField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:codeField];
    
    [self setupBottomView];
}

- (void)hideKeyboard
{
    if (keyBoardShowing) {
        [nameField resignFirstResponder];
        [telField resignFirstResponder];
        [codeField resignFirstResponder];
    
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

- (void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    int maxCount = 0;
    if (textField == nameField) {
        maxCount = 5;
    } else if (textField == telField) {
        maxCount = 11;
    } else if (textField == codeField) {
        maxCount = 4;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxCount) {
                textField.text = [toBeString substringToIndex:maxCount];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxCount) {
            textField.text = [toBeString substringToIndex:maxCount];
        }
    }
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 49.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [loginButton setImage:[UIImage imageNamed:@"start_btn_bg_1"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(onLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setUserInteractionEnabled:YES];
    [bottomView addSubview:loginButton];
    [self.contentView addSubview:bottomView];
}

- (void)showToast:(NSString *)message
{
    iToast *toast = [iToast makeText:message];
    [toast setDuration:3000];
    [toast setGravity:iToastGravityBottom];
    [toast show];
}

- (void)onCodeButtonClicked
{
    [self hideKeyboard];
    if (![JDHXLUtil isMobileNumber:[telField text]]) {
        [self showToast:@"电话号码有误"];
        return;
    }
    JDOHttpClient *httpclient = [JDOHttpClient sharedClient];
    NSDictionary *params = @{@"tel": telField.text};
    [httpclient getPath:GET_CAPTCHA parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = [(NSData *)responseObject objectFromJSONData];
        id jsonvalue = [json objectForKey:@"data"];
        if ([jsonvalue isKindOfClass:[NSNumber class]]) {
            int datavalue = [(NSNumber *)jsonvalue integerValue];
            if (datavalue == 1) {
                [self showToast:@"验证码已发送"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToast:@"获取失败，请检查网络"];
    }];
    
    timerindex = 60;
    [codeButton setUserInteractionEnabled:NO];
    codeTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerStart) userInfo:nil repeats:NO];
}

- (void)timerStart
{
    if (timerindex > 0) {
        [codeButton setTitleColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0] forState:UIControlStateNormal];
        [codeButton setTitle:[NSString stringWithFormat:@"重试（%d）", timerindex] forState:UIControlStateNormal];
        timerindex--;
        codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:NO];
    } else {
        [codeButton setTitleColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0] forState:UIControlStateNormal];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeButton setUserInteractionEnabled:YES];
        [codeTimer invalidate];
        codeTimer = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    if (!keyBoardShowing) {
        return YES;
    }
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
    [textField resignFirstResponder];
    return YES;
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

- (void)onLoginButtonClicked
{
    [self hideKeyboard];
    if (JDOIsEmptyString(nameField.text)) {
        [self showToast:@"请输入联系人姓名"];
        return;
    }
    if (JDOIsEmptyString(telField.text)) {
        [self showToast:@"请输入联系电话"];
        return;
    }
    if (JDOIsEmptyString(codeField.text)) {
        [self showToast:@"请输入验证码"];
        return;
    }
    if (codeField.text.length != 4) {
        [self showToast:@"验证码错误"];
        return;
    }
    if (![JDHXLUtil isMobileNumber:[telField text]]) {
        [self showToast:@"电话号码有误"];
        return;
    }
    
    JDOHttpClient *httpclient = [JDOHttpClient sharedClient];
    NSDictionary *params = @{@"nick_name" : nameField.text, @"tel" : telField.text, @"code" : codeField.text};
    [httpclient getPath:LOGIN parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = [(NSData *)responseObject objectFromJSONData];
        id jsonvalue = [json objectForKey:@"data"];
        if ([jsonvalue isKindOfClass:[NSNumber class]]) {
            int datavalue = [(NSNumber *)jsonvalue integerValue];
            if (datavalue == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"user_info"];
                [self getUserInfoFromNetWork];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToast:@"获取失败，请检查网络"];
    }];
}

- (void)getUserInfoFromNetWork
{
    [centerView removeFromSuperview];
    
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    NSDictionary *params = @{@"id": @"1", @"tel" : [user_info objectForKey:@"tel"]};
    // 加载用户信息
    [[JDOHttpClient sharedClient] getJSONByServiceName:USER_INFO modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        DCKeyValueObjectMapping *mapper = [DCKeyValueObjectMapping mapperForClass:[JDUserModel class]];
        self.userModel = [mapper parseDictionary:dataModel.data];
        [self setNetworkState:NETWORK_STATE_NORMAL];
        [self setUpUserView:user_info];
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
}

//处理UIScrollView自动偏移问题
- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)setUpUserView:(NSDictionary *)params
{
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    userView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 5.0, 320.0, self.contentView.frame.size.height - 5.0)];
    [userView setContentSize:CGSizeMake(320.0, 470.0)];
    [userView setBackgroundColor:[UIColor clearColor]];
    [userView setShowsVerticalScrollIndicator:NO];
    [self.contentView addSubview:userView];
    
    //用户信息项
    userinfoView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 100.0)];
    [userinfoView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_bg"]]];
    userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 23.0, 55.0, 55.0)];
    if (self.userModel.headPic && self.userModel.headPic.length > 0) {
        UIImageView *blockImageView = userImage;
        [userImage setImageWithURL:[NSURL URLWithString:self.userModel.headPic] placeholderImage:[UIImage imageNamed:@"user_image_default"] options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
            if(!cached){    // 非缓存加载时使用渐变动画
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [blockImageView.layer addAnimation:transition forKey:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    [userinfoView addSubview:userImage];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 25.0, 200.0, 25.0)];
    [userName setBackgroundColor:[UIColor clearColor]];
    [userName setFont:[UIFont systemFontOfSize:16.0]];
    [userName setTextColor:[UIColor whiteColor]];
    [userName setTextAlignment:NSTextAlignmentLeft];
    [userName setText:[params objectForKey:@"nick_name"]];
    [userinfoView addSubview:userName];
    
    userTel = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 50.0, 200.0, 25.0)];
    [userTel setBackgroundColor:[UIColor clearColor]];
    [userTel setFont:[UIFont systemFontOfSize:16.0]];
    [userTel setTextColor:[UIColor whiteColor]];
    [userTel setTextAlignment:NSTextAlignmentLeft];
    [userTel setText:[params objectForKey:@"tel"]];
    [userinfoView addSubview:userTel];
    
    [userView addSubview:userinfoView];
    
    //当前订单项
    currentOrderView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 125.0, 300.0, 100.0)];
    [currentOrderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_item_bg"]]];
    currentTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 200.0, 25.0)];
    [currentTitle setBackgroundColor:[UIColor clearColor]];
    [currentTitle setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [currentTitle setTextAlignment:NSTextAlignmentLeft];
    [currentTitle setFont:[UIFont systemFontOfSize:20.0]];
    [currentTitle setText:[NSString stringWithFormat:@"我的预定(%@)", self.userModel.currentOrderCount]];
    [currentOrderView addSubview:currentTitle];
    
    currentHotel= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 52.0, 135.0, 20.0)];
    [currentHotel setBackgroundColor:[UIColor clearColor]];
    [currentHotel setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [currentHotel setTextAlignment:NSTextAlignmentLeft];
    [currentHotel setFont:[UIFont systemFontOfSize:15.0]];
    [currentHotel setText:self.userModel.currentOrderHotel];
    [currentOrderView addSubview:currentHotel];
    
    currentDetail= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 72.0, 170.0, 20.0)];
    [currentDetail setBackgroundColor:[UIColor clearColor]];
    [currentDetail setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [currentDetail setTextAlignment:NSTextAlignmentLeft];
    [currentDetail setFont:[UIFont systemFontOfSize:15.0]];
    [currentDetail setText:self.userModel.currentOrderDetail];
    [currentOrderView addSubview:currentDetail];
    
    currentDate= [[UILabel alloc] initWithFrame:CGRectMake(150.0, 52.0, 135.0, 20.0)];
    [currentDate setBackgroundColor:[UIColor clearColor]];
    [currentDate setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [currentDate setTextAlignment:NSTextAlignmentRight];
    [currentDate setFont:[UIFont systemFontOfSize:15.0]];
    [currentDate setText:[JDHXLUtil formatDate:[JDHXLUtil formatString:self.userModel.currentOrderDate withFormatter:DateFormatMDY] withFormatter:DateFormatYMD]];
    [currentOrderView addSubview:currentDate];
    
    currentMore= [[UILabel alloc] initWithFrame:CGRectMake(185.0, 72.0, 100.0, 20.0)];
    [currentMore setBackgroundColor:[UIColor clearColor]];
    [currentMore setTextColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    [currentMore setTextAlignment:NSTextAlignmentRight];
    [currentMore setFont:[UIFont systemFontOfSize:14.0]];
    [currentMore setText:@"查看详情"];
    [currentOrderView addSubview:currentMore];
    
    UITapGestureRecognizer *currentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentViewTapped)];
    [currentOrderView setUserInteractionEnabled:YES];
    [currentOrderView addGestureRecognizer:currentTap];
    [userView addSubview:currentOrderView];
    
    if ((!self.userModel.currentOrderCount)||([self.userModel.currentOrderCount isEqualToString:@"0"])) {
        [currentTitle setText:@"我的预定(0)"];
        [currentDate setHidden:YES];
        [currentDetail setHidden:YES];
        [currentHotel setHidden:YES];
        [currentMore setHidden:YES];
        [currentOrderView setUserInteractionEnabled:NO];
    } else {
        [currentTitle setText:[NSString stringWithFormat:@"我的预定(%@)", self.userModel.currentOrderCount]];
        [currentDate setHidden:NO];
        [currentDetail setHidden:NO];
        [currentHotel setHidden:NO];
        [currentMore setHidden:NO];
        [currentOrderView setUserInteractionEnabled:YES];
    }
    
    //历史订单项
    historyOrderView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 240.0, 300.0, 100.0)];
    [historyOrderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_item_bg"]]];
    historyTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 200.0, 25.0)];
    [historyTitle setBackgroundColor:[UIColor clearColor]];
    [historyTitle setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [historyTitle setTextAlignment:NSTextAlignmentLeft];
    [historyTitle setFont:[UIFont systemFontOfSize:20.0]];
    [historyTitle setText:[NSString stringWithFormat:@"历史订单(%@)", self.userModel.historyOrderCount]];
    [historyOrderView addSubview:historyTitle];
    
    historyHotel= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 52.0, 135.0, 20.0)];
    [historyHotel setBackgroundColor:[UIColor clearColor]];
    [historyHotel setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [historyHotel setTextAlignment:NSTextAlignmentLeft];
    [historyHotel setFont:[UIFont systemFontOfSize:15.0]];
    [historyHotel setText:self.userModel.historyOrderHotel];
    [historyOrderView addSubview:historyHotel];
    
    historyDetail= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 72.0, 170.0, 20.0)];
    [historyDetail setBackgroundColor:[UIColor clearColor]];
    [historyDetail setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [historyDetail setTextAlignment:NSTextAlignmentLeft];
    [historyDetail setFont:[UIFont systemFontOfSize:15.0]];
    [historyDetail setText:self.userModel.historyOrderDetail];
    [historyOrderView addSubview:historyDetail];
    
    historyDate= [[UILabel alloc] initWithFrame:CGRectMake(150.0, 52.0, 135.0, 20.0)];
    [historyDate setBackgroundColor:[UIColor clearColor]];
    [historyDate setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [historyDate setTextAlignment:NSTextAlignmentRight];
    [historyDate setFont:[UIFont systemFontOfSize:15.0]];
    [historyDate setText:[JDHXLUtil formatDate:[JDHXLUtil formatString:self.userModel.historyOrderDate withFormatter:DateFormatMDY] withFormatter:DateFormatYMD]];
    [historyOrderView addSubview:historyDate];
    
    historyMore= [[UILabel alloc] initWithFrame:CGRectMake(185.0, 72.0, 100.0, 20.0)];
    [historyMore setBackgroundColor:[UIColor clearColor]];
    [historyMore setTextColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    [historyMore setTextAlignment:NSTextAlignmentRight];
    [historyMore setFont:[UIFont systemFontOfSize:14.0]];
    [historyMore setText:@"查看详情"];
    [historyOrderView addSubview:historyMore];
    
    UITapGestureRecognizer *historyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyViewTapped)];
    [historyOrderView setUserInteractionEnabled:YES];
    [historyOrderView addGestureRecognizer:historyTap];
    [userView addSubview:historyOrderView];
    
    if ((!self.userModel.historyOrderCount)||([self.userModel.historyOrderCount isEqualToString:@"0"])) {
        [historyTitle setText:@"历史订单(0)"];
        [historyDate setHidden:YES];
        [historyDetail setHidden:YES];
        [historyHotel setHidden:YES];
        [historyMore setHidden:YES];
        [historyOrderView setUserInteractionEnabled:NO];
    } else {
        [historyTitle setText:[NSString stringWithFormat:@"历史订单(%@)", self.userModel.historyOrderCount]];
        [historyDate setHidden:NO];
        [historyDetail setHidden:NO];
        [historyHotel setHidden:NO];
        [historyMore setHidden:NO];
        [historyOrderView setUserInteractionEnabled:YES];
    }
    
    //积分项
    scoreView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 355.0, 300.0, 100.0)];
    [scoreView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_item_bg"]]];
    
    scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 200.0, 25.0)];
    [scoreTitle setBackgroundColor:[UIColor clearColor]];
    [scoreTitle setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [scoreTitle setTextAlignment:NSTextAlignmentLeft];
    [scoreTitle setFont:[UIFont systemFontOfSize:20.0]];
    [scoreTitle setText:[NSString stringWithFormat:@"我的积分(%@)", self.userModel.scoreTotal]];
    [scoreView addSubview:scoreTitle];
    
    scoreDate1= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 52.0, 135.0, 20.0)];
    [scoreDate1 setBackgroundColor:[UIColor clearColor]];
    [scoreDate1 setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [scoreDate1 setTextAlignment:NSTextAlignmentLeft];
    [scoreDate1 setFont:[UIFont systemFontOfSize:15.0]];
    [scoreDate1 setText:[JDHXLUtil formatDate:[JDHXLUtil formatString:self.userModel.scoreDate1 withFormatter:DateFormatMDY] withFormatter:DateFormatYMD]];
    [scoreView addSubview:scoreDate1];
    
    scoreDate2= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 72.0, 135.0, 20.0)];
    [scoreDate2 setBackgroundColor:[UIColor clearColor]];
    [scoreDate2 setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [scoreDate2 setTextAlignment:NSTextAlignmentLeft];
    [scoreDate2 setFont:[UIFont systemFontOfSize:15.0]];
    [scoreDate2 setText:[JDHXLUtil formatDate:[JDHXLUtil formatString:self.userModel.scoreDate2 withFormatter:DateFormatMDY] withFormatter:DateFormatYMD]];
    [scoreView addSubview:scoreDate2];
    
    scoreNum1= [[UILabel alloc] initWithFrame:CGRectMake(150.0, 52.0, 135.0, 20.0)];
    [scoreNum1 setBackgroundColor:[UIColor clearColor]];
    [scoreNum1 setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [scoreNum1 setTextAlignment:NSTextAlignmentRight];
    [scoreNum1 setFont:[UIFont systemFontOfSize:15.0]];
    [scoreNum1 setText:[NSString stringWithFormat:@"积分:%@", self.userModel.scoreNum1]];
    [scoreView addSubview:scoreNum1];
    
    scoreNum2= [[UILabel alloc] initWithFrame:CGRectMake(150.0, 72.0, 135.0, 20.0)];
    [scoreNum2 setBackgroundColor:[UIColor clearColor]];
    [scoreNum2 setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [scoreNum2 setTextAlignment:NSTextAlignmentRight];
    [scoreNum2 setFont:[UIFont systemFontOfSize:15.0]];
    [scoreNum2 setText:[NSString stringWithFormat:@"积分:%@", self.userModel.scoreNum2]];
    [scoreView addSubview:scoreNum2];
    
    if ((!self.userModel.scoreTotal)||([self.userModel.scoreTotal isEqualToString:@"0"])) {
        [scoreTitle setText:@"我的积分(0)"];
        [scoreDate1 setHidden:YES];
        [scoreDate2 setHidden:YES];
        [scoreNum1 setHidden:YES];
        [scoreNum2 setHidden:YES];
    } else {
        [scoreTitle setText:[NSString stringWithFormat:@"我的积分(%@)", self.userModel.scoreTotal]];
        [scoreDate1 setHidden:NO];
        [scoreDate2 setHidden:NO];
        [scoreNum1 setHidden:NO];
        [scoreNum2 setHidden:NO];
    }
    
    [userView addSubview:scoreView];
}

- (void)currentViewTapped
{
    JDCurrentOrdersController *currentOrders = [[JDCurrentOrdersController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:currentOrders animated:YES];
}

- (void)historyViewTapped
{
    JDHistoryOrdersController *historyOrders = [[JDHistoryOrdersController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:historyOrders animated:YES];
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

- (void)viewWillDisappear:(BOOL)animated
{
    if (codeTimer) {
        [codeTimer invalidate];
        codeTimer = nil;
    }
}

@end
