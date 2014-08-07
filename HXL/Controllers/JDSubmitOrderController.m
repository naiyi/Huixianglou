//
//  JDSubmitOrderController.m
//  HXL
//
//  Created by Roc on 14-6-30.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDSubmitOrderController.h"
#import "JDUserViewController.h"
#import "JDDishModel.h"

@interface JDSubmitOrderController ()

@end

@implementation JDSubmitOrderController

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
    [self setNavigationTitle:@"提交订单"];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    
    timeArray = [self getDinnerTime];
    
    dateArray = [[NSMutableArray alloc] initWithArray:@[@"今天", @"明天", @"后天"]];
    lastTime = [self getLastTime];
    if ([lastTime compare:[NSDate date]] == NSOrderedAscending) {
        [dateArray removeObjectAtIndex:0];
    }
    
    [self setNetworkState:NETWORK_STATE_NORMAL];
}

- (NSMutableArray *)getDinnerTime
{
    NSMutableArray *times = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.hotelModel.time.count; i++) {
        NSDate *start_time = [JDHXLUtil formatString:[[self.hotelModel.time objectAtIndex:i] objectForKey:@"start_time"] withFormatter:DateFormatHM];
        NSDate *end_time = [JDHXLUtil formatString:[[self.hotelModel.time objectAtIndex:i] objectForKey:@"end_time"] withFormatter:DateFormatHM];
        int interval = [[[self.hotelModel.time objectAtIndex:i] objectForKey:@"interval"] integerValue] * 60;
        NSDate *date = start_time;
        while ([date compare:end_time] == NSOrderedAscending) {
            [times addObject:[NSString stringWithFormat:@"%@-%@", [JDHXLUtil formatDate:date withFormatter:DateFormatHM], [JDHXLUtil formatDate:[NSDate dateWithTimeInterval:interval sinceDate:date] withFormatter:DateFormatHM]]];
            date = [NSDate dateWithTimeInterval:interval sinceDate:date];
        }
    }
    return times;
}

- (NSDate *)getLastTime
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    
    NSString *lastString = [NSString stringWithFormat:@"%d/%d/%d %@", year, month, day, [[self.hotelModel.time objectAtIndex:0] objectForKey:@"end_time"]];
    
    NSDate *last = [JDHXLUtil formatString:lastString withFormatter:DateFormatYMDHM];
    for (int i = 1; i < self.hotelModel.time.count; i++) {
        NSString *tempSting = [NSString stringWithFormat:@"%d/%d/%d %@", year, month, day, [[self.hotelModel.time objectAtIndex:i] objectForKey:@"end_time"]];
        NSDate *temp = [JDHXLUtil formatString:tempSting withFormatter:DateFormatYMDHM];
        switch ([last compare:temp]) {
            case NSOrderedAscending:
                last = temp;
                break;
            default:
                break;
        }
    }
    
    return last;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    [nameEdit setText:[user_info objectForKey:@"nick_name"]];
}

