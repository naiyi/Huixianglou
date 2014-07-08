//
//  JDCurrentOrderTableViewCell.m
//  HXL
//
//  Created by Roc on 14-6-27.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHistoryOrderTableViewCell.h"

@implementation JDHistoryOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.orderImage = [[UIImageView alloc] init];
        self.orderState = [[UILabel alloc] init];
        self.orderTitle = [[UILabel alloc] init];
        self.orderName = [[UILabel alloc] init];
        self.orderTime = [[UILabel alloc] init];
        self.orderDetail = [[UILabel alloc] init];
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 80.0)];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.centerView];
    
    [self.orderImage setFrame:CGRectMake(240.0, 5.0, 55.0, 55.0)];
    [self.orderImage setImage:[UIImage imageNamed:@"hotel_bg"]];
    [self.centerView addSubview:self.orderImage];
    
    [self.orderTitle setFont:[UIFont systemFontOfSize:17.0]];
    [self.orderTitle setTextAlignment:NSTextAlignmentLeft];
    [self.orderTitle setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [self.orderTitle setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderTitle];
    
    [self.orderTime setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderTime setTextAlignment:NSTextAlignmentLeft];
    [self.orderTime setTextColor:[UIColor whiteColor]];
    [self.orderTime setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderTime];
    
    [self.orderName setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderName setTextAlignment:NSTextAlignmentCenter];
    [self.orderName setTextColor:[UIColor whiteColor]];
    [self.orderName setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderName];
    
    [self.orderState setFont:[UIFont systemFontOfSize:12.0]];
    [self.orderState setTextAlignment:NSTextAlignmentCenter];
    [self.orderState setTextColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    [self.orderState setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"order_state_bg"]]];
    [self.centerView addSubview:self.orderState];
    
    [self.orderDetail setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderDetail setTextAlignment:NSTextAlignmentLeft];
    [self.orderDetail setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [self.orderDetail setBackgroundColor:[UIColor clearColor]];
    [self.centerView addSubview:self.orderDetail];
}

- (void)setModel:(JDOrderModel *)model andBG:(int)index
{
    if (index == 1) {
        [self.centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"history_bg2"]]];
    } else {
        [self.centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"history_bg"]]];
    }
    
    self.orderModel = model;
    CGSize size = [model.hotel sizeWithFont:[UIFont systemFontOfSize:17.0]];
    [self.orderTitle setFrame:CGRectMake(80.0, 32.0 - size.height, size.width, size.height)];
    [self.orderTitle setText:model.hotel];
    
    NSString *time = [[JDHXLUtil formatDate:[JDHXLUtil formatString:model.date withFormatter:DateFormatMDY] withFormatter:DateFormatYMD] substringFromIndex:5];
    
    size = [time sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [self.orderTime setFrame:CGRectMake(1.0, 15.0, size.width, size.height)];
    [self.orderTime setText:time];
    
    [self.orderName setFrame:CGRectMake(1.0, 30.0, 38.0, 21.0)];
    [self.orderName setText:model.diner_name];
    
    [self.orderState setFrame:CGRectMake(self.orderTitle.frame.size.width + 90.0, 15.0, 49.0, 14.0)];
    if ([model.status isEqualToString:@"0"]) {
        [self.orderState setText:@"等待确认"];
    } else if ([model.status isEqualToString:@"1"]) {
        [self.orderState setText:@"用户取消"];
    } else if ([model.status isEqualToString:@"2"]) {
        [self.orderState setText:@"商家取消"];
    } else if ([model.status isEqualToString:@"3"]) {
        [self.orderState setText:@"消费完成"];
    } else if ([model.status isEqualToString:@"5"]) {
        [self.orderState setText:@"预定成功"];
    }
    
    size = [model.detail sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [self.orderDetail setFrame:CGRectMake(80.0, 38.0, size.width, size.height)];
    [self.orderDetail setText:model.detail];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
