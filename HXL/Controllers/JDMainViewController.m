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
    self.currentSelectedCount = 0;
    [self setNavigationTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title"]]];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"user_btn_bg"] Target:self Action:@selector(onUserButtonClicked)];
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *params = @{@"id": @"1"};
    // 加载酒店信息
    [[JDOHttpClient sharedClient] getJSONByServiceName:HOTEL_INFO_SERVICE modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        DCKeyValueObjectMapping *mapper = [DCKeyValueObjectMapping mapperForClass:[JDHotelModel class]];
        self.hotelModel = [mapper parseDictionary:dataModel.data];
        self.hotelModel.hotel_id = [[params objectForKey:@"id"] integerValue];
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
    [self setupCountSelectView];
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
    UITapGestureRecognizer *tapGestureAddr1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddrClicked)];
    UITapGestureRecognizer *tapGestureAddr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddrClicked)];
    [addricon setUserInteractionEnabled:YES];
    [addrlabel setUserInteractionEnabled:YES];
    [addricon addGestureRecognizer:tapGestureAddr1];
    [addrlabel addGestureRecognizer:tapGestureAddr2];
    
    [whiteCenter addSubview:addricon];
    [whiteCenter addSubview:addrlabel];
    
    UIImageView *telicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telephone_icon"]];
    UILabel *tellabel = [[UILabel alloc] init];
    [tellabel setText:self.hotelModel.tel];
    [tellabel setFont:[UIFont systemFontOfSize:16.0]];
    [tellabel sizeToFit];
    [telicon setFrame:CGRectMake((320.0-tellabel.frame.size.width-25.0)/2, 42.0, 20.0, 20.0)];
    [tellabel setFrame:CGRectMake(telicon.frame.origin.x + telicon.frame.size.width + 5.0, 44.0, tellabel.frame.size.width, 20.0)];
    UITapGestureRecognizer *tapGestureTel1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTelClicked)];
    UITapGestureRecognizer *tapGestureTel2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTelClicked)];
    [telicon setUserInteractionEnabled:YES];
    [tellabel setUserInteractionEnabled:YES];
    [telicon addGestureRecognizer:tapGestureTel1];
    [tellabel addGestureRecognizer:tapGestureTel2];
    
    [whiteCenter addSubview:telicon];
    [whiteCenter addSubview:tellabel];
    
    [self.contentView addSubview:addrAndTelView];
}

- (void)onTelClicked
{
    NSString *phoneNum = @"";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (void)onAddrClicked
{
    
}

- (void)setupCountSelectView
{
	CGRect tmpFrame = CGRectMake(0.0, centerScrollView.frame.size.height - 36.0, 320.0, 36.0);

	self.pickerView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
	self.pickerView.backgroundColor   = [UIColor colorWithPatternImage:[UIImage imageNamed:@"count_bg"]];
	self.pickerView.selectedTextColor = [UIColor whiteColor];
	self.pickerView.textColor   = [UIColor grayColor];
	self.pickerView.delegate    = self;
	self.pickerView.dataSource  = self;
	self.pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	self.pickerView.selectionPoint = CGPointMake(160, 0);
    
	// add carat or other view to indicate selected element
	indicator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 61.0, 61.0)];
    [indicator setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"indicator_1"]]];
    indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 41.0, 41.0)];
    [indicatorLabel setBackgroundColor:[UIColor clearColor]];
    [indicatorLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [indicatorLabel setTextColor:[UIColor whiteColor]];
    [indicatorLabel setTextAlignment:NSTextAlignmentCenter];
    [indicatorLabel setText:[NSString stringWithFormat:@"%d", 0]];
    [indicator addSubview:indicatorLabel];
    
    selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, centerScrollView.frame.size.height - 36.0 + 8.0, 120.0, 20.0)];
    [selectLabel setBackgroundColor:[UIColor clearColor]];
    [selectLabel setText:@"滑动选择就餐人数"];
    [selectLabel setFont:[UIFont systemFontOfSize:14.0]];
    [selectLabel setTextColor:[UIColor whiteColor]];
    [selectLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:selectLabel];
    
    self.pickerView.selectionIndicatorView = indicator;
    [self.pickerView setIndicatorPosition:V8HorizontalPickerIndicatorCenter];
    
    [self.contentView addSubview:self.pickerView];
    [self.pickerView scrollToElement:0 animated:NO];
}

- (void)setupBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, addrAndTelView.frame.origin.y + 96.0, 320.0, 49.0)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
    [self.contentView addSubview:bottomView];
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake(113.0, 10.0, 94.0, 29.0)];
    [startButton setImage:[UIImage imageNamed:@"start_btn_bg_1"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(onStartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [startButton setUserInteractionEnabled:NO];
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
    menuController.people = [_pickerView currentSelectedIndex];
    menuController.hotelModel = self.hotelModel;
    [self.navigationController pushViewController:menuController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker
{
    return self.hotelModel.max + 1;
}

- (NSInteger)horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index
{
    return 36.0;
}

- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, 36.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"%d", index]];
    [label setTextColor:[UIColor grayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15.0]];
    
    return label;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker currentSelectingElementAtIndex:(NSInteger)index
{
    if (index != 0) {
        [selectLabel setHidden:YES];
        [bottomView setBackgroundColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
        [startButton setUserInteractionEnabled:YES];
    } else {
        [selectLabel setHidden:NO];
        [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
        [startButton setUserInteractionEnabled:NO];
    }
    self.currentSelectedCount = index;
    [indicatorLabel setText:[NSString stringWithFormat:@"%d", index]];
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
    if (index != 0) {
        [selectLabel setHidden:YES];
        [bottomView setBackgroundColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
        [startButton setUserInteractionEnabled:YES];
    } else {
        [selectLabel setHidden:NO];
        [bottomView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
        [startButton setUserInteractionEnabled:NO];
    }
    
    self.currentSelectedCount = index;
    [indicatorLabel setText:[NSString stringWithFormat:@"%d", index]];
}

@end