- (void)setContentView
{
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 14.0, 300.0, self.contentView.frame.size.height - 24.0 - 49.0)];
    [centerView setUserInteractionEnabled:YES];
    [centerView setImage:[UIImage imageNamed:@"login_bg"]];
    [centerView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [centerView addGestureRecognizer:tapGesture];
    [self.contentView addSubview:centerView];
    
    [self setupBottomView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 75.0, 40.0)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:17.0]];
    [nameLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setText:@"当前用户"];
    [centerView addSubview:nameLabel];
    
    nameEdit = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 0.0, 165.0, 40.0)];
    [nameEdit setBackgroundColor:[UIColor clearColor]];
    [nameEdit setFont:[UIFont systemFontOfSize:17.0]];
    [nameEdit setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [nameEdit setTextAlignment:NSTextAlignmentLeft];
    [nameEdit setText:[user_info objectForKey:@"nick_name"]];
    [centerView addSubview:nameEdit];
    
    UIButton *changeUser = [[UIButton alloc] initWithFrame:CGRectMake(255.0, 10.0, 35.0, 20.0)];
    [changeUser setBackgroundColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    [changeUser setTitle:@"切换" forState:UIControlStateNormal];
    [changeUser setTintColor:[UIColor whiteColor]];
    [[changeUser titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    [changeUser addTarget:self action:@selector(onChangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:changeUser];
    
    UIImageView *divider1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 40.0, 300.0, 1.0)];
    [divider1 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider1];
    
    UILabel *roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 40.0, 105.0, 55.0)];
    [roomLabel setBackgroundColor:[UIColor clearColor]];
    [roomLabel setFont:[UIFont systemFontOfSize:17.0]];
    [roomLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [roomLabel setTextAlignment:NSTextAlignmentLeft];
    [roomLabel setText:@"选择就餐环境"];
    [centerView addSubview:roomLabel];
    
    self.currentSelectedRoom = @"0";
    room_yes = [[UIButton alloc] initWithFrame:CGRectMake(120.0, 50.0, 80.0, 35.0)];
    room_no = [[UIButton alloc] initWithFrame:CGRectMake(210.0, 50.0, 80.0, 35.0)];
    [room_yes setBackgroundImage:[UIImage imageNamed:@"tab2"] forState:UIControlStateNormal];
    [room_yes setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateSelected];
    [room_yes setTitle:@"包间" forState:UIControlStateNormal];
    [room_yes addTarget:self action:@selector(onRoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [room_no setBackgroundImage:[UIImage imageNamed:@"tab2"] forState:UIControlStateNormal];
    [room_no setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateSelected];
    [room_no setTitle:@"不限" forState:UIControlStateNormal];
    [room_no addTarget:self action:@selector(onRoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [room_yes setSelected:NO];
    [room_no setSelected:YES];
    [centerView addSubview:room_yes];
    [centerView addSubview:room_no];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 95.0, 300.0, 35.0)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:19.0]];
    [timeLabel setTextColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    [timeLabel setText:@"请选择就餐时间"];
    [centerView addSubview:timeLabel];
    
    dateSelector = [[IZValueSelectorView alloc] initWithFrame:CGRectMake(10.0, 140.0, 140.0, 120.0)];
    [dateSelector setDataSource:self];
    [dateSelector setDelegate:self];
    [centerView addSubview:dateSelector];
    
    timeSelector = [[IZValueSelectorView alloc] initWithFrame:CGRectMake(160.0, 140.0, 140.0, 120.0)];
    [timeSelector setDataSource:self];
    [timeSelector setDelegate:self];
    [centerView addSubview:timeSelector];
    
    UIImageView *divider3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 180.0, 300.0, 1.0)];
    [divider3 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider3];
    
    UIImageView *divider4 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 220.0, 300.0, 1.0)];
    [divider4 setImage:[UIImage imageNamed:@"divider"]];
    [centerView addSubview:divider4];

    UIImageView *divider2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 140.0, 300.0, 30.0)];
    UIImageView *divider5 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 230.0, 300.0, 30.0)];
    [divider2 setImage:[UIImage imageNamed:@"upshadow"]];
    [divider5 setImage:[UIImage imageNamed:@"downshadow"]];
    [centerView addSubview:divider2];
    [centerView addSubview:divider5];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 275.0, 55.0, 60.0)];
    [moreLabel setBackgroundColor:[UIColor clearColor]];
    [moreLabel setTextAlignment:NSTextAlignmentLeft];
    [moreLabel setFont:[UIFont systemFontOfSize:17.0]];
    [moreLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [moreLabel setText:@"备注："];
    [centerView addSubview:moreLabel];
    
    moreField = [[UITextView alloc] initWithFrame:CGRectMake(60.0, 275.0, 230.0, 60.0)];
    moreField.layer.cornerRadius = 2;//设置视图圆角
    moreField.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    moreField.layer.borderColor = cgColor;
    moreField.layer.borderWidth = 1.0;
    [moreField setTextColor:[UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:1.0]];
    [moreField setFont:[UIFont systemFontOfSize:17.0]];
    [moreField setDelegate:self];
    [centerView addSubview:moreField];
    
    self.currentSelectedDate = @"0";
    self.currentSelectedTime = [[NSString alloc] initWithString:[timeArray objectAtIndex:0]];
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 49.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [submitButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_btn_bg_r"]]];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setUserInteractionEnabled:YES];
    [bottomView addSubview:submitButton];
    [self.contentView addSubview:bottomView];
}

- (void)onSubmitButtonClicked
{
    int p = 0;
    for (int i = 0; i < self.orderedDishes.count; i++) {
        JDDishModel *dish = ((JDDishModel *)[self.orderedDishes objectAtIndex:i]);
        p += dish.price_show * dish.count;
    }
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d", self.hotelModel.hotel_id] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%d", self.people] forKey:@"people"];
    [params setObject:[user_info objectForKey:@"nick_name"] forKey:@"name"];
    [params setObject:[user_info objectForKey:@"tel"] forKey:@"tel"];
    [params setObject:self.currentSelectedDate forKey:@"date"];
    [params setObject:self.currentSelectedTime forKey:@"time"];
    [params setObject:self.currentSelectedRoom forKey:@"room"];
    [params setObject:[NSString stringWithFormat:@"%d", p] forKey:@"price"];
    if (moreField.text) {
        [params setObject:[moreField text] forKey:@"remark"];
    }
    
    NSMutableString *dishString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.orderedDishes.count; i++) {
        JDDishModel *model = [self.orderedDishes objectAtIndex:i];
        [dishString appendFormat:@"%d_%d", model.id, model.count];
        
        if(model.price_type == 1) {
            [dishString appendFormat:@"_%d", model.checked_weight];
        } else if(model.price_type == 2){
            [dishString appendFormat:@"_%d", [[[model.price_list objectAtIndex:model.checked_fenliang] objectForKey:@"price"] integerValue]];
        } else {
            [dishString appendString:@"_0"];
        }
        [dishString appendString:@"-"];
    }
    [params setObject:dishString forKey:@"dish"];
    
    [[JDOHttpClient sharedClient] getJSONByServiceName:CREATE_ORDER modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        if ([(NSNumber *)dataModel.status integerValue] == 0) {
            [self showToast:@"订单提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSString *errorStr) {
        [self showToast:@"订单提交失败，请检查网络"];
    }];
}

