//
//  JDOrderDetailBottomCell.m
//  HXL
//
//  Created by Roc on 14-7-8.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDOrderDetailBottomCell.h"

@implementation JDOrderDetailBottomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        centerView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, 290.0, 65.0)];
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 70.0, 65.0)];
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 0.0, 200.0, 65.0)];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg_bottom"]]];
    [self addSubview:centerView];
    
    [totalLabel setFont:[UIFont systemFontOfSize:20.0]];
    [totalLabel setTextAlignment:NSTextAlignmentLeft];
    [totalLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [totalLabel setBackgroundColor:[UIColor clearColor]];
    [centerView addSubview:totalLabel];

    [detailLabel setFont:[UIFont systemFontOfSize:16.0]];
    [detailLabel setTextAlignment:NSTextAlignmentLeft];
    [detailLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [centerView addSubview:detailLabel];
}

- (void)setModel:(NSString *)price andCount:(NSString *)count
{
    [totalLabel setText:@"合计："];
    [detailLabel setText:[NSString stringWithFormat:@"%@元，共%@菜", price, count]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
