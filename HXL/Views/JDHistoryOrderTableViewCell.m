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
        self.orderTitle = [[UILabel alloc] init];
        self.orderTime = [[UILabel alloc] init];
        self.orderDetail = [[UILabel alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"history_bg"]]];
    
    [self.orderImage setFrame:CGRectMake(240.0, 5.0, 55.0, 55.0)];
    [self.orderImage setImage:[UIImage imageNamed:@"hotel_bg"]];
    [self addSubview:self.orderImage];
    
    [self.orderTitle setFont:[UIFont systemFontOfSize:17.0]];
    [self.orderTitle setTextAlignment:NSTextAlignmentLeft];
    [self.orderTitle setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [self.orderTitle setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.orderTitle];
    
    [self.orderTime setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderTime setTextAlignment:NSTextAlignmentLeft];
    [self.orderTime setTextColor:[UIColor whiteColor]];
    [self.orderTime setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.orderTime];
    
    [self.orderDetail setFont:[UIFont systemFontOfSize:14.0]];
    [self.orderDetail setTextAlignment:NSTextAlignmentLeft];
    [self.orderDetail setTextColor:[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.0]];
    [self.orderDetail setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.orderDetail];
}

- (void)setModel:(JDOrderModel *)model
{
    self.orderModel = model;
    CGSize size = [model.hotel sizeWithFont:[UIFont systemFontOfSize:17.0]];
    [self.orderTitle setFrame:CGRectMake(80.0, 32.0 - size.height, size.width, size.height)];
    [self.orderTitle setText:model.hotel];
    
    NSString *time = [[NSString alloc] initWithFormat:@"%@\n%@", [[JDHXLUtil formatDate:[JDHXLUtil formatString:model.date withFormatter:DateFormatMDY] withFormatter:DateFormatYMD] substringFromIndex:5], [model.time substringToIndex:5]];
    size = [time sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [self.orderTime setFrame:CGRectMake(10.0, 20.0 - size.height, size.width, size.height)];
    [self.orderTime setText:time];
    
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
