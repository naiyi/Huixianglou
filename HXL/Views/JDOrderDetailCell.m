//
//  JDOrderDetailCell.m
//  HXL
//
//  Created by Roc on 14-7-7.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDOrderDetailCell.h"

@implementation JDOrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        centerView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, 290.0, 65.0)];
        titleLabel = [[UILabel alloc] init];
        priceLabel = [[UILabel alloc] init];
        countLabel = [[UILabel alloc] init];
        goodButton = [[UIButton alloc] init];
        badButton = [[UIButton alloc] init];
        self.needGoodBad = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self addSubview:centerView];
    
    [titleLabel setFrame:CGRectMake(10.0, 0.0, 150.0, 33.0)];
    [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [centerView addSubview:titleLabel];
    
    [countLabel setFrame:CGRectMake(10.0, 33.0, 50.0, 32.0)];
    [countLabel setFont:[UIFont systemFontOfSize:16.0]];
    [countLabel setTextAlignment:NSTextAlignmentLeft];
    [countLabel setTextColor:[UIColor colorWithRed:0.392 green:0.235 blue:0.196 alpha:1.0]];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    [centerView addSubview:countLabel];
    
    [priceLabel setFrame:CGRectMake(50.0, 33.0, 50.0, 32.0)];
    [priceLabel setFont:[UIFont systemFontOfSize:16.0]];
    [priceLabel setTextAlignment:NSTextAlignmentLeft];
    [priceLabel setTextColor:[UIColor colorWithRed:0.765 green:0.039 blue:0.039 alpha:1.0]];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [centerView addSubview:priceLabel];
    
    [goodButton setFrame:CGRectMake(193.0, 22.0, 36.0, 21.0)];
    if (self.needGoodBad) {
        [goodButton setHidden:NO];
    } else {
        [goodButton setHidden:YES];
    }
    [goodButton addTarget:self action:@selector(onGoodBadClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:goodButton];
    
    [badButton setFrame:CGRectMake(244.0, 22.0, 36.0, 21.0)];
    if (self.needGoodBad) {
        [badButton setHidden:NO];
    } else {
        [badButton setHidden:YES];
    }
    [badButton addTarget:self action:@selector(onGoodBadClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:badButton];
}

- (void)setModel:(JDOrderDetailModel *)model andOrderID:(NSString *)order_id andIndex:(int)index
{
    self.model = model;
    self.order_id = order_id;
    if (index == 0) {
        [centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg_top"]]];
    } else if (index == -1) {
        [centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg_bottom"]]];
    } else {
        [centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg_center"]]];
    }
    [goodButton setImage:[UIImage imageNamed:@"good_normal"] forState:UIControlStateNormal];
    [goodButton setImage:[UIImage imageNamed:@"good_selected"] forState:UIControlStateSelected];
    [badButton setImage:[UIImage imageNamed:@"bad_normal"] forState:UIControlStateNormal];
    [badButton setImage:[UIImage imageNamed:@"bad_selected"] forState:UIControlStateSelected];
    
    if ([model.good_bad integerValue] == 1) {
        [goodButton setSelected:YES];
        [badButton setSelected:NO];
    } else if ([model.good_bad integerValue] == 0) {
        [badButton setSelected:YES];
        [goodButton setSelected:NO];
    } else {
        [goodButton setSelected:NO];
        [badButton setSelected:NO];
    }
    
    [titleLabel setText:model.dish_name];
    [countLabel setText:[NSString stringWithFormat:@"X%@", model.count]];
    [priceLabel setText:[NSString stringWithFormat:@"￥%@", model.price]];
}

- (void)onGoodBadClicked:(UIButton *)sender
{
    int good_bad = 0;
    if (sender == goodButton) {
        if (goodButton.selected) {
            [goodButton setSelected:NO];
            good_bad = -1;
        } else {
            [goodButton setSelected:YES];
            good_bad = 1;
        }
        [badButton setSelected:NO];
    } else if (sender == badButton) {
        if (badButton.selected) {
            [badButton setSelected:NO];
            good_bad = -1;
        } else {
            [badButton setSelected:YES];
            good_bad = 0;
        }
        [goodButton setSelected:NO];
    }
    NSDictionary *params = @{@"tel" : [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] objectForKey:@"tel"], @"good_bad" : [NSString stringWithFormat:@"%d", good_bad], @"dish_id" : [self.model dish_id], @"order_id" : self.order_id};
    [[JDOHttpClient sharedClient] getJSONByServiceName:GOOD_BAD modelClass:@"JDHXLModel" params:params success:^(JDHXLModel *dataModel) {
        if ([(NSNumber *)dataModel.data integerValue] == 1) {
            [self showToast:@"评价成功"];
        }
    } failure:^(NSString *errorStr) {
        [self showToast:@"评价提交失败"];
    }];
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
