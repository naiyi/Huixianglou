//
//  JDCurrentOrderTableViewCell.m
//  HXL
//
//  Created by Roc on 14-6-27.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDCurrentOrderTableViewCell.h"

@implementation JDCurrentOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.centerView = [[UIView alloc] init];
        self.orderImage = [[UIImageView alloc] init];
        self.orderTitle = [[UILabel alloc] init];
        self.orderTime = [[UILabel alloc] init];
        self.orderDail = [[UIImageView alloc] init];
        self.orderDetail = [[UILabel alloc] init];
        self.orderState = [[UIImageView alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.centerView setFrame:CGRectMake(10.0, 7.5, 300.0, 65.0)];
    [self.centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"current_order_item_bg"]]];
    [self addSubview:self.centerView];
    
    [self.orderImage setFrame:CGRectMake(5.0, 5.0, 55.0, 55.0)];
    [self.orderImage setImage:[UIImage imageNamed:@"hotel_bg"]];
    [self.centerView addSubview:self.orderImage];
    
    [self.orderTitle setFont:[UIFont systemFontOfSize:17.0]];
    [self.orderTitle setTextAlignment:NSTextAlignmentLeft];
    [self.orderTitle setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [self.orderTitle setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderTitle];
    
    [self.orderTime setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderTime setTextAlignment:NSTextAlignmentLeft];
    [self.orderTime setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [self.orderTime setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderTime];
    
    [self.orderDetail setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderDetail setTextAlignment:NSTextAlignmentLeft];
    [self.orderDetail setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [self.orderDetail setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderDetail];
    
    [self.orderState setBackgroundColor:[UIColor clearColor]];
    [self.orderState setFrame:CGRectMake(260.0, 0.0, 40.0, 65.0)];
    UITapGestureRecognizer *tapGestureTel1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStateClicked)];
    [self.orderState addGestureRecognizer:tapGestureTel1];
    [self.centerView addSubview:self.orderState];
    
    [self.orderDail setBackgroundColor:[UIColor clearColor]];
    [self.orderDail setFrame:CGRectMake(235.0, 22.0, 20.0, 20.0)];
    [self.orderDail setImage:[UIImage imageNamed:@"telephone_icon"]];
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTelClicked)];
    [self.orderDail setUserInteractionEnabled:YES];
    [self.orderDail addGestureRecognizer:tapGestureTel];
    
    [self.centerView addSubview:self.orderDail];
}

- (void)onTelClicked
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.tel]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (void)setModel:(JDOrderModel *)model andTel:(NSString *)tel
{
    self.orderModel = model;
    self.tel = tel;
    CGSize size = [model.hotel sizeWithFont:[UIFont systemFontOfSize:17.0]];
    [self.orderTitle setFrame:CGRectMake(65.0, 32.0 - size.height, size.width, size.height)];
    [self.orderTitle setText:model.hotel];
    
    NSString *time = [[NSString alloc] initWithFormat:@"(%@ %@)", [[JDHXLUtil formatDate:[JDHXLUtil formatString:model.date withFormatter:DateFormatMDY] withFormatter:DateFormatYMD] substringFromIndex:5], [model.time substringToIndex:5]];
    size = [time sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [self.orderTime setFrame:CGRectMake(70.0 + self.orderTitle.frame.size.width, 32.0 - size.height, size.width, size.height)];
    [self.orderTime setText:time];
    
    size = [model.detail sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [self.orderDetail setFrame:CGRectMake(65.0, 38.0, size.width, size.height)];
    [self.orderDetail setText:model.detail];
    
    if ([self.orderModel.status integerValue] == 0) {
        [self.orderState setImage:[UIImage imageNamed:@"cancel_order"]];
        [self.orderState setUserInteractionEnabled:YES];
    } else if ([self.orderModel.status integerValue] == 5) {
        [self.orderState setImage:[UIImage imageNamed:@"commit_order"]];
        [self.orderState setUserInteractionEnabled:NO];
    }
    
    if (model.hotel_mpic && model.hotel_mpic.length > 0) {
        UIImageView *blockImageView = self.orderImage;
        [self.orderImage setImageWithURL:[NSURL URLWithString:model.hotel_mpic] placeholderImage:[UIImage imageNamed:@"hotel_bg"] options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
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
}

- (void)onStateClicked
{
    if ([self.orderModel.status integerValue] == 0) {
        NSDictionary *params = @{@"tel" : [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] objectForKey:@"tel"], @"order_id" : self.orderModel.order_id};
        JDOHttpClient *httpclient = [JDOHttpClient sharedClient];
        [httpclient getPath:CANCEL_ORDER parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *json = [(NSData *)responseObject objectFromJSONData];
            int jsonvalue = [[json objectForKey:@"data"] integerValue];
            if (jsonvalue == 1) {
                [self showToast:@"订单取消成功"];
                [self.controller reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
    }
}

- (void)showToast:(NSString *)message
{
    iToast *toast = [iToast makeText:message];
    [toast setDuration:3000];
    [toast setGravity:iToastGravityBottom];
    [toast show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