- (void)onChangeButtonClicked
{
    JDUserViewController *userController = [[JDUserViewController alloc] initWithNibName:nil bundle:nil];
    userController.hotelModel = self.hotelModel;
    userController.orderedDishes = self.orderedDishes;
    userController.backToOrderController = YES;
    [self.navigationController pushViewController:userController animated:YES];
}

- (void)onRoomButtonClicked:(UIButton *)sender
{
    if (sender == room_yes) {
        [room_yes setSelected:YES];
        [room_no setSelected:NO];
        self.currentSelectedRoom = @"1";
    } else {
        [room_yes setSelected:NO];
        [room_no setSelected:YES];
        self.currentSelectedRoom = @"0";
    }
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 140.0, 40.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    if (valueSelector == dateSelector) {
        [label setText:[dateArray objectAtIndex:index]];
    } else if (valueSelector == timeSelector) {
        [label setText:[timeArray objectAtIndex:index]];
    }
    
    return label;
}

- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector
{
    if (valueSelector == dateSelector) {
        return dateArray.count;
    } else {
        return timeArray.count;
    }
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 140.0;
}

- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector
{
    return 40.0;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    return CGRectMake(0.0, valueSelector.frame.size.height/2 - 20.0, 140.0, 40.0);
}

- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index
{
    if (valueSelector == dateSelector) {
        self.currentSelectedDate = [NSString stringWithFormat:@"%d", index];
    } else {
        self.currentSelectedTime = [timeArray objectAtIndex:index];
    }
}

- (void)hideKeyboard
{
    if (keyBoardShowing) {
        [moreField resignFirstResponder];
        
        CGRect frame = bottomView.frame;
        CGRect frame2 = centerView.frame;
        int offset = frame.origin.y + 216.0;//键盘高度216
        int offset2 = frame2.origin.y + 216.0;
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = bottomView.frame.size.width;
        float height = bottomView.frame.size.height;
        float width2 = centerView.frame.size.width;
        float height2 = centerView.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(0.0f, offset, width, height);
            CGRect rect2 = CGRectMake(10.0f, offset2, width2, height2);
            bottomView.frame = rect;
            centerView.frame = rect2;
        }
        [UIView commitAnimations];
        keyBoardShowing = NO;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyBoardShowing) {
        return;
    }
    CGRect frame = bottomView.frame;
    CGRect frame2 = centerView.frame;
    int offset = frame.origin.y - 216.0;//键盘高度216
    int offset2 = frame2.origin.y - 216.0;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = bottomView.frame.size.width;
    float height = bottomView.frame.size.height;
    float width2 = centerView.frame.size.width;
    float height2 = centerView.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, offset, width, height);
        CGRect rect2 = CGRectMake(10.0f, offset2, width2, height2);
        bottomView.frame = rect;
        centerView.frame = rect2;
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
