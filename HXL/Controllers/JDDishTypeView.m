//
//  JDDishTypeView.m
//  HXL
//
//  Created by 刘斌 on 14-6-18.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDDishTypeView.h"

@implementation JDDishTypeView
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 2, 15, 15)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _count_bg = [[UIImageView alloc] initWithFrame:CGRectMake(72, 2, 15, 15)];
        [self.contentView addSubview:_count_bg];
        [self.contentView addSubview:_countLabel];
    }
    return self;
}

@end
